import 'package:flutter/services.dart';
import 'package:dart_qjson/dart_qjson.dart';
import 'package:xi/xi.dart';

extension BetterJSONList on JsonList {
  void forEach(ValueChanged<JsonObject> cb) {
    for (var i = 0; i < length; i++) {
      JsonObject cx = getObject(i)!;
      cb(cx);
    }
  }
}

class UniversalSpider extends ISpiderAdapter {
  List<SourceSpiderQueryCategory> parseCategoryWithJSResult(String _result) {
    var jsonList = JsonList.fromJsonString(_result);
    List<SourceSpiderQueryCategory> result = [];
    jsonList.forEach((item) {
      var text = item.get("text").toString();
      var id = item.get("id").toString();
      result.add(SourceSpiderQueryCategory(text, id));
    });
    return result;
  }

  List<VideoDetail> parseListWithJSResult(String _result) {
    var jsonList = JsonList.fromJsonString(_result);
    List<VideoDetail> result = [];
    jsonList.forEach((item) {
      var cover = item.get("cover").toString();
      var title = item.get("title").toString();
      var id = item.get("id").toString();
      result.add(
        VideoDetail(
          id: id,
          title: title,
          extra: {},
          smallCoverImage: cover,
        ),
      );
    });
    return result;
  }

  @override
  Future<List<SourceSpiderQueryCategory>> getCategory() async {
    var result = await js2.evalSync(r"""
(async ()=> {
  const url = "https://www.laodifang.tv";
  const text = await (await fetch(url)).text();
  const $ = cheerio.load(text);
  const result = $(".top_nav.clearfix").find("li").toArray().map(el=> {
    const a = $(el).find('a')
    const text = a.text()
    let id = a.attr("href") ?? "-1"
    id = id.replace("/vodtype/", "").replace(".html", "")
    return { text, id }
  })
  return result
})()
""", timeout: Duration(seconds: 3));
    return parseCategoryWithJSResult(result);
  }

  @override
  Future<VideoDetail> getDetail(String movieId) async {
    var result = await js2.evalSync(r"""
(async ()=> {
    const url = "https://www.laodifang.tv/voddetail/$$id"
    const text = await (await fetch(url)).text();
    const $ = cheerio.load(text);
    const ctx = $(".content_box.clearfix")
    const a = ctx.find(".vodlist_thumb")
    const cover = a.attr('data-original')
    const title = a.attr('title')
    const playlist = $("#playlistbox ul li").toArray().map(el=> {
      const a = $(el).find('a')
      return { text: a.text(), id: a.attr("href") ?? "-1" }
    })
    return [{ cover, title, playlist, id: `$$id` }]
})()
"""
        .replaceAll(r"$$id", movieId), timeout: Duration(seconds: 3));
    return parseListWithJSResult(result)[0];
  }

  @override
  Future<List<VideoDetail>> getHome({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    if (category == "" || category == "/") return [];
    var result = await js2.evalSync(r"""
(async () => {
  const url = "https://www.laodifang.tv/$$url";
  const text = await (await fetch(url)).text()
  const $ = cheerio.load(text);
  const result = $(".vodlist.vodlist_wi.clearfix").find('li.vodlist_item').toArray().map(el=> {
    const a = $(el).find('a.vodlist_thumb')
    const cover = a.attr('data-original')
    const title = a.attr('title')
    const id = (a.attr('href') ?? "").replace('/voddetail/', '')
    return { id, cover, title }
  })
  return result
})()
"""
        .replaceAll(r"$$url", "/vodtype/${category!}-$page.html"), timeout: Duration(seconds: 3));
    return parseListWithJSResult(result);
  }

  @override
  Future<List<VideoDetail>> getSearch({
    required String keyword,
    int page = 1,
    int limit = 10,
  }) async {
    js2.evalSync(r"""
(async ()=> {
  const url = "https://www.laodifang.tv/vodsearch/-------------.html?wd=$$wd&submit=";
  const text = await (await fetch(url)).text();
  const $ = cheerio.load(text);
  const result = $('.vodlist.clearfix').find('li.searchlist_item').toArray().map(el=> {
    const a = $(el).find('a.vodlist_thumb')
    const cover = a.attr('data-original')
    const title = a.attr('title')
    const id = (a.attr('href') ?? "").replace('/voddetail/', '')
    return { id, cover, title }
  })
  return result
})()
"""
        .replaceAll(r"$$wd", keyword), timeout: Duration(seconds: 3));
    return [];
  }

  @override
  bool get isNsfw => false;

  @override
  SourceItemMeta get meta => SourceItemMeta(
        id: 'test',
        name: 'JS引擎测试',
        domain: 'baidu.com',
      );

  @override
  Future<List<String>> parseIframe(String iframe) async {
    return [];
  }
}
