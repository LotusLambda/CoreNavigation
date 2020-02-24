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
                .request(UserDetails())
                .protect(with: ProtecSpc())
                .animate(.easeInOut(duration: 1))
                .transition(AnyTransition.move(edge: .top))
                .navigate()
        }) {
            Text("User details!").onAppear {
                print("Appear!")
            }
        }
    }
}
