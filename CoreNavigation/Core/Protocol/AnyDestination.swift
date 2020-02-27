import SwiftUI

public protocol AnyDestination {
    static func resolveDestination(route: Routing.Route, destination: @escaping (Self) -> Void, failure: @escaping (Error) -> Void) throws
    func resolveTarget(for route: Routing.Route, with resolver: Resolver<AnyView>)
}

extension AnyDestination {
    public func resolveTarget(for route: Routing.Route, with resolver: Resolver<AnyView>) {
        fatalError("Implement this method if your target view does not conform to `Routed`")
    }
    public static func resolveDestination(route: Routing.Route, destination: @escaping (Self) -> Void, failure: @escaping (Error) -> Void) throws {
        fatalError("Implement this method if your destination view does not conform to `Routed`")
    }
}

extension AnyDestination where Self: Routed {
    public static func resolveDestination(route: Routing.Route, destination: @escaping (Self) -> Void, failure: @escaping (Error) -> Void) throws {
        destination(try .init(route: route))
    }
}

extension Destination {
    public func resolveTarget(for route: Routing.Route, with resolver: Resolver<AnyView>) {
        self.resolveTarget(with: .init(route: route, onComplete: { (view) in
            resolver.complete(AnyView(view))
        }, onError: { (error) in
            resolver.error(error)
        }))
    }
}

extension Destination where ViewType: Routed {
    public func resolveTarget(with resolver: Resolver<ViewType>) {
        if let route = resolver.route {
            do {
                resolver.complete(try .init(route: route))
            } catch let error {
                resolver.error(error)
            }
        } else {
            fatalError("Implement this method in your `Destination`")
        }
    }
}
