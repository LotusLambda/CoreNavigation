/// Closes visible `UIViewController` instance with given navigation type.
///
/// - Parameters:
///   - navigationType: `Navigation.Direction.Back` enum
///   - back: Navigation configuration block
@discardableResult public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ navigationType: Navigation.Direction.Back = .automatic, _ back: (Navigation.Back<Navigation.Builder.Back<FromViewControllerType, ToViewControllerType>>) -> Navigation.Builder.Back<FromViewControllerType, ToViewControllerType>) -> Navigation.Operation {
    Navigator(queue: queue, configuration: back(Navigation.Back(navigationType: navigationType, queue: queue)).configuration).navigate()
}

/// Closes visible `UIViewController` instance with given navigation type.
///
/// - Parameters:
///   - navigationType: `Navigation.Direction.Back` enum
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
@discardableResult public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ navigationType: Navigation.Direction.Back = .automatic, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) -> Navigation.Operation {
    Close(navigationType) { $0
        .visibleViewController()
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController as! FromViewControllerType, toViewController as! ToViewControllerType)
        })
    }
    /*
    Close(navigationType) { $0
        .visibleViewController()
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController, toViewController)
        })
    }
 */
}

/// Closes given `UIViewController` instance with given navigation type.
///
/// - Parameters:
///   - navigationType: `Navigation.Direction.Back` enum
///   - viewController: An `UIViewController` instance to close
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
@discardableResult public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ navigationType: Navigation.Direction.Back = .automatic, viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) -> Navigation.Operation {
    Close(navigationType) { $0
        .viewController(viewController)
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController, toViewController as! ToViewControllerType)
        })
    }
}
