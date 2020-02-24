import SwiftUI

public struct TransitionRequest<BaseRequest: Request>: Request {
    public var configuration: Configuration
    
    let base: BaseRequest
    let transition: AnyTransition

    public func navigate() {
        configuration.transition = transition
        
        self.base.navigate()
    }
}
