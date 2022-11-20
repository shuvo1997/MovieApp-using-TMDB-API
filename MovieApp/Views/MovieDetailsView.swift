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
    @EnvironmentObject var alertVM: AlertDialogViewModel
    @EnvironmentObject var userVM: UserStateViewModel
    
    fileprivate func MoviePosterImage() -> some View {
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
    }
    
    fileprivate func FavoriteButton() -> some View{
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
    }
    
    var body: some View {
        ScrollView {
            VStack{
                MoviePosterImage()
                    .padding(.top, 10)
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color"))
                    .padding()
                Text(movie.overview)
                    .font(.body)
                    .padding(.horizontal, 25)
            }
        }
        FavoriteButton()
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
            .padding(.bottom, 25)
        .toolbarBackground(Color("Color"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
