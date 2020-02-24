import SwiftUI

public protocol Destination {
    associatedtype ViewType: View
    
    func resolve(with resolver: Resolver<Self.ViewType>)
}
