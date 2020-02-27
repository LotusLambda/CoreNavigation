import SwiftUI

public struct DestinationRequest<DestinationType: Destination>: Request {
    let navigation: Navigation
    public var configuration: Configuration
    let destination: DestinationType
    
    public func push() {
        CoreNavigation.protect(destination: destination, continue: {
            self.resolveTarget({ view in
                self.navigation.push(view: view, configuration: self.configuration)
            }) { (error) in
                fatalError()
            }
        }) { (error) in
            fatalError()
        }
    }
    
    public func sheet() {
        CoreNavigation.protect(destination: destination, continue: {
            self.resolveTarget({ (view) in
                self.navigation.sheet(view: view, configuration: self.configuration)
            }) { (error) in
                fatalError()
            }
        }) { (error) in
            fatalError()
        }
    }
    
    private func resolveTarget(_ onComplete: @escaping (DestinationType.ViewType) -> Void, onError: @escaping (Error) -> Void) {
        destination.resolveTarget(with: Resolver<DestinationType.ViewType>(route: nil, onComplete: onComplete, onError: onError))
    }
}
