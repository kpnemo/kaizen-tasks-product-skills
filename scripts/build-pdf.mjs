#!/usr/bin/env node
// Render the two printable Part 3 templates to PDF with Playwright's Chromium.
// Usage: npm run pdf   (needs: npx playwright install chromium)
// Canvas is A4 landscape; plan is A4 portrait. Large type for print.

import { readFile, stat } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { marked } from 'marked';
import { chromium } from 'playwright';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const templatesDir = path.join(repoRoot, 'templates', 'part3');

/** @type {{ md: string; pdf: string; landscape: boolean; rowHeightMm: number }[]} */
const jobs = [
  {
    md: 'agentic-layer-canvas.md',
    pdf: 'agentic-layer-canvas.pdf',
    landscape: true,
    rowHeightMm: 22,
  },
  { md: 'plan-30-60-90.md', pdf: 'plan-30-60-90.pdf', landscape: false, rowHeightMm: 14 },
];

/**
 * Minimal print stylesheet. The first table on each page is the Team/Date
 * header; the second is the grid people write in, so its rows get the height.
 * @param {number} rowHeightMm
 */
function stylesheet(rowHeightMm) {
  return `
    @page { margin: 12mm; }
    * { box-sizing: border-box; }
    body { font-family: Helvetica, Arial, "Liberation Sans", sans-serif; color: #111; margin: 0; }
    h1 { font-size: 22pt; margin: 0 0 4mm 0; }
    h2 { font-size: 15pt; margin: 5mm 0 2mm 0; }
    p, li { font-size: 12pt; line-height: 1.35; margin: 0 0 2mm 0; }
    ol { margin: 0; padding-left: 7mm; }
    li { min-height: 9mm; }
    table { width: 100%; border-collapse: collapse; table-layout: fixed; margin: 0 0 4mm 0; }
    th, td { border: 0.4mm solid #111; padding: 2mm; vertical-align: top; font-size: 12pt; text-align: left; }
    th { background: #eee; font-size: 13pt; }
    table:nth-of-type(1) td { height: 10mm; }
    table:nth-of-type(2) td { height: ${rowHeightMm}mm; }
    table:nth-of-type(2) th:first-child, table:nth-of-type(2) td:first-child { width: 22%; font-size: 11pt; }
  `;
}

const browser = await chromium.launch();
try {
  for (const job of jobs) {
    const markdown = await readFile(path.join(templatesDir, job.md), 'utf8');
    const body = await marked.parse(markdown);
    const html = `<!doctype html><html><head><meta charset="utf-8"><title>${job.md}</title><style>${stylesheet(job.rowHeightMm)}</style></head><body>${body}</body></html>`;
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'load' });
    const outPath = path.join(templatesDir, job.pdf);
    await page.pdf({
      path: outPath,
      format: 'A4',
      landscape: job.landscape,
      printBackground: true,
      margin: { top: '12mm', right: '12mm', bottom: '12mm', left: '12mm' },
    });
    await page.close();
    const { size } = await stat(outPath);
    if (size === 0) {
      throw new Error(`${job.pdf} is empty`);
    }
    const orientation = job.landscape ? 'landscape' : 'portrait';
    console.log(`wrote templates/part3/${job.pdf} (${size} bytes, A4 ${orientation})`);
  }
} finally {
  await browser.close();
}
