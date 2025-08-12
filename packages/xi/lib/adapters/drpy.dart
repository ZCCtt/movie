// 非常感谢道长大大的开源项目 @hjdhnx
// https://github.com/hjdhnx/drpy-node

import 'package:xi/interface.dart';

class DrpySpider extends ISpiderAdapter {
  @override
  Future<List<SourceSpiderQueryCategory>> getCategory() {
    // TODO: implement getCategory
    throw UnimplementedError();
  }

  @override
  Future<VideoDetail> getDetail(String movieId) {
    // TODO: implement getDetail
    throw UnimplementedError();
  }

  @override
  Future<List<VideoDetail>> getHome({int page = 1, int limit = 10, String? category}) {
    // TODO: implement getHome
    throw UnimplementedError();
  }

  @override
  Future<List<VideoDetail>> getSearch({required String keyword, int page = 1, int limit = 10}) {
    // TODO: implement getSearch
    throw UnimplementedError();
  }

  @override
  // TODO: implement isNsfw
  bool get isNsfw => throw UnimplementedError();

  @override
  // TODO: implement meta
  SourceItemMeta get meta => throw UnimplementedError();

  @override
  Future<List<String>> parseIframe(String iframe) {
    // TODO: implement parseIframe
    throw UnimplementedError();
  }

}
