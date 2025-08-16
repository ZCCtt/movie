// 非常感谢道长大大的开源项目 @hjdhnx
// https://github.com/hjdhnx/drpy-node

import 'dart:async';

import 'package:xi/xi.dart';

import '../models/drpy/dp.dart';

class DrpySpider extends ISpiderAdapter {
  final String id;
  final String name;
  final String api;
  final bool nsfw;
  final bool status;

  DrpySpider({
    this.id = "",
    this.api = "",
    this.name = "",
    this.nsfw = false,
    this.status = true,
  });

  DrpyData _parse(Map<String, dynamic> data) {
    return DrpyData.fromJSON(data);
  }

  VideoDetail _2video(DrpyVideoDetail video) {
    List<VideoInfo> videos = [];
    video.videos.forEach((key, value) {
      var url = "";
      url += value[0]
          .urls
          .map((item) {
            return "${item['name']}\$${item['url']}";
          })
          .toList()
          .join("#");
      videos.add(VideoInfo(
        name: key,
        url: url,
      ));
    });
    return VideoDetail(
      id: video.id,
      title: video.title,
      extra: {},
      smallCoverImage: video.cover,
      videos: videos,
    );
  }

  @override
  Future<List<SourceSpiderQueryCategory>> getCategory() async {
    var data = (await XHttp.dio.get(api)).data;
    var result = _parse(data).categorys;
    var list = result.map((item) {
      return SourceSpiderQueryCategory(item.name, item.id);
    }).toList();
    return list;
  }

  @override
  Future<VideoDetail> getDetail(String movieId) async {
    var resp = await XHttp.dio.get(api, queryParameters: {
      "ac": "detail",
      "ids": movieId,
    });
    var video = _parse(resp.data).videos[0];
    video.id = movieId;
    return _2video(video);
  }

  @override
  Future<List<VideoDetail>> getHome({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    late Response<Map<String, dynamic>> resp;
    if (category != null) {
      resp = await XHttp.dio.get(api, queryParameters: {
        "ac": "cate",
        "t": category,
        "pg": page,
      });
    } else {
      resp = await XHttp.dio.get(api);
    }
    var data = _parse(resp.data!);
    return data.videos.map(_2video).toList();
  }

  @override
  Future<List<VideoDetail>> getSearch({
    required String keyword,
    int page = 1,
    int limit = 10,
  }) async {
    var resp = await XHttp.dio.get(
      api,
      queryParameters: {
        "wd": keyword,
        "pg": page,
      },
    );
    return _parse(resp.data!).videos.map(_2video).toList();
  }

  @override
  bool get isNsfw => nsfw;

  @override
  SourceItemMeta get meta => SourceItemMeta(
        id: id,
        name: name,
        domain: api,
      );

  @override
  Future<List<String>> parseIframe(String iframe) async {
    var resp = await XHttp.dio.get(api, queryParameters: {"play": iframe});
    var ps = DrpyIframeParse.fromJSON(resp.data);
    if (ps.parse == DrpyIframeParseFlag.real) {
      return [ps.url];
    }
    return [];
  }
}
