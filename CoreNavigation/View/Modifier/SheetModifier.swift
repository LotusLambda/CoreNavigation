import SwiftUI

struct SheetModifier: ViewModifier {
    class ViewModel: ObservableObject {
        @Published var isPresented: Bool = false
        var content: AnyView?
    }
    
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var navigation: Navigation

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: self.$viewModel.isPresented, onDismiss: {
                self.navigation.dismiss(viewModel: self.viewModel)
            }) {
                self.viewModel.content
            }
    }
}
