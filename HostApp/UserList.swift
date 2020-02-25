import SwiftUI
import CoreNavigation

enum MyError: Error {
    case abc
}

struct ProtecSpc: ProtectionSpace {
    func protect(with resolver: Resolver<Void>) {
        resolver.complete(())
    }
}

struct UserList: View {
    @EnvironmentObject var navigation: Navigation
    
    var body: some View {
        Button(action: {
            self.navigation
                .request("user/1")
                .protect(with: ProtecSpc())
                .animate(.easeInOut(duration: 0.3))
                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
                .navigate()
        }) {
            Text("User details!").onAppear {
                print("Appear!")
            }
        }
    }
}
