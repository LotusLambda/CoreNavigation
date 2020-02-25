import SwiftUI

public struct ViewRequest<DestinationType: Destination>: Request {
    let navigation: Navigation
    public var configuration: Configuration
    let destination: DestinationType
    
    public func navigate() {
        if let protectable = destination as? Protectable {
            let resolver = Resolver<Void>(onComplete: { (_) in
                self.resolve()
            }) { (error) in
                
            }
            protectable.protect(with: resolver)
        } else {
            resolve()
        }
    }
    
    private func resolve() {
        destination.resolve(with: Resolver<DestinationType.ViewType>(onComplete: { view in
            self.navigation.push(view: view, configuration: self.configuration)
        }, onError: { (error) in
            
        }))
    }
}
