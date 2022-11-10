//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by BS1010 on 7/11/22.
//

import SwiftUI

@main
struct MovieAppApp: App {
    
    @StateObject var favorites = Favorites()
    @StateObject var userStateViewModel = UserStateViewModel()
    @StateObject var authTokenViewModel = AuthTokenViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ApplicationSwitcher()
            }
            .accentColor(Color("Color"))
            .environmentObject(favorites)
            .environmentObject(userStateViewModel)
            .environmentObject(authTokenViewModel)
        }
    }
}

struct ApplicationSwitcher: View {
    @EnvironmentObject var vm: UserStateViewModel
    @EnvironmentObject var authVM: AuthTokenViewModel
    
    var body: some View {
        if vm.isLoggedIn {
            MovieListView()
        }
        else {
            ContentView()
                .onAppear{
                    authVM.deleteToken()
                }
        }
    }
}
