package com.flutter_native_view.flutter_native_view

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.platformViewsController
            .registry
            .registerViewFactory("zelleviewtype", ZelleNativeViewFactory())
    }
}
