import adapterNode from '@sveltejs/adapter-node';
import adapterCloudflare from '@sveltejs/adapter-cloudflare';
import { vitePreprocess } from '@sveltejs/kit/vite';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: multiAdapter([adapterNode(), adapterCloudflare()])
	},
	preprocess: vitePreprocess()
};

export default config;

function multiAdapter(adapters) {
	return {
		name: 'multi-adapter',
		async adapt(arg) {
			await Promise.all(adapters.map(item => 
				Promise.resolve(item).then(resolved => resolved.adapt(arg))
			))
		}
	}
}