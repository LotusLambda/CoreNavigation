import SwiftUI

extension Request {
    public func transition(_ transition: AnyTransition) -> TransitionRequest<Self> {
        TransitionRequest(configuration: configuration, base: self, transition: transition)
    }
}

