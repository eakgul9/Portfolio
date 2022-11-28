/**
 * Blog4GamersArticle is the article service—it completely hides the data store from the rest of the app.
 * No other part of the app knows how the data is stored. If anyone wants to read or write data, they have
 * to go through this service.
 */
import Foundation

import Firebase

import Combine

let COLLECTION_NAME = "articles"
let PAGE_LIMIT = 20

enum ArticleServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

class Blog4GamersArticle: ObservableObject {
    public let db = Firestore.firestore()

    @Published var error: Error?
    
    var articlesListFull = false
    var currentPage = 0
    let perPage = 20

    func createArticle(article: Article) -> String {
        var ref: DocumentReference? = nil

        ref = db.collection(COLLECTION_NAME).addDocument(data: [
            "title": article.title,
            "date": article.date,
            "body": article.body,
            "url": article.url ?? "No URL was inputted",
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }

        return ref?.documentID ?? ""
    }

    func deleteArticle(articleToDelete: Article) {
        db.collection(COLLECTION_NAME).document(articleToDelete.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func fetchArticles() async throws -> [Article] {
        let articleQuery = db.collection(COLLECTION_NAME)
            .order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)

        
        let querySnapshot = try await articleQuery.getDocuments()

        return try querySnapshot.documents.map {

            guard let title = $0.get("title") as? String,

                let dateAsTimestamp = $0.get("date") as? Timestamp,
                let body = $0.get("body") as? String else {
                throw ArticleServiceError.mismatchedDocumentError
            }

            return Article(
                id: $0.documentID,
                title: title,
                date: dateAsTimestamp.dateValue(),
                body: body,
                url: $0.get("url") as? String
            )
        }
    }
}
