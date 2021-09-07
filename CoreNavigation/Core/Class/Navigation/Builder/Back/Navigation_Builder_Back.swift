import UIKit

extension Navigation.Builder {
    public class Back<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>: Buildable {
        public let configuration: Configuration<UIViewController.ViewControllerDestination<UIViewController>.None, FromViewControllerType>
        public let queue: DispatchQueue

        required public init(configuration: Configuration<UIViewController.ViewControllerDestination<UIViewController>.None, FromViewControllerType>, queue: DispatchQueue) {
            self.configuration = configuration
            self.queue = queue
        }        
    }
}
