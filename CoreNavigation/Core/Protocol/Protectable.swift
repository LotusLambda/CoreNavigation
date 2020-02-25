import SwiftUI

public protocol Protectable {
    func protect(with resolver: Resolver<Void>)
}

func protect(destination: AnyDestination, continue: @escaping () -> Void, error: @escaping (Error) -> Void) {
    if let protectable = destination as? Protectable {
        let resolver = Resolver<Void>(route: nil, onComplete: `continue`, onError: error)
        protectable.protect(with: resolver)
    } else {
        `continue`()
    }
}
