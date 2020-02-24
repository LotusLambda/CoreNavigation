import SwiftUI

public struct AnimatedRequest<BaseRequest: Request>: Request {
    public var configuration: Configuration
    
    let base: BaseRequest
    let animation: Animation

    public func navigate() {
        configuration.animation = animation
        
        self.base.navigate()
    }
}
