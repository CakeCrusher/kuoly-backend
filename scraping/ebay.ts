import fetch from "node-fetch";
import cheerio from "cheerio";
import { ScrapedFeatures } from "../types";
import { UserInputError } from "apollo-server-express";

export const scrapeListingByName = async (
  name: string
): Promise<ScrapedFeatures> => {
  let features: ScrapedFeatures = {
    item_url: null,
    name: null,
    image_url: null,
    price: null,
    description: null,
  };
  const timeStart = Date.now();
  const formattedItem = encodeURIComponent(name).replace(/%20/g, "+");
  const URL = `https://www.ebay.com/sch/i.html?_nkw=${formattedItem}`;
  const ebay_res = await fetch(URL);
  console.log("ebay_res: ", ebay_res.status);
  try {
    const html = await ebay_res.text();
    const $ = cheerio.load(html);
    // get the element with id=srp-river-results and find the first ul element
    const head = $("#srp-river-results").find("ul").first();

    let features_scraped: ScrapedFeatures;
    // get only the first non sponsored listing
    const firstListing = head
      .find("li.s-item")
      .first()
      .not(".s-item--sponsored");

    const img = firstListing.find("img").attr("src");
    const itemName = firstListing.find("span[role='heading']").text();

    const price = parseFloat(
      firstListing.find("span.s-item__price").text().replace("$", "")
    );
    const itemURL = firstListing.find("a").attr("href");

    // the cost of description if a 3 second delay
    // features = await scrapeListingByUrl(itemURL);
    features_scraped = {
      item_url: itemURL,
      name: itemName,
      image_url: img,
      price: price || null,
      description: itemName,
    };

    const timeEnd = Date.now();
    console.log(`Scraping ${name} took ${timeEnd - timeStart}ms`);
    console.log("features_scraped: ", features_scraped);
    return features_scraped;
  } catch {}
  return features;
};

export const scrapeListingByUrl = async (
  url: string
): Promise<ScrapedFeatures> => {
  // fetch the item name, price, and image url from an amazon link
  const amazon_res = await fetch(url);
  if (!amazon_res.ok) throw new UserInputError("Invalid URL or item name");

  const html = await amazon_res.text();
  const $ = cheerio.load(html);
  const image = $("#imgTagWrapperId img").attr("src");
  const name = $("#productTitle").text().replace(/\s\s+/g, " ").trim();
  const description = $("#feature-bullets")
    .find("ul")
    .first()
    .find("li")
    .slice(1, -1)
    .text()
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, 200);

  let price;
  const priceRaw = $("#corePrice_desktop div table tbody span.apexPriceToPay")
    .eq(0)
    .text();

  price = parseFloat(priceRaw.split("$")[1]);
  if (!price) {
    const newPriceRaw = $(".a-price-whole").eq(0).text();
    price = parseFloat(newPriceRaw);
  }

  return {
    image_url: image,
    item_url: url,
    name,
    price: price || 0,
    description,
  };
};
