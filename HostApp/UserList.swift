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
        Route("user/1", configure: { $0
            .animate(.easeInOut(duration: 0.3))
            .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
        }) {
            Text("User details ...")
        }
        //        Route("user/1", configure: { (request) -> AnyRequest in
        ////            return request.animate(.easeInOut(duration: 0.3)).asAnyRequest()
        ////                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
        //        }) {
        //            Text("User details ...")
        //        }
        //        Button(action: {
        //            self.navigation
        //                .request("user/1")
        //                .protect(with: ProtecSpc())
        //                .animate(.easeInOut(duration: 0.3))
        //                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
        //                .navigate()
        //        }) {
        //            Text("User details!")
        //        }
    }
}
