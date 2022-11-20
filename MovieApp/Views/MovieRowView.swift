//
//  MovieRowView.swift
//  MovieApp
//
//  Created by BS1010 on 16/11/22.
//

import Foundation
import SwiftUI


struct MovieRow: View {
    
    @EnvironmentObject var favorites: Favorites
    @State var color = Color.black.opacity(0.7)
    let movie: SingleMovie
    
    var body: some View {
        HStack {
            URLImage(urlString: movie.backdropPath ?? "")
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.body)
                    .bold()
                Text(movie.releaseDate)
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundColor(self.color)
            }
            if favorites.contains(movie) {
                Spacer()
                Image(systemName: "heart.fill")
                    .accessibilityLabel("This is a favorite button")
                    .foregroundColor(.red)
                    .onTapGesture {
                        favorites.remove(movie)
                    }
            }
            else {
                Spacer()
                Image(systemName: "heart")
                    .accessibilityLabel("This is a favorite button")
                    .foregroundColor(.red)
                    .onTapGesture {
                        favorites.add(movie)
                    }
            }
            
        }
    }
}
