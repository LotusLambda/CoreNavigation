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
                .request(DestinationUserDetails())
                .protect(with: ProtecSpc())
                .transition(AnyTransition.move(edge: .top))
                .animate(.easeInOut(duration: 0.3))
                .navigate()
        }) {
            Text("User details!").onAppear {
                print("Appear!")
            }
        }
    }
}
