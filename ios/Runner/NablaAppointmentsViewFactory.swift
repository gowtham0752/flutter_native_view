import Flutter
import UIKit

class NablaAppointmentsViewFactory : NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return NablaAppointmentsNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }
}

class NablaAppointmentsNativeView : NSObject, FlutterPlatformView {
    private var _viewController: UIViewController

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _viewController = UIViewController(nibName: nil, bundle: nil)
        super.init()

        _viewController = NablaSchedulingClient.shared.views.createAppointmentListViewController()
        _viewController.view.frame = frame
    }

    func view() -> UIView {
        return _viewController.view
    }
}
