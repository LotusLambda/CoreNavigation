import SwiftUI

extension Request {
    public func animate(_ animation: Animation) -> AnimatedRequest<Self> {
        AnimatedRequest(configuration: configuration, base: self, animation: animation)
    }
}

