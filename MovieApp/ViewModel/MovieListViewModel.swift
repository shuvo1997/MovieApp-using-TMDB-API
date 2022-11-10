//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by BS1010 on 9/11/22.
//

import Foundation


class MovieListViewModel: ObservableObject {
    @Published var movieResponse: MovieResponse?
    
    
    func fetch() {
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=38e61227f85671163c275f9bd95a8803&query=marvel") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            
            //MARK: - Convert to json
            
            do{
                let movies = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    self.movieResponse = movies
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}
