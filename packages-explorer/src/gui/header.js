import React from "react";
import Channels from "./channels";
import Query from "./query";
import Unfree from "./unfree";

const Header = () =>
	<header>
		<Channels />
		<Query />
		<Unfree />
	</header>
;

export default Header;
