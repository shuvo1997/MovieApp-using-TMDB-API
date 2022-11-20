//
//  Favorites.swift
//  MovieApp
//
//  Created by BS1010 on 9/11/22.
//

import Foundation

class Favorites: ObservableObject {
    
    private var movies: Set<Int>
    
    init(){
        movies = []
    }
    
    func contains(_ movie: SingleMovie) -> Bool {
        movies.contains(movie.id)
    }
    
    func add(_ movie: SingleMovie) {
        objectWillChange.send()
        movies.insert(movie.id)
        print(movies.count)
        save()
    }
    
    func remove(_ movie: SingleMovie) {
        objectWillChange.send()
        movies.remove(movie.id)
        save()
    }
    
    func save(){
        
    }
}
