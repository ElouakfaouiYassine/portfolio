import 'dart:js' as js;

/// Send a custom event to Plausible (script must be in index.html)
void trackEvent(String name, [Map<String, String>? props]) {
  try {
    js.context.callMethod('plausible', [
      name,
      if (props != null) js.JsObject.jsify({'props': props})
    ]);
  } catch (_) {/* noop */}
}
