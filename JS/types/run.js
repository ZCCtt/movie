import * as cheerio from 'cheerio'

// const result = await (async ()=> {
//   return [
//     { text: "亚洲性爱", id: "33" },
//     { text: "热门事件", id: "37" },
//     { text: "动漫肉番", id: "34" },
//   ]
// })

// const result = await (async () => {
//   try {
//     const url = `https://chaojisousuo14.buzz/index.php/vod/type/id/33/page/2.html`;
//     const html = await (await fetch(url, {
//       method: "GET",
//       headers: {
//         "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36 Edg/103.0.1264.71"
//       }
//     })).text();
//     const $ = load(html)
//     return $(".vodlist .listpic").toArray().map(el=> {
//       const a = $(el).find("a")
//       const pic = $(el).find(".vodpic")
//       const name = $(el).find(".vodname")
//       const remark = $(el).find(".time")
//       return {
//         id: a.attr("href") ?? "",
//         cover: pic.attr("data-original") ?? "",
//         title: name.text() ?? "",
//         remark: remark.text()
//       }
//     })
//   } catch (error) {
//     console.error(error)
//     return { err: error.message }  
//   }
// })()
// debugger

// const data = await (async ()=> {
//   const env = {
//     get(key, defaultValue) {
//       return this.params[key] ?? defaultValue
//     },
//     baseUrl: `https://chaojisousuo14.buzz`,
//     params: {
//       movieId: "/index.php/vod/detail/id/174235.html"
//     },
//   };
//   const id = env.get("movieId")
//   const html = await (await fetch(`${env.baseUrl}${id}`)).text()
//   const $ = cheerio.load(html)
//   const img = $(".pull-left.pull-left-mobile1 img.lazy")
//   const playlist = $("#playlist4 tr").toArray().map((item)=> {
//     const a = $(item).find("a")
//     const id = a.attr("href")
//     const text = a.text()
//     return { text, id }
//   })
//   return [{
//     title: img.attr("title") ?? "",
//     cover: img.attr("src") ?? "",
//     id: id,
//     playlist,
//   }]
// })()
// console.log(data)
// debugger

// const data = await (async () => {
//   const env = {
//     get(key, defaultValue) {
//       return this.params[key] ?? defaultValue
//     },
//     baseUrl: `https://chaojisousuo14.buzz`,
//     params: {
//       iframe: "/index.php/vod/play/id/172569/sid/1/nid/1.html"
//     },
//   };
//   const url = `${env.baseUrl}${env.get('iframe')}`
//   const html = await (await fetch(url)).text()
//   const $ = cheerio.load(html)
//   const script = $("#bofang_box script").text()
//   const m3u8 = script.match(/"url":"(.*?)"/)[1].replace(/\\/g, '')
//   return m3u8
// })()
// debugger

// const data = await (async ()=> {
//   const env = {
//     get(key, defaultValue) {
//       return this.params[key] ?? defaultValue
//     },
//     baseUrl: `https://chaojisousuo14.buzz`,
//     params: {
//       "page": 1,
//       "limit": 10,
//       "keyword": "黑丝"
//     },
//   };
//   const url = `${env.baseUrl}/index.php/vod/search/page/${env.get("page")}/wd/${env.get("keyword")}.html`
//   const html = await (await fetch(url)).text()
//   const $ = cheerio.load(html)
//   return $(".show-list li").toArray().map(item=> {
//     const _ = $(item).find("img") ?? ""
//     const a = $(item).find("a.play-img")
//     const remark = $($(item).find("dl.fn-left").toArray().at(-1)).find("dd").text()
//     const id = a.attr("href") ?? ""
//     const cover = _.attr("src") ?? ""
//     const title = _.attr("alt") ?? ""
//     return { id, cover, title, remark }
//   })
// })()
// debugger