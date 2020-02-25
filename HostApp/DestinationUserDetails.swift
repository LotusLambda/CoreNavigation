import CoreNavigation
import SwiftUI

struct DestinationUserDetails: Destination, Protectable {
    typealias ViewType = UserDetails
    
    func resolve(with resolver: Resolver<Self.ViewType>) {
        resolver.complete(.init())
    }
    
    func protect(with resolver: Resolver<Void>) {
        resolver.complete(())
    }
}
