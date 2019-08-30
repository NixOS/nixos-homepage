import React from "react";
import {use} from "../state";
import Loading from "./loading";
import Header from "./header";
import Results from "./results";

const Gui = ({loading, channel_data}) =>
	<div id="packages-explorer" class="app">
		<Header />
		<hr />
		{
			channel_data && !loading
				? <Results />
				: <Loading />
		}
	</div>
;

export default use(
	[
		"loading",
		"channel_data",
	],
	[],
	Gui
);
