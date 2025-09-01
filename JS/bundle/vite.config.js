import { defineConfig } from 'vite';
import path from 'path';

export default defineConfig({
  build: {
    outDir: 'dist',
    lib: {
      entry: path.resolve(__dirname, 'src/main.js'),
      name: 'cheerio',
      fileName: (format) => `cheerio.${format}.js`,
      formats: ['es', 'umd', 'cjs']
    },
    rollupOptions: {
      external: [],
      output: {
        exports: 'named',
        inlineDynamicImports: true
      }
    }
  },
  define: {
    'process.env': {}
  }
});
    