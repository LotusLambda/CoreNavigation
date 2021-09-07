import UIKit

extension UIViewController {
    final public class ViewControllerDestination<ViewControllerType: UIViewController>: Destination {
        let block: () -> ViewControllerType

        init(block: @escaping () -> ViewControllerType) {
            self.block = block
        }

        public func resolve(with resolver: Resolver<UIViewController.ViewControllerDestination<ViewControllerType>>) {
            DispatchQueue.main.async {
                resolver.complete(viewController: self.block())
            }
        }
    }
}

extension UIViewController.ViewControllerDestination {
    public final class None: Destination {}
}
