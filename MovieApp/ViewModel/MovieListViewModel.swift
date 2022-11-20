//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by BS1010 on 9/11/22.
//

import Foundation

struct Constants {
    static let movieUrl = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=38e61227f85671163c275f9bd95a8803&query=marvel")
}


class MovieListViewModel: ObservableObject {
    @Published var movieData: [SingleMovie] = []
    @Published var searchResults: [SingleMovie] = []
    
    init() {
        fetch()
    }
    
    func fetch() {
        URLSession.shared.request(url: Constants.movieUrl, expecting: MovieResponse.self) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.movieData = movies.results
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
