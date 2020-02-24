import SwiftUI
import CoreNavigation

struct UserDetails: View {
    @EnvironmentObject var navigation: Navigation
    
    var body: some View {
        GeometryReader { (proxy) in
            Button(action: {
                self.navigation.pop()
            }) {
                Text("Pop")
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
//            .background(Color.blue)
        }
    }
}
