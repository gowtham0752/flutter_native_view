package com.flutter_native_view.flutter_native_view

import android.annotation.SuppressLint
import android.content.Context
import android.content.ContextWrapper
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentContainerView
import com.fiserv.dps.mobile.sdk.bridge.model.Bridge
import com.fiserv.dps.mobile.sdk.bridge.zelleview.BridgeView
import com.fiserv.dps.mobile.sdk.bridge.zelleview.Zelle
import com.fiserv.dps.mobile.sdk.interfaces.GenericTag
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ZelleNativeView(
    private val context: Context,
    id: Int,
    private val creationParams: Map<String?, Any?>?,
) : PlatformView, GenericTag {
    private var view: FragmentContainerView? = null
    lateinit var bridge : Bridge
    lateinit var linearLayout: LinearLayout

    @SuppressLint("ResourceType")
    override fun getView(): View = view ?: kotlin.run {
        val activity = context.getFragmentActivityOrThrow()
        linearLayout = LinearLayout(context)
        linearLayout.layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        linearLayout.orientation = LinearLayout.VERTICAL
        linearLayout.id = 1234
        BridgeView.genericTag = this
        val  zelle = Zelle(
            applicationName = creationParams!!.get("applicationName") as String?,
            baseURL = creationParams.get("baseUrl") as String,
            institutionId = creationParams.get("institutionId") as String,
            product = creationParams.get("product") as String,
            ssoKey = creationParams.get("ssoKey") as String,
            fi_callback = creationParams.get("fi_callback") as Boolean,
            appData = creationParams.get("appData") as Map<String, Map<String, String>>?,
            parameters = creationParams.get("parameter") as Map<String, String>
        )
        bridge = Bridge(context, zelle)
        zelle.preCacheContacts = true
        val  bridgeView = bridge.view()
        val view = FragmentContainerView(context)
        view.setId(linearLayout.id)
        activity.supportFragmentManager.beginTransaction().add(linearLayout.id, bridgeView, "BridgeView" ).commit()
        this.view = view
        view
    }

    override fun dispose() {
        view = null
    }

    private fun Context.getFragmentActivityOrThrow(): FragmentActivity {
        if (this is FragmentActivity) {
            return this
        }

        var currentContext = this
        while (currentContext is ContextWrapper) {
            if (currentContext is FragmentActivity) {
                return currentContext
            }
            currentContext = currentContext.baseContext
        }

        throw IllegalStateException("Unable to find activity")
    }

    override fun getValue(name: String) {

    }


    override fun sessionTag(tag: String) {
    }

}

class ZelleNativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return ZelleNativeView(context!!, viewId, creationParams)
    }
}
