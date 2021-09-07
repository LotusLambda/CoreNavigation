import UIKit

/// Presents resolved `UIViewController` instance on currently presented `UIViewController` using configuration block.
///
/// - Parameter to: Navigation configuration block
@discardableResult public func Present<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To<Navigation.Builder.To<DestinationType, FromType>.Present>) -> Navigation.Builder.To<DestinationType, FromType>.Present) -> Navigation.Operation {
    Navigate(.present, to)
}

/// Presents given `UIViewController` instance on currently presented `UIViewController`.
///
/// - Parameters:
///   - viewController: An `UIViewController` instance to navigate to
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
@discardableResult public func Present<ViewControllerType: UIViewController>(viewController: ViewControllerType, animated: Bool = true, completion: ((Navigation.Result<UIViewController.ViewControllerDestination<ViewControllerType>, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
    Present { $0
        .to(viewController)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

/// Presents resolved `UIViewController` instance on currently presented `UIViewController` using an object conforming `Destination` protocol.
///
/// - Parameters:
///   - destination: An object conforming `Destination` protocol to navigate to
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
@discardableResult public func Present<DestinationType: Destination>(destination: DestinationType, animated: Bool = true, completion: ((Navigation.Result<DestinationType, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
    Present { $0
        .to(destination)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

@discardableResult public func Present(matchable: Matchable, animated: Bool = true, completion: ((Navigation.Result<Routing.RoutingDestination, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
    Present { $0
        .to(matchable)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

// MARK: Operators

/// :nodoc:
@discardableResult public func >>> <DestinationType: Destination, FromType: UIViewController>(left: FromType, right: DestinationType) -> Navigation.Operation {
    Present { $0.to(right, from: left) }
}

/// :nodoc:
@discardableResult public func >>> <DestinationType: Destination, FromType: UIViewController>(left: FromType, right: @escaping (Navigation.To<Navigation.Builder.To<DestinationType, FromType>.Present>) -> Navigation.Builder.To<DestinationType, FromType>.Present) -> Navigation.Operation {
    Present(right)
}

/// :nodoc:
@discardableResult public func >>> <ViewControllerType: UIViewController, FromViewController: UIViewController>(left: FromViewController, right: ViewControllerType) -> Navigation.Operation {
    Present { $0.to(right, from: left) }
}
