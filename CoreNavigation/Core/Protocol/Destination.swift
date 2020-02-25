import SwiftUI

public protocol Destination: AnyDestination {
    associatedtype ViewType: View
    
    func resolveTarget(with resolver: Resolver<Self.ViewType>)
}
