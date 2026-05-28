<script lang="ts">
	import type { Post } from "$lib/types";
	import type { PageProps } from "./$types";

	const { data }: PageProps = $props();
</script>

{#await data.post}
	<p>loading...</p>
{:then curr_post: Post}
	{@const _ = console.log(curr_post)}
	<div class="flex flex-col items-start">
		<h1 class="text-4xl">{curr_post.title}</h1>
		<p class="text-lg">{curr_post.description}</p>
		<div class="flex items-center justify-start gap-[6px] text-sm text-black italic">
			{#each curr_post.tags as curr_tag: string}
				<div class="rounded-lg bg-gray-500 px-2">{curr_tag}</div>
			{/each}
		</div>
		<div class="prose mt-[40px] mb-[80px] dark:prose-invert">
			{@html curr_post.content}
		</div>
	</div>
{/await}
