import SwiftUI

public struct DestinationRequest<DestinationType: Destination>: Request {
    let navigation: Navigation
    public var configuration: Configuration
    let destination: DestinationType
    
    public func navigate() {
        CoreNavigation.protect(destination: destination, continue: {
            self.resolve()
        }) { (error) in
            fatalError()
        }
    }
    
    private func resolve() {
        destination.resolveTarget(with: Resolver<DestinationType.ViewType>(route: nil, onComplete: { view in
            self.navigation.push(view: view, configuration: self.configuration)
        }, onError: { (error) in
            fatalError()
        }))
    }
}
