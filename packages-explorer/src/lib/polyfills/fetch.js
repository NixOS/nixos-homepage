import bsod from "../bsod";

/**
 * Not an actual polyfill for fetch.
 *
 * This is a graceful degradation.
 */

/**
 * Message on failure.
 */
const FETCH_MISSING = "A browser implementing `window.fetch` is required for this page to work properly.";

/**
 * Replaces fetch when fetch is missing.
 *
 * This will `bsod` only when fetch is attempted.
 */
const pseudo_fetch = function() {
	bsod(FETCH_MISSING);
};

// Ensures calls to `fetch` don't crash the app.
if (!window.fetch) {
	console.warn(FETCH_MISSING); // eslint-disable-line
	window.fetch = pseudo_fetch; // eslint-disable-line
}
