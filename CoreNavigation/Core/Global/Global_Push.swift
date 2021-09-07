import UIKit

/// Pushes resolved `UIViewController` instance to currently presented `UINavigationController` using configuration block.
///
/// - Parameter to: Navigation configuration block
@discardableResult public func Push<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To<Navigation.Builder.To<DestinationType, FromType>.Push>) -> Navigation.Builder.To<DestinationType, FromType>.Push) -> Navigation.Operation {
    Navigate(.push, to)
}

/// Pushes given `UIViewController` instance to currently presented `UINavigationController`.
///
/// - Parameters:
///   - viewController: An `UIViewController` instance to navigate to
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
@discardableResult public func Push<ViewControllerType: UIViewController>(viewController: ViewControllerType, animated: Bool = true, completion: ((Navigation.Result<UIViewController.ViewControllerDestination<ViewControllerType>, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
    Push { $0
        .to(viewController)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

/// Pushes resolved `UIViewController` instance to currently presented `UINavigationController` using an object conforming `Destination` protocol.
///
/// - Parameters:
///   - destination: An object conforming `Destination` protocol to navigate to
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
@discardableResult public func Push<DestinationType: Destination>(destination: DestinationType, animated: Bool = true, completion: ((Navigation.Result<DestinationType, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
    Push { $0
        .to(destination)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

@discardableResult public func Push(matchable: Matchable, animated: Bool = true, completion: ((Navigation.Result<Routing.RoutingDestination, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
    Push { $0
        .to(matchable)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

// MARK: Operators

/// :nodoc:
public func > <DestinationType: Destination, FromType: UIViewController>(left: FromType, right: DestinationType) -> Navigation.Operation {
    Push { $0.to(right, from: left) }
}

/// :nodoc:
public func > <DestinationType: Destination, FromType: UIViewController>(left: FromType, right: @escaping (Navigation.To<Navigation.Builder.To<DestinationType, FromType>.Push>) -> Navigation.Builder.To<DestinationType, FromType>.Push) -> Navigation.Operation {
    Push(right)
}

/// :nodoc:
public func > <ViewControllerType: UIViewController, FromViewController: UIViewController>(left: FromViewController, right: ViewControllerType) -> Navigation.Operation {
    Push { $0.to(right, from: left) }
}
