//
//  ReviewUpdate.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import SwiftUI

struct ReviewUpdate: View {
    @EnvironmentObject var reviewService: MelpReview
    @Binding var updating: Bool
    //@Binding var reviews: [Review]
    
    var currentReview: Review {
        didSet {
            title = currentReview.title
            reviewBody = currentReview.body
            if let finalURL = currentReview.url {
                inputURL = finalURL
            }
        }
    }
    
    @State var title = ""
    @State var reviewBody = ""
    @State var inputURL = ""

    func updateReview(reviewToUpdate: Review) {
        updating = true
        reviewService.db.collection(COLLECTION_NAME).document(reviewToUpdate.id).setData(["title" : title, "body" : reviewBody, "url": inputURL], merge: true)
    }
 
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Title")) {
                    TextEditor(text: $title)
                }
                Section(header: Text("Body")) {
                    TextEditor(text: $reviewBody)
                        .frame(minHeight: 256, maxHeight: .infinity)
                }
                Section(header: Text("URL")) {
                    TextEditor(text: $inputURL)
                }
            }
            .navigationTitle("Edit Review")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        updating = false
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        updateReview(reviewToUpdate: currentReview)
                        updating = false
                        }, label: { Text("Submit")
                        })
                    .disabled(title.isEmpty || reviewBody.isEmpty)
                }
            }
        }
    }
}

