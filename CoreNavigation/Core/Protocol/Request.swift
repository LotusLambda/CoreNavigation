import SwiftUI

public protocol Request: Configurable {
    func navigate()
}
