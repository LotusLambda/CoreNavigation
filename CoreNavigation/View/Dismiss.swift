import SwiftUI

public struct Dismiss<Label: View>: View {
    @EnvironmentObject var navigation: Navigation
    
    public let label: () -> Label
    
    public var body: some View {
        Button(action: {
            self.navigation.dismiss()
        }) {
            label()
        }
    }
}

extension Dismiss {
    public init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label
    }
}
