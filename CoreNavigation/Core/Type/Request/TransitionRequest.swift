import SwiftUI

public struct TransitionRequest<BaseRequest: Request>: Request {
    public var configuration: Configuration
    
    let base: BaseRequest
    let transition: AnyTransition

    public func push() {
        configuration.transition = transition
        
        self.base.push()
    }
    
    public func sheet() {
        configuration.transition = transition

        self.base.sheet()
    }
}
