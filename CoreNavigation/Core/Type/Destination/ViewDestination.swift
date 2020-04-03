import SwiftUI

public struct ViewDestination<ViewType: View> : Destination {
    public var content: () -> ViewType
    
    public init(content: @escaping () -> ViewType) {
        self.content = content
    }
    
    public func resolveView(with resolver: Resolver<ViewType>) {
        resolver.complete(content())
    }
}
