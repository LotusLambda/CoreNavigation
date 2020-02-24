import SwiftUI

public struct ViewRequest<DestinationType: Destination>: Request {
    let navigation: Navigation
    public var configuration: Configuration
    let destination: DestinationType
    
    public func navigate() {
        destination.resolve(with: Resolver<DestinationType.ViewType>(onComplete: { view in
            self.navigation.push(view: view, configuration: self.configuration)
        }, onError: { (error) in
            
        }))
    }
    
    
}
