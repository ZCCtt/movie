class EP {
  final String name;
  final List<Map<String, String>> urls;

  EP({required this.name, required this.urls});
}

Map<String, List<EP>> parseVideosVideos(dynamic cx) {
  if (cx == null) return {};
  const String mainSplitSyb = r"$$$";
  if (cx is! Map ||
      !cx.containsKey('vod_play_from') ||
      !cx.containsKey('vod_play_url')) {
    return {};
  }
  dynamic vodPlayFrom = cx['vod_play_from'];
  dynamic vodPlayUrl = cx['vod_play_url'];
  if (vodPlayFrom == null ||
      vodPlayUrl == null ||
      vodPlayFrom is! String ||
      vodPlayUrl is! String) {
    return {};
  }
  List<String> tabs = vodPlayFrom.split(mainSplitSyb);
  List<String> vs = vodPlayUrl.split(mainSplitSyb);
  Map<String, List<EP>> result = {};
  for (int i = 0; i < tabs.length; i++) {
    if (i >= vs.length) break; // 防止索引越界
    String name = tabs[i];
    String url = vs[i];
    if (!result.containsKey(name)) {
      result[name] = [];
    }
    List<Map<String, String>> urls = [];
    for (String item in url.split("#")) {
      List<String> parts = item.split(r"$");
      if (parts.length >= 2) {
        urls.add({
          'name': parts[0],
          'url': parts[1],
        });
      }
    }
    result[name]!.add(EP(
      name: name,
      urls: urls,
    ));
  }
  return result;
}

class DrpyCategory {
  late final String id;
  late final String name;
  DrpyCategory.fromJSON(Map<String, dynamic> json) {
    id = json['type_id'];
    name = json['type_name'];
  }
}

class DrpyVideoDetail {
  late String id;
  late String title;
  late String cover;
  late final Map<String, List<EP>> videos;
  DrpyVideoDetail.fromJSON(Map<String, dynamic> json) {
    id = json['vod_id'] ?? "";
    title = json['vod_name'] ?? "";
    cover = json['vod_pic'] ?? "";
    videos = parseVideosVideos(json);
  }
}

class DrpyData {
  List<DrpyCategory> categorys = [];
  List<DrpyVideoDetail> videos = [];
  DrpyData.fromJSON(Map<String, dynamic> json) {
    List<Map<String, dynamic>> cs =
        (json['class'] ?? []).cast<Map<String, dynamic>>();
    List<Map<String, dynamic>> list =
        (json['list'] ?? []).cast<Map<String, dynamic>>();
    categorys = cs.map(DrpyCategory.fromJSON).toList();
    videos = list.map(DrpyVideoDetail.fromJSON).toList();
  }
}

enum DrpyIframeParseFlag {
  /// 直链
  real,

  /// 需要再嗅探解析
  reParse,
}

class DrpyIframeParse {
  late final DrpyIframeParseFlag parse;
  late final String url;
  DrpyIframeParse.fromJSON(Map<String, dynamic> json) {
    int flag = (json['parse'] ?? 0);
    parse = flag == 0 ? DrpyIframeParseFlag.real : DrpyIframeParseFlag.reParse;
    url = json['url'];
  }
}
