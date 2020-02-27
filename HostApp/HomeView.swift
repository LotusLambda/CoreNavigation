import SwiftUI
import CoreNavigation

struct HomeView: View {
    @EnvironmentObject var navigation: Navigation
    @Binding var color: Color
    
    var body: some View {
        GeometryReader { (proxy) in
            Button(action: {
                self.navigation.request(DestinationColor(color: self.$color)).sheet()
            }) {
                Text("Color!")
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(self.color)
        }
    }
}
