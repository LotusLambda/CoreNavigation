import SwiftUI

public protocol Routed {
    init(route: Routing.Route) throws
}

public protocol Routable: Routed, Destination {
    static var routePatterns: [String] { get }
}
