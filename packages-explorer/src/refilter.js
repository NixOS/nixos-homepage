import escapeRegExp from "lodash/escapeRegExp";
import find from "lodash/find";
import {isUnfree} from "./license";


const WHITESPACES = / +/;
const STARTS_AND_ENDS_WITH_START_AND_ENDS = /^\^.*\$$/;

/**
 * Finds packages matching search terms and returns a subset as an array.
 */
const refilter = (search = "", packages, {withUnfree = false} = {}) => {
	let attrs = Object.keys(packages);
	let words = search
		.toLowerCase()
		.split(WHITESPACES)
		.filter(Boolean)
	;

	// Short-circuits regexp like ^$
	// Otherwise, the word breaking algorithm beforehand might play
	// tricks on unsuspecting regexers.
	if (search.match(STARTS_AND_ENDS_WITH_START_AND_ENDS)) {
		words = [search];
	}

	// Converts to regexes, when possible.
	words = words.map((word) => {
		try {
			return new RegExp(word);
		}
		catch (e) {
			return new RegExp(escapeRegExp(word));
		}
	});

	attrs = attrs.filter((attr) => {
		var info = packages[attr];
		var description = info["meta"]["description"] || "";
		var longDescription = info["meta"]["longDescription"] || "";

		function match(word) {
			return find([
				attr.toLowerCase(),
				info["name"].toLowerCase(),
				description.toLowerCase(),
				longDescription.toLowerCase(),
			], (value) => value.match(word));
		}


		let kept = true;
		kept = kept && words.every(match);
		if (!withUnfree) {
			kept = kept && !isUnfree(info["meta"]["license"]);
		}

		return kept;
	});

	const results = attrs.sort((a, b) => {
		var ia = packages[a]["name"].toLowerCase();
		var ib = packages[b]["name"].toLowerCase();
		if (ia < ib) {
			return -1;
		}
		if (ia > ib) {
			return 1;
		}

		if (a === b) {
			return 0;
		}
		
		return a < b ? -1 : 1;
	});

	return results.map((attr) => packages[attr]);
};

export default refilter;
