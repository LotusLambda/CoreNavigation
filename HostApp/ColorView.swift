import SwiftUI
import CoreNavigation

struct ColorView: View {
    @EnvironmentObject var navigation: Navigation
    @Binding var color: Color
    
    var body: some View {
        GeometryReader { (proxy) in
            HStack {
                Button(action: {
                    self.navigation.request(DestinationColor(color: self.$color)).sheet()
                }, label: {
                    Text("Sheet!")
                }).focusable(true)
                
                Pop {
                    Text("Pop!")
                }
                
                Dismiss {
                    Text("Dismiss!")
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(self.color)
        }
    }
}
