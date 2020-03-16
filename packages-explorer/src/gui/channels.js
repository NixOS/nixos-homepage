import React, {Component} from "react";
import {use} from "../state";

/**
 * Button component which shows up as *something else* than a classic radio
 * button.
 *
 * The state is needed for the focus state.
 */
class Button extends Component {
	constructor(props) {
		super(props);
		this.state = {focus: false};
	}

	render() {
		const {active, name, value, set_channel} = this.props;
		const {focus} = this.state;

		return (
			<div class="radio-button">
				<label
					class={[
						"btn",
						active ? "active" : "not-active",
						focus ? "focus" : "not-focus",
					].join(" ")}
				>
					<input
						type="radio"
						name={name}
						value={value}
						checked={active}
						onChange={(event) => set_channel(event.target.value)}
						onFocus={() => this.setState({focus: true})}
						onBlur={() => this.setState({focus: false})}
					/>
					<span>{value}</span>
				</label>
			</div>
		);
	}
}

const Channels = ({channels, channel, set_channel}) =>
	<div class="channels-selector">
		<label>Channel</label>
		<div class="channels-selector--options">
			{channels.map((c) => <Button key={c} name="channel" value={c} active={channel === c} set_channel={set_channel} />)}
		</div>
	</div>
;

export default use(
	[
		"channel",
		"channels"
	],
	["set_channel"],
	Channels
);
