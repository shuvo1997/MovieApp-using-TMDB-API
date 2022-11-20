//
//  HomeView.swift
//  MovieApp
//
//  Created by BS1010 on 7/11/22.
//

import SwiftUI

enum SegmentedBarEnum {
    case Movie, Favorite
}
enum Path {
    case Home
    case Details
}

struct MovieListView: View {
    
    @State private var selected = SegmentedBarEnum.Movie
    
    @StateObject var viewModel = MovieListViewModel()
    
    @EnvironmentObject var favorites: Favorites
    @EnvironmentObject var userVM: UserStateViewModel
    @EnvironmentObject var authVM: AuthTokenViewModel
    @EnvironmentObject var alertVM: AlertDialogViewModel
    
    @State var searchTerm = ""
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("Color"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    fileprivate func LogoutButton() -> some View {
        Button {
            alertVM.createLogoutAlert {
                
                //MARK: - Ok button action
                Task {
                    await userVM.signOut()
                }
                alertVM.alert.toggle()
            }
        } label: {
            Image(systemName:  "rectangle.portrait.and.arrow.right")
                .foregroundColor(Color.white)
        }
    }
    
    
    var listData: [SingleMovie] {
        if searchTerm.isEmpty {
            return viewModel.movieData
        }
        else {
            return viewModel.searchResults
        }
    }
    
    var body: some View {
        if userVM.isBusy {
            ProgressView()
        }
        else {
            VStack{
                Picker("", selection: $selected){
                    Text("Movie")
                        .tag(SegmentedBarEnum.Movie)
                    Text("Favorite")
                        .tag(SegmentedBarEnum.Favorite)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal,10)
                .padding(.top, 20)
                
                //MARK: - Showing Movie Data
                if selected == SegmentedBarEnum.Movie {
                    List(listData, id: \.self){ movie in
                        NavigationLink(value: movie) {
                            MovieRow(movie: movie)
                        }
                    }
                }
                //MARK: - Showing Favorite Data
                else {
                    List(listData, id: \.self){ movie in
                        if favorites.contains(movie){
                            NavigationLink(value: movie) {
                                MovieRow(movie: movie)
                            }
                        }
                    }
                }
                Spacer()
            }
            .animation(.default, value: searchTerm)
            .animation(.default, value: selected)
            .padding(.horizontal, 15)
            .toolbarBackground(Color("Color"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Welcome")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                LogoutButton()
            }
            .navigationDestination(for: SingleMovie.self) { movie in
                MovieDetailsView(movie: movie)
            }
            .searchable(text: $searchTerm)
            .onChange(of: searchTerm) { searchText in
                viewModel.searchResults = viewModel.movieData.filter({ movie in
                    movie.title.lowercased().contains(searchTerm.lowercased())
                })
            }
        }
    }
}
