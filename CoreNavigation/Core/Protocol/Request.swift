import SwiftUI

public protocol Request: Configurable {
    func push()
    func sheet()
}
