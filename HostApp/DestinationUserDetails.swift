import CoreNavigation
import SwiftUI

struct DestinationUserDetails: Destination, Protectable, Routable {
    init(route: Routing.Route) throws {
        
    }
    
    init() {}
    
    static var routePatterns: [String] = [ "user/:id" ]
    
    typealias ViewType = UserDetails
    
    func resolveTarget(with resolver: Resolver<Self.ViewType>) {
        resolver.complete(.init())
    }
    
    func protect(with resolver: Resolver<Void>) {
        resolver.complete(())
    }
}
