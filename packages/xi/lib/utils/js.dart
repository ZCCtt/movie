import 'package:fjs/fjs.dart';

class HopeJS {
  static Future<void> init() async {
    await LibFjs.init();
  }

  late JsEngine _engine;

  Future<void> withInit() async {
    final runtime = JsAsyncRuntime();
    final context = await JsAsyncContext.from(rt: runtime);
    _engine = JsEngine(context);
    await _engine.init();
    enableBuiltinModule();
    _hijackHTTP();
  }

  Future<JsValue> eval(String code) async {
    var result = await _engine.eval(JsCode.code(code));
    return result;
  }

  void _hijackHTTP() {
    // TODO: 在 dio 中设置了缓存, 最好能将这里的请求中继到 dio 中?
  }

  void enableBuiltinModule() {
    _engine.enableBuiltinModule(
      JsBuiltinOptions(
        fetch: true,
        console: true,
        timers: true,
        url: true,
        json: true,
        events: true,
      ),
    );
  }

  void dispose() {
    _engine.dispose();
  }
}

mixin InstallJS on HopeJS {
  Future<void> installCheerio() async {
    // TODO: impl this
  }
  Future<void> installXMLParse() async {
    // TODO: impl this
  }
}

var hopeJS = HopeJS();
