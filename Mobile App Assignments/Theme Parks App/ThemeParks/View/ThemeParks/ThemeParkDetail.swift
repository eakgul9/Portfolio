//
//  ThemeParkDetail.swift
//  Assignment0210
//
//  Created by eylul on 2/10/22.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}
struct ThemeParkDetail: View {
    @EnvironmentObject var modelData: ModelData
    var themepark: ThemePark
    @State private var showDetail = false
    
    var themeparkIndex: Int {
        modelData.themeParks.firstIndex(where: { $0.id == themepark.id })!
    }
    
    var body: some View {
        ScrollView {
            MapView(coordinate: themepark.locationCoordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            CircleImage(image: themepark.image)
                .offset(y: -130)
                .padding(.bottom, -130)

            VStack(alignment: .leading) {
                HStack {
                    Text(themepark.name)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.themeParks[themeparkIndex].isFavorite)
                }

                HStack {
                    Text(themepark.city)
                    Spacer()
                    Text(themepark.state)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()
                
                Text("About \(themepark.name)")
                    .font(.title2)

                Button {
                    withAnimation {
                        showDetail.toggle()
                    }
                } label: {
                    Label("Graph", systemImage: "chevron.right.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        .scaleEffect(showDetail ? 1.5 : 1)
                        .padding(1)
                        
                
                }
            }

            if showDetail {
                Text(themepark.description)
                    .transition(.moveAndFade)

            }

        }
        .navigationTitle(themepark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ThemeParkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ThemeParkDetail(themepark: modelData.themeParks[0])
            .environmentObject(modelData)
    }
}
