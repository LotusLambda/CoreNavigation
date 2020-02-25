import SwiftUI

public protocol Protectable {
    func protect(with resolver: Resolver<Void>)
}
