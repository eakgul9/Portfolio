//
//  MelpReview.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import Foundation

import Firebase

import Combine

let COLLECTION_NAME = "articles"
let PAGE_LIMIT = 20

enum ReviewServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

class MelpReview: ObservableObject {
    public let db = Firestore.firestore()

    @Published var error: Error?
    
    var reviewsListFull = false
    var currentPage = 0
    let perPage = 20

    func createReview(review: Review) -> String {
        var ref: DocumentReference? = nil

        ref = db.collection(COLLECTION_NAME).addDocument(data: [
            "title": review.title,
            "date": review.date,
            "body": review.body,
            "url": review.url ?? "No URL was inputted",
            "movieId": review.movieId ?? "",
            "movieTitle": review.movieTitle ?? "",
            "movieImage": review.movieImage ?? "",
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }

        return ref?.documentID ?? ""
    }

    func deleteReview(reviewToDelete: Review) {
        db.collection(COLLECTION_NAME).document(reviewToDelete.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func fetchReviews() async throws -> [Review] {
        let reviewQuery = db.collection(COLLECTION_NAME)
            .order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)

        
        let querySnapshot = try await reviewQuery.getDocuments()

        return try querySnapshot.documents.map {

            guard let title = $0.get("title") as? String,

                let dateAsTimestamp = $0.get("date") as? Timestamp,
                let body = $0.get("body") as? String else {
                throw ReviewServiceError.mismatchedDocumentError
            }

            return Review(
                id: $0.documentID,
                title: title,
                date: dateAsTimestamp.dateValue(),
                body: body,
                url: $0.get("url") as? String,
                movieId: $0.get("movieId") as? String,
                movieTitle: $0.get("movieTitle") as? String,
                movieImage: $0.get("movieImage") as? String
            )
        }
    }
    func fetchReviewsByMovie(movieId: String) async throws -> [Review] {
        let reviewQuery = db.collection(COLLECTION_NAME)
            .whereField("movieId", in: [movieId])
            .order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)

        
        let querySnapshot = try await reviewQuery.getDocuments()

        return try querySnapshot.documents.map {

            guard let title = $0.get("title") as? String,

                let dateAsTimestamp = $0.get("date") as? Timestamp,
                let body = $0.get("body") as? String else {
                throw ReviewServiceError.mismatchedDocumentError
            }

            return Review(
                id: $0.documentID,
                title: title,
                date: dateAsTimestamp.dateValue(),
                body: body,
                url: $0.get("url") as? String,
                movieId: $0.get("movieId") as? String,
                movieTitle: $0.get("movieTitle") as? String,
                movieImage: $0.get("movieImage") as? String
            )
        }
    }
}
