import React from "react";
import {use} from "../state";

const Query = ({query, set_query}) =>
	<div>
		<input
			name="query"
			type="text"
			class="search-query span3"
			placeholder="Search by name or description (regex allowed)"
			id="search"
			defaultValue={query}
			onChange={(event) => set_query(event.target.value)}
			onBlur={(event) => set_query(event.target.value, true)}
		/>
	</div>
;

export default use(
	["query"],
	["set_query"],
	Query
);
