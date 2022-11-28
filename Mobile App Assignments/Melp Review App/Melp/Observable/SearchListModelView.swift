//
//  SearchListModelView.swift
//  Melp
//
//  Created by Evan Steinhoff on 5/4/22.
//

import Foundation
import Combine

class SearchListModelView: ObservableObject {
    @Published var SearchText = ""
    @Published var results: [MostPopularMoviesResult] = []
    @Published var loading = true
    @Published var errorOccurred = false
    var cancellables = Set<AnyCancellable>()
    init() {
        loadPopMovies()
        setupSearchObservable ()
    }
    func loadPopMovies() {
        $SearchText
            .map( { $0.trimmingCharacters(in: .whitespacesAndNewlines) } )
            .filter({ $0.isEmpty == true })
            .map ({ term -> URL in
                self.errorOccurred = false
                self.loading = true
                guard let url = URL(string: "\(MOST_POP_MOVIES)/\(API_KEY)") else {
                    fatalError("Should never happen, but just in case…URL didn’t work 😔")
                }
                return url
            })
            .flatMap({ url in
                
                return URLSession.shared.dataTaskPublisher(for: url)
            })
            .receive(on: DispatchQueue.main)
            .tryMap (handleOuput)
            .decode(type: MostPopularMoviesPage.self, decoder: JSONDecoder())
            .sink (receiveCompletion: { completion in
                print("MOVIES completion \(completion)")
            }, receiveValue: { [weak self] (movies) in
                self?.loading = false
                self?.results = movies.items
            }).store(in: &cancellables)
    }
    
    func setupSearchObservable () {
        $SearchText
            .debounce( for: 0.4, scheduler: RunLoop.main )
            .map( { $0.trimmingCharacters(in: .whitespacesAndNewlines) } )
            .filter({ $0.isEmpty == false })
            .map ({ term -> URL in
                self.errorOccurred = false
                self.loading = true
                let movieString :String = term.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                print("got here \(movieString)")
                guard let url = URL(string: "\(SEARCH_MOVIE)/\(API_KEY)/?title_type=feature&title=\(movieString)") else {
                    fatalError("Should never happen, but just in case…URL didn’t work 😔")
                }
                return url
            })
            .flatMap({ url in
                
                return URLSession.shared.dataTaskPublisher(for: url)
            })
            .receive(on: DispatchQueue.main)
            .tryMap (handleOuput)
            .decode(type: SearchMoviePage.self, decoder: JSONDecoder())
            .sink (receiveCompletion: { completion in
                print("SEARCH completion \(completion)")
            }, receiveValue: { [weak self] (movies) in
                self?.loading = false
                
                self?.results = movies.results
            }).store(in: &cancellables)
        
    }
}

func handleOuput (output: URLSession.DataTaskPublisher.Output) throws -> Data {
    guard
        let response = output.response as? HTTPURLResponse,
        response.statusCode >= 200 && response.statusCode < 300 else {
        throw URLError(.badServerResponse)
    }
    return output.data
}
