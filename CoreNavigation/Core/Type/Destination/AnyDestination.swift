import SwiftUI

public struct AnyDestination : Destination {
    public typealias ViewType = AnyView
    
    public var content: () -> ViewType
    
    public init(content: @escaping () -> ViewType) {
        self.content = content
    }
    
    public func resolve(with resolver: Resolver<Self.ViewType>) {
        resolver.complete(content())
    }
}
