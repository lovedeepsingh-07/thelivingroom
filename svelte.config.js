import { mdsvex } from "mdsvex";
import adapter_auto from "@sveltejs/adapter-auto";
import adapter_cloudflare from "@sveltejs/adapter-cloudflare";

const nix_build = process.env.NIX_BUILD;

/** @type {import('@sveltejs/kit').Config} */
const config = {
	compilerOptions: {
		runes: ({ filename }) => (filename.split(/[/\\]/).includes("node_modules") ? undefined : true)
	},
	kit: {
		adapter: nix_build
			? adapter_cloudflare({
					fallback: "index.html"
				})
			: adapter_auto({
					fallback: "index.html"
				}),
		alias: {
			"$components/*": "./src/components/*",
			$components: "./src/components/index.ts"
		}
	},
	preprocess: [mdsvex({ extensions: [".svx", ".md"] })],
	extensions: [".svelte", ".svx", ".md"]
};

export default config;
