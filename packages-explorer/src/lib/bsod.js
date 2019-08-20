/**
 * Bad screen of death.
 *
 * Replaces the whole body with an error message.
 */
const bsod = function(msg = "Something happened.") {
	const el = document.getElementById("packages-explorer");
	const newEl = document.createElement("div");
	newEl.innerHTML =
`Something went wrong...

-> ${msg}

Please <a href="https://github.com/NixOS/nixos-homepage/issues/new">report a bug</a> with details stating what you were doing and the full message, we may be able to resolve the situation.`;
	el.parentNode.replaceChild(newEl, el);
	newEl.className = "bsod";
};

window.bsod = bsod;
export default bsod;
