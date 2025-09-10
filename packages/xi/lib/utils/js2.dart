import 'package:flutter/services.dart';
import 'package:flutter_js/extensions/fetch.dart';
import 'package:flutter_js/extensions/xhr.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:xi/xi.dart';

class JS2 {
  late JavascriptRuntime _runtime;

  Future<void> init() async {
    _runtime = getJavascriptRuntime();
    await _runtime.enableHandlePromises();
    await _runtime.enableFetch();
    await _installCheerio();
    _runtime.setInspectable(true);
    _runtime.enableXhr();
    _injectMethods();
  }

  void _injectMethods() {
    _runtime.injectMethod('req', (dynamic args) async {
      if (args is List) {
        var url = args[0];
        var resp = await XHttp.dio.get(url);
        var body = resp.data.toString();
        return body;
      }
      return "NULL";
    });
  }

  Future<void> _installCheerio() async {
    var result = await rootBundle.loadString(
      'packages/xi/assets/js/cheerio.umd.js',
    );
    _runtime.evaluate("var window = global = globalThis;");
    _runtime.evaluate(result);
  }

  String eval(String code) {
    var result = _runtime.evaluate(code);
    return result.stringResult;
  }

  Future<String> evalSync(String code, {Duration? timeout}) async {
    var result = await _runtime.evaluateAsync(code);
    var promise = await _runtime.handlePromise(result, timeout: timeout);
    return promise.stringResult;
  }
}

var js2 = JS2();
