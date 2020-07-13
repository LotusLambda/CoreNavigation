extension Destination {
    public func navigate<BuildableType: Buildable>(_ navigationType: Navigation.Direction.Forward, _ to: (BuildableType) -> BuildableType) -> Navigation.Operation where BuildableType.DestinationType == Self {
        Navigate(navigationType, { to($0.to(self)) })
    }

    @discardableResult public func present<FromType: UIViewController>(_ to: (Navigation.Builder.To<Self, FromType>.Present) -> Navigation.Builder.To<Self, FromType>.Present) -> Navigation.Operation {
        navigate(.present, to)
    }
    
    @discardableResult public func present(animated: Bool = true, completion: ((Navigation.Result<Self, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
        present { $0
            .animated(animated)
            .onComplete({ (result) in
                completion?(result)
            })
        }
    }

    @discardableResult public func push<FromType: UIViewController>(_ to: (Navigation.Builder.To<Self, FromType>.Push) -> Navigation.Builder.To<Self, FromType>.Push) -> Navigation.Operation {
        navigate(.push, to)
    }
    
    @discardableResult public func push(animated: Bool = true, completion: ((Navigation.Result<Self, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
        push { $0
            .animated(animated)
            .onComplete({ (result) in
                completion?(result)
            })
        }
    }

    public func viewController(_ block: @escaping (Self.ViewControllerType) -> Void, _ failure: ((Error) -> Void)? = nil) {
        let builder = Navigation.Builder.ViewController(configuration: Navigation.ViewController<Navigation.Builder.ViewController>(queue: queue).viewController(for: self).configuration, queue: queue)

        Navigator(queue: queue, configuration: builder.configuration).resolve(
            onComplete: { (_, viewController, _) in
                block(viewController)
            },
            onCancel: { failure?($0) })
    }

    public func viewController() throws -> Self.ViewControllerType {
        var resolvedViewController: Self.ViewControllerType?
        var resolvedError: Error?

        viewController({ (viewController) in
                resolvedViewController = viewController
            }, { (error) in
                resolvedError = error
            })

        if let error = resolvedError {
            throw error
        }

        guard let viewController = resolvedViewController else {
            throw Navigation.Error.unknown
        }

        return viewController
    }

    func resolvedDestination(_ block: @escaping (Self) -> Void, _ failure: ((Error) -> Void)? = nil) {
        let builder = Navigation.Builder.ViewController(configuration: Navigation.ViewController<Navigation.Builder.ViewController>(queue: queue).viewController(for: self).configuration, queue: queue)

        Navigator(queue: queue, configuration: builder.configuration).resolve(
            onComplete: { (destination, _, _) in
                block(destination)
            },
            onCancel: { failure?($0) }
        )
    }

    func resolvedDestination() throws -> Self {
        var resolvedDestination: Self!
        var resolvedError: Error?

        self.resolvedDestination({ (destination) in
            resolvedDestination = destination
        }, { (error) in
            resolvedError = error
        })

        if let error = resolvedError {
            throw error
        }

        return resolvedDestination
    }
}
