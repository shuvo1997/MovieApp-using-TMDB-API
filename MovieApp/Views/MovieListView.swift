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
            VStack{
                HStack {
                    Text("Welcome")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                Picker("", selection: $selected){
                    Text("Movie")
                        .tag(SegmentedBarEnum.Movie)
                    Text("Favorite")
                        .tag(SegmentedBarEnum.Favorite)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal,10)
                
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
                    }
                    .onReceive(timer){_ in
                        if authVM.checkExpired(currentTime: authVM.getTime()) {
                            userVM.isLoggedIn = false
                        }
                    }
                }
                
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                Button {
                    Task{
                        await userVM.signOut()
                    }
                    authVM.deleteToken()
                } label: {
                    Image(systemName:  "rectangle.portrait.and.arrow.right")
                        .foregroundColor(Color("Color"))
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





//MARK: - To fetch image using a url
struct URLImage: View {
    let baseURL = "https://image.tmdb.org/t/p/original"
    let urlString: String
    let imageWidth: CGFloat = 100
    let imageHeight: CGFloat = 60
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data){
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageHeight)
                .background(Color.gray)
                .cornerRadius(10)
        }
        else{
            ProgressView()
                .frame(width: imageWidth, height: imageHeight)
                .onAppear{
                    fetchImageData()
                }
        }
    }
    private func fetchImageData() {
        let fullUrl = baseURL + urlString
       guard let url = URL(string: fullUrl) else {
           return
       }
       
       let task = URLSession.shared.dataTask(with: url){ data, _, _ in
           self.data = data
       }
        task.resume()
   }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
            .environmentObject(Favorites())
    }
}
