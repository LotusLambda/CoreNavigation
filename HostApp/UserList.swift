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
        Link({
            BlueView()
        }, { $0
            .animate(.easeInOut(duration: 0.3))
            .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
            .protect(with: ProtecSpc())
        }) {
            Text("JHe")
        }   
    }
}
