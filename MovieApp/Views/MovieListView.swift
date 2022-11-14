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

struct MovieListView: View {
    
    @State private var selected = SegmentedBarEnum.Movie
    @StateObject var viewModel = MovieListViewModel()
    
    @EnvironmentObject var favorites: Favorites
    @EnvironmentObject var userVM: UserStateViewModel
    @EnvironmentObject var authVM: AuthTokenViewModel
    @EnvironmentObject var alertVM: AlertDialogViewModel
    
    @State private var alert: Bool = false
    @State private var isConfirmationView: Bool = true
    @State private var error = ""
    @State private var alertTitle = ""
    @State private var timeCount = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("Color"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        }
    var body: some View {
        if userVM.isBusy {
            ProgressView()
        }
        else {
            ZStack {
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
                        List{
                            ForEach(viewModel.movieResponse?.results ?? [], id: \.self) { movie in
                                NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                    MovieRow(movie: movie)
                                }
                            }
                        }
                        .onAppear{
                            viewModel.fetch()
                        }                    }
                    
                    //MARK: - Showing Favorite Data
                    else {
                        List{
                            ForEach(viewModel.movieResponse?.results ?? [], id: \.self) { movie in
                                if favorites.contains(movie) {
                                    NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                        MovieRow(movie: movie)
                                    }
                                }
                            }
                        }
                        .onAppear{
                            viewModel.fetch()
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 15)
//                if alertVM.alert {
//                    ErrorView(error: $alertVM.error, alert: $alertVM.alert, isConfirmationView: $alertVM.isConfirmationView, alertTitle: $alertVM.alertTitle)
//                }
            }
            .onReceive(timer){_ in
                if timeCount == 15 {
                    self.timer.upstream.connect().cancel()
                    alertVM.alertTitle = "Session Expired"
                    alertVM.isConfirmationView = false
                    alertVM.error = "The auth token session is expired"
//                    self.alert.toggle()
//                    Task{
//                        await userVM.signOut()
//                    }
                    alertVM.alert.toggle()
                }
//                timer.upstream.connect().cancel()
                timeCount += 1
                print("Counting time \(timeCount)")
            }
            .toolbarBackground(Color("Color"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Welcome")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                Button {
//                    alertVM.alert = true
                    alertVM.isConfirmationView = true
                    alertVM.error = "Do you want to log out?"
                    alertVM.alertTitle = "Logout"
                    alertVM.alert.toggle()
                } label: {
                    Image(systemName:  "rectangle.portrait.and.arrow.right")
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}


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
                .accessibilityLabel("This is a favorite resort")
                    .foregroundColor(.red)
                    .onTapGesture {
                        favorites.remove(movie)
                    }
            }
            else {
                Spacer()
                Image(systemName: "heart")
                    .accessibilityLabel("This is a favorite resort")
                        .foregroundColor(.red)
                        .onTapGesture {
                            favorites.add(movie)
                        }
            }
            
        }
    }
}






struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
            .environmentObject(Favorites())
    }
}
