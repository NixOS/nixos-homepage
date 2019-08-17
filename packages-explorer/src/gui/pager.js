import React from "react";
import {use} from "../state";
import {PER_PAGE} from "../conf";

/**
 * A button for the pager.
 */
const Button = ({disabled, ...props}) =>
	<button
		{...props}
		disabled={disabled}
		class={[
			props["class"],
			disabled ? "disabled" : ""
		].join(" ")}
	/>
;

const Pager = ({page, filtered_packages, change_page}) => {
	const amount = filtered_packages.length;
	const end = Math.ceil(amount / PER_PAGE) || 0;

	return (
		<ul class="pager">
			<li><Button class="first" disabled={page <= 1} onClick={() => change_page(1, {absolute: true})}>« First</Button></li>
			<li><Button class="previous" disabled={page <= 1} onClick={() => change_page(-1)}>‹ Previous</Button></li>
			<li><Button class="next" disabled={page >= end} onClick={() => change_page(1)}>Next ›</Button></li>
			<li><Button class="last" disabled={page >= end} onClick={() => change_page(amount, {absolute: true})}>Last »</Button></li>
		</ul>
	);
};

export default use([
	"page",
	"filtered_packages"
], ["change_page"], Pager);
