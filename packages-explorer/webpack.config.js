/* global require, module, __dirname */
const path = require("path");
const project_dir = path.resolve(__dirname);

module.exports = (env, argv) => ({
	entry: "./src/index.js",
	output: {
		filename: "bundle.js",
		path: path.resolve(project_dir, "dist"),
	},
	resolve: {
		alias: {
			"react": "preact-compat",
			"react-dom": "preact-compat",
			// Not necessary unless you consume a module using `createClass`
			"create-react-class": "preact-compat/lib/create-react-class"
		}
	},
	module: {
		rules: [
			{
				test: /.js$/,
				// ES2015 to JS, without some features:
				// → https://buble.surge.sh/guide/
				loaders: "buble-loader",
				include: path.join(project_dir, "src"),
				query: {objectAssign: "Object.assign"}
			},
			{
				test: /\.part\.html/,
				use: [{loader: "raw-loader"}]
			},
			{
				test: /\.less$/,
				use: [
					{loader: "style-loader"},
					{loader: "css-loader"},
					{loader: "less-loader"},
				]
			},
		]
	},
});
