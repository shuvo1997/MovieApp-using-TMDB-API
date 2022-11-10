//
//  MovieDetailsView.swift
//  MovieApp
//
//  Created by BS1010 on 8/11/22.
//

import SwiftUI

struct MovieDetailsView: View {
    
    let movie: SingleMovie
    let baseURL = "https://image.tmdb.org/t/p/original"
    @EnvironmentObject var favorites: Favorites
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string:baseURL+movie.posterPath)){ phase in
                if let image = phase.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 400, alignment: .bottom)
                        .ignoresSafeArea(edges: .top)
                        .shadow(radius: 7)
                } else if phase.error != nil {
                    Text("Error Occured!")
                        .foregroundColor(Color.red)
                }
                else {
                    ProgressView()
                        .frame(height: 400)
                }
            }
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("Color"))
                .padding()
            Text(movie.overview)
                .font(.body)
                .padding(.horizontal, 25)
            
            Button(action: {
                if favorites.contains(movie) {
                    favorites.remove(movie)
                } else {
                    favorites.add(movie)
                }
            }){
                if favorites.contains(movie) {
                    Text("Remove from Favorites")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 40)
                }
                else {
                    Text("Add to Favorites")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 40)
                }
                    
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: SingleMovie(adult: false, backdropPath: "", genreIDS: [], id: 0, originalLanguage: OriginalLanguage.en, originalTitle: "Marvel", overview: ",jnjk", popularity: 0.0, posterPath: "/w2PMyoyLU22YvrGK3smVM9fW1jj.jpg", releaseDate: "", title: "jkjkhj", video: true, voteAverage: 0.0, voteCount: 0))
            .environmentObject(Favorites())
    }
}
