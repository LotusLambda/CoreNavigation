import SwiftUI
import CoreNavigation

struct ColorView: View {
    @EnvironmentObject var navigation: Navigation
    @Binding var color: Color
    
    var body: some View {
        GeometryReader { (proxy) in
            ZStack {
                self.color.frame(width: proxy.size.width, height: proxy.size.height)
                    
                HStack {
                    Button(action: {
                        self.navigation.pop()
                    }, label: {
                        Text("Pop!")
                    })
                    
                    Button(action: {
                        self.navigation.dismiss()
                    }, label: {
                        Text("Dismiss!")
                    })
                    
                    Button(action: {
                        self.navigation.request(DestinationColor(color: self.$color)).sheet()
                    }, label: {
                        Text("Sheet!")
                    })

                    VStack {
                        Button(action: {
                            self.color = .blue
                        }, label: {
                            Text("Blue")
                        })
                        
                        Button(action: {
                            self.color = .orange
                        }, label: {
                            Text("Orange")
                        })
                    }
                }
            }
        }
    }
}
