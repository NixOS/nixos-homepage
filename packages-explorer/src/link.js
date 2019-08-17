import React from "react";
import {use} from "./state";

/**
 * Link that knows about `State` and manipulates directly when
 * followed normally, and has the `href` pointing to an equivalent
 * state.
 *
 * The `onClick` behaviour can be customized as it won't be overridden.
 *
 * The `href` is always overridden.
 */
const Link = ({
	merge = false,
	state,
	url_for_state,
	apply_state,
	...leftOver
}) =>
	<a
		onClick={(e) => {
			e.preventDefault();
			apply_state(state, {merge});
		}}
		{...leftOver}
		href={url_for_state(state, {merge})}
	/>
;

export default use([], ["url_for_state", "apply_state"], Link);
