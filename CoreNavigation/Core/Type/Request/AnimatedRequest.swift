import SwiftUI

public struct AnimatedRequest<BaseRequest: Request>: Request {
    public var configuration: Configuration
    
    let base: BaseRequest
    let animation: Animation

    public func push() {
        configuration.animation = animation
        
        self.base.push()
    }
    
    public func sheet() {
        configuration.animation = animation
        
        self.base.sheet()
    }
}
