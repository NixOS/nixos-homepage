// This file is long...
/* eslint max-lines: "off" */

import React, {Component} from "react";
import pick from "lodash/pick";
import queryString from "query-string";
import debounce from "lodash/debounce";
import fromPairs from "lodash/fromPairs";
import isEqual from "lodash/isEqual";
import mapValues from "lodash/mapValues";
import {PER_PAGE} from "./conf";
import refilter from "./refilter";

const DEBOUNCE = 300;

const SYNCHRONIZED = [
	"attr",
	"channel",
	"page",
	"query",
	"unfree",
];

const CALLBACKS = [
	"apply_state",
	"change_page",
	"select_attr",
	"set_channel",
	"set_query",
	"set_unfree",
	"url_for_state",
];

/**
 * "unset" state for SYNCHRONIZED.
 */
const INITIAL_STATE = {
	attr: null,
	channel: null,
	page: 1,
	query: "",
	unfree: false,
};

/**
 * App's state and callbacks.
 *
 * This is built in a way that forces components to declare what they want to use
 * from the state. Once declared, it is made available as props.
 *
 * See this as a poor man's redux store, but with tighter control.
 *
 * Some of this app's state is synchronized in the URL.
 *
 * Everything else is internal (large data mainly).
 */
class State extends Component {
	constructor() {
		super();

		this.state = Object.assign({
			loading: 0,
			channels: [],
			channel_data: null,
			filtered_packages: [],
			current_results: [],
		}, INITIAL_STATE);

		// Binding functions to `this` for use as callbacks.
		// `handle_popstate` is used to link history with state.
		["handle_popstate"]
			.concat(CALLBACKS)
			.forEach((fn) => { this[fn] = this[fn].bind(this); });

		this.refilter = debounce(this.refilter, DEBOUNCE);
	}

	handle_popstate(e) {
		let state = {};
		if (e.state) {
			state = e["state"];
		}
		else {
			state = queryString.parse(location.search);
		}
		const new_state = fromPairs(SYNCHRONIZED.map((name) => [name, INITIAL_STATE[name]]));

		this.setState(Object.assign(new_state, state), {push: false});
	}

	componentWillMount() {
		const params = queryString.parse(location.search);
		const {history} = window;
		const state = Object.assign({}, params, history.state);
		this.setState(state);

		this.fetch_channels()
			.then(() => {
				this.fetch_channel();
			})
		;
		window.addEventListener("popstate", this.handle_popstate);
	}

	setState(new_state, {push = true, force = false} = {}, ...args) {
		const {history} = window;
		const params = this.url_params_for_state(new_state);

		// Applies the state change.
		super.setState(new_state, ...args);

		// History modification won't fire on "identity" change.
		if (!force && isEqual(params, queryString.parse(window.location.search))) {
			return;
		}

		let method = push ? "pushState" : "replaceState";

		// Assumes that from no querystring to querystring is replace.
		// This saves one "weird" state replacement.
		if (Object.keys(params).length > 0 && window.location.search.length === 0) {
			method = "replaceState";
		}

		if (queryString.stringify(params).length > 0) {
			history[method](params, "", `?${queryString.stringify(params)}`);
		}
		else {
			history[method](params, "", window.location.pathname);
		}
	}

	componentDidUpdate(prev_props, prev_state) {
		if (prev_state["channel"] !== this.state["channel"]) {
			this.fetch_channel();

			return;
		}

		const {state} = this;
		if (
			state["query"] !== prev_state["query"] ||
			state["unfree"] !== prev_state["unfree"]
		) {
			this.refilter();
		}
	}

	fetch_channels() {
		this.setState({loading: this.state.loading + 1});

		return fetch("/nixpkgs/packages-channels.json", {mode: "cors"})
			.then((response) => response.json())
			.then((channels) => {
				this.setState({
					channels,
					loading: this.state.loading - 1
				});

				// No channel in state (from initial state)
				if (!this.state.channel) {
					const channel = channels[0];
					this.setState({channel});
				}
			})
		;

	}

	fetch_channel() {
		const {channel} = this.state;
		this.setState({loading: this.state.loading + 1});
		const {hostname} = window.location;

		// Some (most?) development environment don't really like to serve .gz files.
		const dev = window.DEVELOPMENT || hostname === "localhost" || hostname === "127.0.0.1";
		const ext = dev ? "json" : "json.gz";
		fetch(`/nixpkgs/packages-${channel}.${ext}`, {mode: "cors"})
			.then((response) => response.json())
			.then((channel_data) => {
				// Ensures we update only for the currently selected channel.
				if (this.state.channel === channel) {
					channel_data.packages = mapValues(channel_data.packages, (p, attr) => Object.assign({attr}, p));
					this.setState({channel_data});
					this.refilter();
				}
			})
		;

	}

	change_page(delta = null, {absolute} = {absolute: false}) {
		const {filtered_packages} = this.state;
		let page = parseInt(this.state.page, 10);

		if (absolute) {
			page = delta;
		}
		else {
			page += delta;
		}

		if (!page || page < 1) {
			page = 1;
		}

		const max_page = Math.ceil(filtered_packages.length / PER_PAGE);

		if (page > max_page) {
			page = max_page;
		}

		const beg = (page - 1) * PER_PAGE;
		const end = page * PER_PAGE;

		const current_results = filtered_packages.slice(beg, end);

		this.setState({
			page,
			current_results
		});
	}

	set_channel(channel) {
		this.setState({channel});
	}

	set_query(query, push = false) {
		this.setState({query}, {push});
	}

	set_unfree(unfree) {
		this.setState({unfree});
	}

	select_attr(attr) {
		const {selected} = this.state;
		if (attr === selected) {
			this.setState({selected: null});
		}
		else {
			this.setState({selected: attr});
		}
	}

	getChildContext() {
		const {state} = this;

		return {
			app_state: {
				state,
				callbacks: pick(this, CALLBACKS),
			}
		};
	}

	refilter() {
		if (!this.state.channel_data) {
			return;
		}
		const {query, channel_data: {packages}, unfree} = this.state;
		const filtered_packages = refilter(query, packages, {withUnfree: unfree});
		this.setState({
			filtered_packages,
			loading: 0
		});
		this.change_page();
	}

	/**
	 * Given a state, applies it.
	 */
	apply_state(state, {merge = true}) {
		let new_state = {};
		if (!merge) {
			new_state = fromPairs(SYNCHRONIZED.map((name) => [name, INITIAL_STATE[name]]));
		}
		new_state = Object.assign(
			new_state,
			state
		);
		this.setState(new_state);
	}

	/**
	 * Gives an URL for the new state given.
	 */
	url_for_state(state, {merge = true}) {
		let params = Object.assign({}, state);
		if (merge) {
			params = this.url_params_for_state(state);
		}

		const {pathname} = window.location;

		if (queryString.stringify(params).length > 0) {
			return `${pathname}?${queryString.stringify(params)}`;
		}

		return pathname;
	}

	/**
	 * Given a state, returns the (merged) current state and
	 * new state parameters for URL generation.
	 */
	url_params_for_state(state) {
		const params = pick(Object.assign({}, this.state, state), SYNCHRONIZED);

		Object.keys(params).forEach((k) => {
			if (k === "page" && params[k] <= 1) {
				Reflect.deleteProperty(params, k);
			}
			if (params[k]) {
				params[k] = params[k].toString();
			}
			else {
				Reflect.deleteProperty(params, k);
			}
		});

		return params;
	}

	render({children}) {
		return children;
	}
}

/**
 * Given a component, returns the display name.
 */
function getDisplayName(WrappedComponent) {
	// https://reactjs.org/docs/higher-order-components.html#convention-wrap-the-display-name-for-easy-debugging
	return WrappedComponent.displayName || WrappedComponent.name || "Component";
}

/**
 * Declares a `Wrapped` component as using properties (`state`) and callbacks (`callback_names`) from state.
 */
const use = (state, callback_names, Wrapped) => {
	const C = (props, {app_state}) => {
		const state_data = pick(app_state.state, state);
		const callbacks = pick(app_state.callbacks, callback_names);
		return <Wrapped {...state_data} {...callbacks} {...props} />;
	};

	C.displayName = `use(${getDisplayName(Wrapped)})`;

	return C;
};

export {use};
export default State;
