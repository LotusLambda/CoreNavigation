import UIKit

public extension UIViewController {
    static func from<DestinationType: Destination>(destination: DestinationType) throws -> DestinationType.ViewControllerType {
        try destination.viewController()
    }

    static func from(matchable: Matchable) throws -> UIViewController {
        try matchable.viewController()
    }
}
