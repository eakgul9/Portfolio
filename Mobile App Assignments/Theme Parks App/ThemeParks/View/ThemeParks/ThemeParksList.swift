//
//  ThemeParksList.swift
//  Assignment0210
//
//  Created by eylul on 2/10/22.
//

import SwiftUI

struct ThemeParksList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showWaterParksOnly = false
    
    var filteredThemeParks: [ThemePark] {
        modelData.themeParks.filter { themepark in
            (!showWaterParksOnly || themepark.isWaterPark)
        }
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showWaterParksOnly) {
                    Text("WaterParks only")
                }
                ForEach(filteredThemeParks) { themepark in
            NavigationLink {
                ThemeParkDetail(themepark: themepark)
            } label: {
                ThemeParksRow(themepark: themepark)
                }
            }
        }
        .navigationTitle("Theme Parks")
    }
}

struct ThemeParksList_Previews: PreviewProvider {
    static var previews: some View {
            ThemeParksList()
            .environmentObject(ModelData())
            }
        }
    }
