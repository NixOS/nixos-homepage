import "./styles";
import "./lib/polyfills/fetch";
import React from "react";
import State from "./state";
import Gui from "./gui";

const App = () =>
	<State>
		<Gui />
	</State>
;

export default App;
