import 'dart:convert';

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

  List<T> map<T>(T Function(JsonObject value) cb) {
    List<T> result = [];
    forEach((item) {
      result.add(cb(item));
    });
    return result;
  }
}

class UniversalSpider extends ISpiderAdapter {
  var url = "https://chaojisousuo14.buzz";
  String _generateJSCode(String realCode, {Map<String, dynamic>? params}) {
    var ps = jsonEncode(params ?? {});
    var result = """
(async ()=> {
  const env = {
    get(key, defaultValue) {
      return this.params[key] ?? defaultValue
    },
    baseUrl: `$url`,
    params: $ps,
  };
  $realCode
})()""";
    return result;
  }

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
      var remark = item.get("remark").toString();
      var playlist = item.getList("playlist");
      List<Videos> realVideos = [];
      if (playlist != null && playlist.isNotEmpty) {
        var videoInfos = playlist.map((item) {
          return VideoInfo(
            name: item.get("text").toString(),
            url: item.get("id").toString(),
            type: VideoType.iframe,
          );
        });
        realVideos.add(
          Videos(
            title: "默认",
            datas: videoInfos,
          ),
        );
      }
      result.add(
        VideoDetail(
          id: id,
          title: title,
          remark: remark,
          extra: {},
          videos: realVideos,
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
  return [
    { text: "亚洲性爱", id: "33" },
    { text: "热门事件", id: "37" },
    { text: "动漫肉番", id: "34" },
  ]
})()
""", timeout: Duration(seconds: 3));
    return parseCategoryWithJSResult(result);
  }

  @override
  Future<List<VideoDetail>> getHome({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    var result = await js2.evalSync(_generateJSCode(r"""
const url = `${env.baseUrl}/index.php/vod/type/id/${env.get('category')}/page/${env.get('page')}.html`;
const html = await req(url)
const $ = cheerio.load(html)
return $(".vodlist .listpic").toArray().map(el=> {
  const a = $(el).find("a")
  const pic = $(el).find(".vodpic")
  const name = $(el).find(".vodname")
  const remark = $(el).find(".time")
  return {
    id: a.attr("href") ?? "",
    cover: pic.attr("data-original") ?? "",
    title: name.text() ?? "",
    remark: remark.text()
  }
})
""", params: {
      "category": category,
      "page": page,
      "limit": limit,
    }));
    return parseListWithJSResult(result);
  }

  @override
  Future<VideoDetail> getDetail(String movieId) async {
    var result = await js2.evalSync(
        _generateJSCode(r"""
const id = env.get("movieId")
const html = await req(`${env.baseUrl}${id}`)
const $ = cheerio.load(html)
const img = $(".pull-left.pull-left-mobile1 img.lazy")
const playlist = $("#playlist4 tr").toArray().map((item)=> {
  const a = $(item).find("a")
  const id = a.attr("href")
  const text = a.text()
  return { text, id }
})
return [{
  title: img.attr("title") ?? "",
  cover: img.attr("src") ?? "",
  id: id,
  playlist,
}]
""", params: {
          "movieId": movieId,
        }),
        timeout: Duration(seconds: 3));
    return parseListWithJSResult(result)[0];
  }

  @override
  Future<List<VideoDetail>> getSearch({
    required String keyword,
    int page = 1,
    int limit = 10,
  }) async {
    var result = await js2.evalSync(_generateJSCode(r"""
const url = `${env.baseUrl}/index.php/vod/search/page/${env.get("page")}/wd/${env.get("keyword")}.html`
const html = await (await fetch(url)).text()
const $ = cheerio.load(html)
return $(".show-list li").toArray().map(item=> {
  const _ = $(item).find("img") ?? ""
  const a = $(item).find("a.play-img")
  const remark = $($(item).find("dl.fn-left").toArray().at(-1)).find("dd").text()
  const id = a.attr("href") ?? ""
  const cover = _.attr("src") ?? ""
  const title = _.attr("alt") ?? ""
  return { id, cover, title, remark }
})
""", params: {
      "page": page,
      "limit": limit,
      "keyword": keyword,
    }));
    return parseListWithJSResult(result);
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
    var result = await js2.evalSync(_generateJSCode(r"""
const url = `${env.baseUrl}${env.get('iframe')}`
const html = await req(url)
const $ = cheerio.load(html)
const script = $("#bofang_box script").text()
const m3u8 = script.match(/"url":"(.*?)"/)[1].replace(/\\/g, '')
return m3u8
""", params: {
      "iframe": iframe,
    }));
    return [result];
  }
}
