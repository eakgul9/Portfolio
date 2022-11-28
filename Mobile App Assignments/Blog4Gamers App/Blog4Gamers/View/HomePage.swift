//
//  HomePage.swift
//  Blog4Gamers
//
//  Created by eylul on 4/3/22.
//

import SwiftUI

struct HomePage: View {
    @State private var isPressed = false

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Group {
                Text("Blog 4 Gamers")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
      
                Text("This is a blog for gamers, share your opinion on your favorite game, character or more!")
                    .font(.subheadline)
                
                Text("click me!")
                    .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xSmall/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.pink)
            }
            .multilineTextAlignment(.center)
            
                Button {
                withAnimation {
                    isPressed.toggle()
                }
    
                } label: {
                    Label( "", systemImage: "gamecontroller.fill")
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(isPressed ? 360 : 0))
            }

            }
        }
        .edgesIgnoringSafeArea(.all)

    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
    HomePage()
    }
}
