// Capture Instacart's current persisted-query hashes.
//
// Instacart's web client sends Apollo persisted queries (an operation name +
// a SHA-256 hash). Those hashes rotate whenever Instacart ships a new frontend
// build, so `lib/instacart_api/persisted_queries.rb` needs periodic refreshing.
//
// This opens a real browser, waits for you to log in and drive the shopping
// flow (search, add an item to the cart), and records every /graphql call to
// calls.jsonl. Then run `ruby extract_hashes.rb` to turn that into the hash
// map you paste into persisted_queries.rb.
//
//   npm install playwright && npx playwright install chromium
//   node capture.js
//   ruby extract_hashes.rb
const { chromium } = require("playwright");
const fs = require("fs");
const path = require("path");

const OUT = path.join(__dirname, "calls.jsonl");
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

(async () => {
  const browser = await chromium.launch({ headless: false });
  const context = await browser.newContext();
  const page = await context.newPage();

  const out = fs.createWriteStream(OUT, { flags: "w" });
  page.on("request", (req) => {
    if (!/instacart\.com\/graphql/.test(req.url())) return;
    out.write(JSON.stringify({
      method: req.method(), url: req.url(), post: req.postData() || null,
    }) + "\n");
  });

  await page.goto("https://www.instacart.com/login", {
    waitUntil: "domcontentloaded",
  });
  console.log(
    "\nLog in, then: pick a store, SEARCH for an item, and ADD one to your cart."
  );
  console.log("Capturing /graphql calls... this window closes automatically.\n");

  // Capture for a fixed window; exit ~15s after a cart mutation is seen.
  let sawMutation = false;
  page.on("request", (req) => {
    if (/UpdateCartItemsMutation|updateCartItems/.test(req.postData() || "")) {
      sawMutation = true;
    }
  });
  let mutAt = null;
  for (let i = 0; i < 200; i++) {
    await sleep(3000);
    if (sawMutation && mutAt === null) mutAt = i;
    if (mutAt !== null && i - mutAt >= 5) break;
  }

  out.end();
  console.log(`Wrote ${OUT}. Now run: ruby ${__dirname}/extract_hashes.rb`);
  await browser.close();
  process.exit(0);
})();
