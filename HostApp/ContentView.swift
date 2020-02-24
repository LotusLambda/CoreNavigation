import SwiftUI
import CoreNavigation

struct ContentView: View {
    var body: some View {
        GeometryReader { (proxy) in
            NavigationContainer {
                UserList()
            }.frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
