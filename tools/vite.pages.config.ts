import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { viteSingleFile } from 'vite-plugin-singlefile';

// GitHub Pages 版：全部打包進單一 HTML，之後再用 StatiCrypt 整份加密；不用 PWA
export default defineConfig({
  base: '/TRM-Discuss/',
  plugins: [react(), viteSingleFile()],
  build: { outDir: 'dist-pages', chunkSizeWarningLimit: 99999, assetsInlineLimit: 100000000 },
});
