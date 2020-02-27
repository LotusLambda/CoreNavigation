import SwiftUI

public struct Pop<Label: View>: View {
    @EnvironmentObject var navigation: Navigation
    
    public let label: () -> Label
    
    public var body: some View {
        Button(action: {
            self.navigation.pop()
        }) {
            label()
        }
    }
}

extension Pop {
    public init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label
    }
}
