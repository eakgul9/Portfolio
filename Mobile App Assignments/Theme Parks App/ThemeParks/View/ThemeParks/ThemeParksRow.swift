//
//  ThemeParksRow.swift
//  Assignment0210
//
//  Created by eylul on 2/10/22.
//

import SwiftUI

struct ThemeParksRow: View {
    var themepark: ThemePark
    var body: some View {
        HStack {
            themepark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(themepark.name)
        
            Spacer()
            
            if themepark.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

struct ThemeParksRow_Previews: PreviewProvider {
    
    static var themeParks = ModelData().themeParks
    
    static var previews: some View {
        Group {
            ThemeParksRow(themepark: themeParks[0])
            ThemeParksRow(themepark: themeParks[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
