import SwiftUI

public protocol Destination: AnyDestination {
    associatedtype ViewType: View
    
    func resolveView(with resolver: Resolver<Self.ViewType>)
}
