import SwiftUI
import CoreNavigation

struct ContentView: View {
    @State var color: Color = .green
    
    var body: some View {
        GeometryReader { (proxy) in
            NavigationContainer {
                HomeView(color: self.$color)
            }.frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
