import React from "react";
import {use} from "../state";

const Unfree = ({unfree, set_unfree}) =>
	<div class="form-checkbox">
		<label>
			<input
				name="unfree"
				type="checkbox"
				checked={unfree}
				onClick={(event) => set_unfree(event.target.checked)}
			/><span>Show unfree packages</span>
		</label>
	</div>
;

export default use(
	["unfree"],
	["set_unfree"],
	Unfree
);
