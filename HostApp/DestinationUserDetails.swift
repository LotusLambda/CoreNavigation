import CoreNavigation
import SwiftUI

struct DestinationUserDetails: Destination {
    typealias ViewType = UserDetails
    
    func resolve(with resolver: Resolver<Self.ViewType>) {
        resolver.complete(.init())
    }
}
