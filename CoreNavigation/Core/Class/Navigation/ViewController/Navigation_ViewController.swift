extension Navigation {
    public class ViewController {
        private let queue: DispatchQueue
        
        init(queue: DispatchQueue) {
            self.queue = queue
        }
        
        @discardableResult public func viewController<DestinationType: Destination>(for destination: DestinationType) -> Builder<DestinationType, UIViewController> {            
            return Builder(configuration: Configuration(directive: .none, toBlock: {
                return destination
            }, from: UIViewController()), queue: queue)
        }
    }
    
}