import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    exclude: ['**/dist/**', '**/node_modules/**'],
    coverage: {
      exclude: [
        '**/src/**/*.test.ts',
        '**/dist/**',
        '**/node_modules/**',
        '**/vite.config.ts',
        '**/vitest.config.ts',
      ],
      all: true,
    },
  },
})
