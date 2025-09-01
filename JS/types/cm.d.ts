/// <reference types="node"/>

import type { load as cheerioLoad } from 'cheerio'

declare global {
  const cheerio: {
    load: typeof cheerioLoad;
  }
}

export {};