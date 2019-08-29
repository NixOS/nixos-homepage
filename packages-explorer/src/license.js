import React from "react";

//
// Code lifted from current nixos.org website.
//

// Try to figure out a human-readable name for a license object.
// Use the long name first; failing that try the SPDX ID or short name.
// If all else fails fall back on URL.
function licenseName(license) {
	return license.fullName ||
		license.spdxId ||
		license.shortName ||
		license.url ||
		"(Licence name missing)";
}

// Given a license, or array of licenses, generate and return a DOM node
// containing information about it/them.
// A license can be a plain string (in which case it returns the string itself
// as a text node), or a license object, in which case it attempts to construct
// a link to the license's URL (if specified).
const License = ({license}) => {
	if (!license) {
		return null;
	}

	if (typeof license === "string") {
		return <span>{license}</span>;
	}

	if (Array.isArray(license)) {
		return (
			<ul>
				{license.map((l, i) => <li key={i}><License license={l} /></li>)}
			</ul>
		);
	}

	if (license.url) {
		return <a href={license["url"]} rel="nofollow">{licenseName(license)}</a>;
	} 

	return <span>{licenseName(license)}</span>;
};

export default License;

const isUnfree = (license) => license && license.free === false;

export {isUnfree};
