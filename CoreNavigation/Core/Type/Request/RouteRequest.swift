import SwiftUI

public struct RouteRequest: Request {
    public var navigation: Navigation
    public var configuration: Configuration
    let route: Route
    
    public func navigate() {
        
    }
}
