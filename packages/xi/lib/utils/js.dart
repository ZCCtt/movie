import 'package:fjs/fjs.dart';
import 'package:flutter/rendering.dart';

class HopeJS {
  static Future<void> init() async {
    await LibFjs.init();
  }

  late JsEngine _engine;
  late JsAsyncRuntime _runtime;

  JsEngine get cx => _engine;

  Future<void> withInit() async {
    _runtime = JsAsyncRuntime();
    await _runtime.setMemoryLimit(
      limit: BigInt.from(50 * 1024 * 1024), // 50MB
    );
    await _runtime.setGcThreshold(
      threshold: BigInt.from(10 * 1024 * 1024), // 10MB
    );
    final context = await JsAsyncContext.from(rt: _runtime);
    _engine = JsEngine(context);
    await _engine.init();
    await _enableBuiltinModule();
    await _hijackHTTP();
    await _installCheerio();
    await _installDemo();
  }

  Future<JsValue> eval(String code) async {
    var result = await _engine.eval(JsCode.code(code));
    return result;
  }

  Future<JsValue> evalModule(String module, String code) async {
    var result = await _engine.evaluateModule(
      JsModule.code(module: module, code: code),
    );
    return result;
  }

  Future<void> _hijackHTTP() async {
    // TODO: 在 dio 中设置了缓存, 最好能将这里的请求中继到 dio 中?
  }

  Future<void> _installDemo() async {
    _engine.declareModule(JsModule.code(module: "greeting", code: r"""
export function greet(name) {
  return `Hello`;
}
export const version = '1.0.0';
"""));
  }

  Future<void> _installCheerio() async {
    var result = await _engine.declareModule(
      JsModule.path(
        module: 'cheerio',
        path: "packages/xi/assets/js/cheerio-esm.js",
      ),
    );
    debugPrint(result.toString());
  }

  Future<void> _enableBuiltinModule() async {
    await _engine.enableBuiltinModule(
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

var hopeJS = HopeJS();
