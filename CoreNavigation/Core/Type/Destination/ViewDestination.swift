import SwiftUI

public struct ViewDestination : Destination {
    public typealias ViewType = AnyView
    
    public var content: () -> ViewType
    
    public init(content: @escaping () -> ViewType) {
        self.content = content
    }
    
    public func resolveTarget(with resolver: Resolver<Self.ViewType>) {
        resolver.complete(content())
    }
}
