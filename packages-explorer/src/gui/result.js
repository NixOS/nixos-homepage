import React from "react";
import get from "lodash/get";
import {use} from "../state";
import FormattedLicense from "../license";
import Link from "../link";

/**
 * All known platforms the widget can show.
 * Further functions will filter the ones to show.
 */
const PLATFORMS = [
	"x86_64-linux",
	"aarch64-linux",
	"x86_64-darwin",
	"i686-linux",
];

const Result = ({
	result,
	result: {name, attr, meta: {description} = {}},
	even,
	selected,
	select_attr,
}) =>
	<tr
		class={[
			"result",
			even ? "even" : "odd",
			selected === attr ? "is-selected" : "is-not-selected",
		].join(" ")}
		onClick={() => select_attr(attr)}
	>
		<td>
			<button
				onClick={(e) => {
					e.stopPropagation();
					select_attr(attr);
				}}
			>{name}</button>
		</td>
		<td>{attr}</td>
		<td>{description}</td>
	</tr>
;

export default use(["selected"], ["select_attr"], Result);

const NotSpecified = () => <em>Not specified</em>;
const hydraLink = (attribute, platform, branch) => `https://hydra.nixos.org/job/${branch}/${attribute}.${platform}`;
const githubLink = (commit, position) => `https://github.com/NixOS/nixpkgs/blob/${commit}/${position.replace(":", "#L")}`;

const Install = use(["channel"], [], ({result, channel}) =>
	<tr>
		<th>Install command</th>
		<td>
			<tt>
				<span class="command">
					nix-env -iA {channel.replace(/-.*/, "")}.<span class="attrname">{result["attr"]}</span>
				</span>
			</tt>
		</td>
	</tr>
);

const Position = use(["channel_data"], [], ({channel_data: {commit}, result: {meta: {position}}}) =>
	<tr>
		<th>Nix expression</th>
		<td>
			{
				position && commit
					? <a href={githubLink(commit, position||"")}>
						{position.replace(/:[0-9]+$/, "")}
					</a>
					: <NotSpecified />
			}
		</td>
	</tr>
);

const channel_to_jobset = (channel) => {
	switch (channel) {
	case "nixos-unstable":
		return "nixos/trunk-combined";
	case "nixpkgs-unstable":
		return "nixpkgs/trunk";
	default:
		return channel.replace(/^nixos-/, "nixos/release-");
	}
};

const normalize_attrname = (name, channel) =>
	channel.match(/^nixos-/) ? `nixpkgs.${name}` : name;

const Platform = ({platform, attr, channel}) =>
	<li key={platform}>
		<a href={hydraLink(normalize_attrname(attr, channel), platform, channel_to_jobset(channel))}>
			<tt>{platform}</tt>
		</a>
	</li>
;

/**
 * Removes non-nixos platforms from nixos channels.
 */
const platforms_for_channel = (channel) =>
	(platform) => !(channel.match(/^nixos-/) && platform.match(/-darwin$/));

const Platforms = use(["channel"], [], ({channel, result: {attr, meta: {platforms}}}) =>
	<tr>
		<th>Platforms</th>
		<td>
			{
				!platforms || platforms.length < 1 ? <NotSpecified />
					: <ul class="platforms-list">
						{
							PLATFORMS
								.filter(platforms_for_channel(channel))
								.filter((platform) => platforms.indexOf(platform) > -1)
								.map((platform) => <Platform key={platform} platform={platform} attr={attr} channel={channel} />)
						}
					</ul>
			}
		</td>
	</tr>
);

const Homepage = ({result: {meta: {homepage}}}) =>
	<tr>
		<th>Homepage</th>
		<td>
			{
				homepage && homepage.length > 0
					? <a href={homepage} rel="nofollow">{homepage}</a>
					: <NotSpecified />
			}
		</td>
	</tr>
;

const License = ({result: {meta: {license}}}) =>
	<tr>
		<th>License</th>
		<td>
			{
				license
					? <FormattedLicense license={license} />
					: <NotSpecified />
			}
		</td>
	</tr>
;

const Maintainers = ({result: {meta: {maintainers}}}) =>
	<tr>
		<th>Maintainers</th>
		<td>
			{
				maintainers && maintainers.length > 0
					? <span>{
						maintainers
							.map((m) => `${m.name} <${m.email}>`)
							.join(", ")
					}</span>
					: <NotSpecified />
			}
		</td>
	</tr>
;

const LongDescription = ({result: {meta: {longDescription}}}) =>
	<tr>
		<th>Long description</th>
		<td class="long-description pre">
			{
				longDescription && longDescription.length > 0
					? <div>{longDescription}</div>
					: <NotSpecified />
			}
		</td>
	</tr>
;

const ROWS = [
	Install,
	Position,
	Platforms,
	Homepage,
	License,
	Maintainers,
	LongDescription,
];

const ResultDetails = ({
	result,
	result: {attr},
	even,
	selected,
}) =>
	<tr
		key="details"
		class={[
			"details",
			even ? "even" : "odd",
			selected === attr ? "is-selected" : "is-hidden",
		].join(" ")}
	>
		<td colspan={3}>
			<div class="search-details">
				<table>
					<tbody>
						{ROWS.map((Row, i) => <Row result={result} key={i} />)}
					</tbody>
				</table>
				<div class="result--permalink">
					<Link merge={true} state={{attr}}>
						Permalink to <tt>{attr}</tt>
					</Link>
				</div>
			</div>
		</td>
	</tr>
		;

const ResultDetailsWrapped = use(["selected"], [], ResultDetails);
export {ResultDetailsWrapped as ResultDetails};
