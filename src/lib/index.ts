import type { Post } from "$lib/types";
import { unified } from "unified";

import remarkParse from "remark-parse";
import remarkRehype from "remark-rehype";

import remarkGfm from "remark-gfm";
import remarkBreaks from "remark-breaks";
import remarkMath from "remark-math";
import remarkToc from "remark-toc";
import remarkDirective from "remark-directive";
import remarkFrontmatter from "remark-frontmatter";

import rehypeRaw from "rehype-raw";
import rehypeSanitize from "rehype-sanitize";
import rehypeSlug from "rehype-slug";
import rehypeAutolinkHeadings from "rehype-autolink-headings";
import rehypeKatex from "rehype-katex";
import rehypeStringify from "rehype-stringify";
import rehypeShikiFromHighlighter from "@shikijs/rehype/core";
import { createHighlighterCore } from "shiki/core";
import { createJavaScriptRegexEngine } from "shiki/engine/javascript";

const highlighter = await createHighlighterCore({
	themes: [import("@shikijs/themes/tokyo-night")],
	engine: createJavaScriptRegexEngine()
});

export const render_content = async (content: string): Promise<string> => {
	const file = await unified()
		.use(remarkParse)

		// GitHub flavored markdown
		.use(remarkGfm)

		// softbreaks -> <br>
		.use(remarkBreaks)

		// math support
		.use(remarkMath)

		// frontmatter support
		.use(remarkFrontmatter)

		// auto TOC
		.use(remarkToc, {
			heading: "table of contents"
		})

		// directives/custom blocks
		.use(remarkDirective)

		.use(remarkRehype, {
			allowDangerousHtml: true
		})

		// allow inline html
		.use(rehypeRaw)

		// sanitize AFTER raw html
		.use(rehypeSanitize)

		// heading ids
		.use(rehypeSlug)

		// clickable heading links
		.use(rehypeAutolinkHeadings, {
			behavior: "append"
		})

		// latex rendering
		.use(rehypeKatex)

		// syntax highlighting
		.use(rehypeShikiFromHighlighter, highlighter, {
			// or `theme` for a single theme
			themes: {
				light: "vitesse-light",
				dark: "vitesse-dark"
			}
		})
		.use(rehypeStringify)

		.process(content);
	return String(file);
};
