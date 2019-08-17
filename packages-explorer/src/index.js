import "preact/devtools";
import React from "react";
import {render} from "react-dom";

import ready from "./lib/ready";
import App from "./app";
import "./lib/polyfills/fetch";

/**
 * Entry-point of the application.
 *
 * If any polyfilling is needed, do it here.
 * Then, start the app.
 */

// Starts the app.
ready(() => {
	const $node = document.getElementById("packages-explorer");
	render(<App />, $node);
});
