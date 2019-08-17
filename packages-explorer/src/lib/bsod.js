/**
 * Bad screen of death.
 *
 * Replaces the whole body with an error message.
 */
const bsod = function(msg = "Something happened.") {
	const el = document.getElementById("packages-explorer");
	el.innerText =
`Something went wrong...

-> ${msg}

Please contact us with details stating what you were doing
and the full message, we may be able to resolve the situation.
`;
	el.className = "bsod";
};

export default bsod;
