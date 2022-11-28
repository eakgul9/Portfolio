//
//  genreButton.swift
//  Melp
//
//  Created by Arusha Ramanathan on 5/4/22.
//

import SwiftUI

struct GenreButton: View {
    var genre: String
    @Binding var isSet: Bool

    var body: some View {
        Button(action: {
            isSet.toggle()
        }) {
            Text(genre)
                .foregroundColor(.indigo)
                .padding(.bottom, 5.0)
                .padding(.top, 5.0)
                .padding(.leading, 12.0)
                .padding(.trailing, 12.0)
            .overlay(
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(lineWidth: 1.0)
                    .foregroundColor(.indigo)
            )
            
        }
        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        
    }
}

struct GenreButton_Previews: PreviewProvider {
    static var previews: some View {
        GenreButton(genre: "Drama", isSet: .constant(true))
    }
}
