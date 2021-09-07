import UIKit

extension Navigation.Builder {
    public class Segue<FromViewControllerType: UIViewController>: Buildable {
        public let configuration: Configuration<UIViewController.ViewControllerDestination<UIViewController>.None, FromViewControllerType>
        public let queue: DispatchQueue
        
        public required init(
            configuration: Configuration<UIViewController.ViewControllerDestination<UIViewController>.None, FromViewControllerType>,
            queue: DispatchQueue
        ) {
            self.configuration = configuration
            self.queue = queue
        }
    }
}
