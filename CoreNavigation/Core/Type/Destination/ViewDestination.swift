import SwiftUI

public struct ViewDestination<ViewType: View> : Destination {
    public var content: () -> ViewType
    
    public init(content: @escaping () -> ViewType) {
        self.content = content
    }
    
    public func resolveTarget(with resolver: Resolver<ViewType>) {
        resolver.complete(content())
    }
}
