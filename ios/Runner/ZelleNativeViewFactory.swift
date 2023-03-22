import Flutter
import UIKit
import ZelleSDK

class ZelleNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var viewController:UIViewController

    init(messenger: FlutterBinaryMessenger, viewController:UIViewController ) {
        self.messenger = messenger
        self.viewController = viewController
        super.init()
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
              return FlutterStandardMessageCodec.sharedInstance()
        }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return ZelleNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger, viewController: viewController)
    }
    
}

class ZelleNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        viewController:UIViewController
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view, frame: frame, viewController: viewController, args: args)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView, frame: CGRect,  viewController:UIViewController, args : Any?){

        let arguments = args as? Dictionary<String, Any>
        
         let zelle = Zelle(
            applicationName: (arguments?["applicationName"] as? String)!,
            baseUrl: (arguments?["baseUrl"] as? String)!,
            institutionId: (arguments?["institutionId"] as? String)!,
            product: (arguments?["product"] as? String)!,
            ssoKey: (arguments?["ssoKey"] as? String)!,
            parameters: (arguments?["parameter"] as? Dictionary<String, String>)!
        )
        
        lazy var bridge: Bridge = {
           Bridge(
               config: zelle,
               viewController: viewController
           )
       }()

        self._view = bridge.view(frame: frame)
    }
}
