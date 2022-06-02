//
//  NewsAPIWorker .swift
//  Finance_App01
//
//  Created by a-robota on 6/2/22.
//

//   let task = URLSession.shared.newsAPIModelTask(with: url) { newsAPIModel, response, error in
//     if let newsAPIModel = newsAPIModel {
//       ...
//     }
//   }
//   task.resume()


import Foundation

class newsAPIWorker {

    var newsAPIkey : String = "pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"
    var newsURL : String = "https://api.polygon.io/v2/reference/news?ticker=aapl&order=asc&limit=50&sort=published_utc&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD"

    
    func fetchAPI() {
        print("[!] Fetching API info or newsVC ! ")
    }
}




/*
 https://api.polygon.io/v2/reference/news?ticker=aapl&order=asc&limit=50&sort=published_utc&apiKey=pnmVOrapMEyGBt2uOl2GBLKvM40CSjsD
 {
 "count": 1,
 "next_url": "https://api.polygon.io:443/v2/reference/news?cursor=eyJsaW1pdCI6MSwic29ydCI6InB1Ymxpc2hlZF91dGMiLCJvcmRlciI6ImFzY2VuZGluZyIsInRpY2tlciI6e30sInB1Ymxpc2hlZF91dGMiOnsiZ3RlIjoiMjAyMS0wNC0yNiJ9LCJzZWFyY2hfYWZ0ZXIiOlsxNjE5NDA0Mzk3MDAwLG51bGxdfQ",
 "request_id": "831afdb0b8078549fed053476984947a",
 "results": [
 {
 "amp_url": "https://amp.benzinga.com/amp/content/20784086",
 "article_url": "https://www.benzinga.com/markets/cryptocurrency/21/04/20784086/cathie-wood-adds-more-coinbase-skillz-trims-square",
 "author": "Rachit Vats",
 "description": "<p>Cathie Wood-led Ark Investment Management on Friday snapped up another 221,167 shares of the cryptocurrency exchange <strong>Coinbase Global Inc </strong>(NASDAQ: <a class=\"ticker\" href=\"https://www.benzinga.com/stock/coin#NASDAQ\">COIN</a>) worth about $64.49 million on the stock&rsquo;s Friday&rsquo;s dip and also its fourth-straight loss.</p>\n<p>The investment firm&rsquo;s <strong>Ark Innovation ETF</strong> (NYSE: <a class=\"ticker\" href=\"https://www.benzinga.com/stock/arkk#NYSE\">ARKK</a>) bought the shares of the company that closed 0.63% lower at $291.60 on Friday, giving the cryptocurrency exchange a market cap of $58.09 billion. Coinbase&rsquo;s market cap has dropped from $85.8 billion on its blockbuster listing earlier this month.</p>\n<p>The New York-based company also added another 3,873 shares of the mobile gaming company <strong>Skillz Inc</strong> (NYSE: <a class=\"ticker\" href=\"https://www.benzinga.com/stock/sklz#NYSE\">SKLZ</a>), <a href=\"http://www.benzinga.com/markets/cryptocurrency/21/04/20762794/cathie-woods-ark-loads-up-another-1-2-million-shares-in-skillz-also-adds-coinbase-draftkin\">just a day after</a> snapping 1.2 million shares of the stock.</p>\n<p>ARKK bought the shares of the company which closed ...</p><p><a href=https://www.benzinga.com/markets/cryptocurrency/21/04/20784086/cathie-wood-adds-more-coinbase-skillz-trims-square alt=Cathie Wood Adds More Coinbase, Skillz, Trims Square>Full story available on Benzinga.com</a></p>",
 "id": "nJsSJJdwViHZcw5367rZi7_qkXLfMzacXBfpv-vD9UA",
 "image_url": "https://cdn2.benzinga.com/files/imagecache/og_image_social_share_1200x630/images/story/2012/andre-francois-mckenzie-auhr4gcqcce-unsplash.jpg?width=720",
 "keywords": [
 "Sector ETFs",
 "Penny Stocks",
 "Cryptocurrency",
 "Small Cap",
 "Markets",
 "Trading Ideas",
 "ETFs"
 ],
 "published_utc": "2021-04-26T02:33:17Z",
 "publisher": {
 "favicon_url": "https://s3.polygon.io/public/public/assets/news/favicons/benzinga.ico",
 "homepage_url": "https://www.benzinga.com/",
 "logo_url": "https://s3.polygon.io/public/public/assets/news/logos/benzinga.svg",
 "name": "Benzinga"
 },
 "tickers": [
 "DOCU",
 "DDD",
 "NIU",
 "ARKF",
 "NVDA",
 "SKLZ",
 "PCAR",
 "MASS",
 "PSTI",
 "SPFR",
 "TREE",
 "PHR",
 "IRDM",
 "BEAM",
 "ARKW",
 "ARKK",
 "ARKG",
 "PSTG",
 "SQ",
 "IONS",
 "SYRS"
 ],
 "title": "Cathie Wood Adds More Coinbase, Skillz, Trims Square"
 }
 ],
 "status": "OK"
 }

 */
