import React from "react";
import {use} from "../state";
import flatten from "lodash/flatten";
import Pager from "./pager";
import Result, {ResultDetails} from "./result";
import Link from "../link";
import {PER_PAGE} from "../conf";

const Commit = use(["channel_data"], [],
	({channel_data: {commit} = {}}) =>
		<p class="channel_data">
			<em>
				<tt class="channel">{"<nixpkgs>"}</tt>
				{" "}commit{" "}
				<a href={`https://github.com/NixOS/nixpkgs-channels/commit/${commit}`} class="commit">{commit}</a>
				
			</em>
		</p>
);

const Count = use(
	[
		"page",
		"filtered_packages",
	], [],
	({page, filtered_packages}) => {
		const amount = filtered_packages.length;
		const first = (page - 1) * PER_PAGE + 1;
		const last = Math.min(amount, page * PER_PAGE);

		return (
			<p class="results_count">
				<em>Showing results {first}-{last} of {amount}</em>
			</p>
		);
	}
);

const Page = use(
	[
		"page",
		"filtered_packages",
	], [],
	({page, filtered_packages}) => {
		const amount = filtered_packages.length;
		const last_page = Math.ceil(amount / PER_PAGE);
		return (
			<div>Page {page}/{last_page}</div>
		);
	}
);

const Results = ({attr, channel_data: {packages}, current_results, filtered_packages}) => {
	let results = current_results;

	const additional_result_props = {};

	if (attr) {
		if (!packages[attr]) {
			return <div />;
		}
		results = [packages[attr]];
		additional_result_props["selected"] = attr;
	}

	const table =
		<div class="results-table">
			<table class="table table-hover" id="search-results">
				<thead>
					<tr><th>Package name</th><th>Attribute name</th><th>Description</th></tr>
				</thead>
				<tbody>
					{
						flatten(results.map((r, i) =>
							[
								<Result key={r["attr"]} even={i % 2 === 0} result={r} {...additional_result_props} />,
								<ResultDetails key={r["attr"] + "$details"} even={i % 2 === 0} result={r} {...additional_result_props} />,
							]
						))
					}
				</tbody>
			</table>
		</div>
		;

	if (attr) {
		return (
			<div>
				<div>
					<Link merge={true} state={{attr: null}} class="results--back">
						Show all results
					</Link>
				</div>
				{table}
				<Commit />
			</div>
		);
	}


	return (
		<section class="results">
			{
				filtered_packages.length < 1
					? <p class="empty">No results found.</p>
					: <div>
						<Count />
						<Pager />
						{table}
						<Page />
						<Pager />
						<Commit />
					</div>
			}
		</section>
	);
};

export default use(
	[
		"channel_data",
		"current_results",
		"filtered_packages",
		"attr",
	],
	[],
	Results
);
