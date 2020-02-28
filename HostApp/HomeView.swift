import SwiftUI
import CoreNavigation

struct HomeView: View {
    @EnvironmentObject var navigation: Navigation
    @Binding var color: Color
    
    var body: some View {
        GeometryReader { (proxy) in
            HStack {
                Button(action: {
                    self.navigation.request(DestinationColor(color: self.$color))
                        .animate(.easeInOut(duration: 0.3))
                        .transition(.move(edge: .top))
                        .push()
                }) {
                    Text("Color!")
                }
                
                Button(action: {
                    self.navigation.request(DestinationColor(color: self.$color))
                        .animate(.easeInOut(duration: 0.3))
                        .transition(.move(edge: .top))
                        .push()
                }) {
                    Text("Color!")
                }
            }.frame(width: proxy.size.width, height: proxy.size.height)
            .background(self.color)
        }
    }
}
