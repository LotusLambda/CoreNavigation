import Foundation

/// Handles route.
public class RouteHandler<RouteType: Route> {
    /// Parameters extracted from route's uri.
    public let parameters: [String: Any]?
    
    var destinationBlocks: [(RouteType.Destination, Any?) -> Void] = []
    
    init(parameters: [String: Any]?) {
        self.parameters = parameters
    }
    
    /// Notifies handler to proceed with navigation.
    ///
    /// - Parameter viewController: UIViewController instance to navigate to.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(viewController: RouteType.Destination = .init()) -> RouteType.Destination {
        destination(viewController, data: nil)
        
        return viewController
    }
    
    func destination(_ destination: RouteType.Destination, data: Any?) {
        destinationBlocks.forEach { $0(destination, data) }
        
        destinationBlocks = []
    }
}

extension RouteHandler where RouteType.Destination: DataReceivable {
    /// Notifies handler to proceed with navigation.
    ///
    /// - Parameters:
    ///   - viewController: UIViewController instance to navigate to.
    ///   - data: Data to pass to view controller.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(viewController: RouteType.Destination = .init(), data: RouteType.Destination.DataType? = nil) -> RouteType.Destination {
        
        destination(viewController, data: data)
        
        if let data = data {
            viewController.didReceiveData(data)
        }
        
        return viewController
    }
    
    /// Notifies handler to proceed with navigation.
    ///
    /// - Parameter data: Data to pass to view controller.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(data: RouteType.Destination.DataType?) -> RouteType.Destination {
        return self.complete(viewController: RouteType.Destination.init(), data: data)
    }
}
