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
    @StateObject var alertViewModel = AlertDialogViewModel()
    
    var body: some Scene {
        WindowGroup {
            ApplicationSwitcher()
                .environmentObject(favorites)
                .environmentObject(userStateViewModel)
                .environmentObject(authTokenViewModel)
                .environmentObject(alertViewModel)
        }
    }
}

struct ApplicationSwitcher: View {
    @EnvironmentObject var vm: UserStateViewModel
    @EnvironmentObject var authVM: AuthTokenViewModel
    @EnvironmentObject var alertVM: AlertDialogViewModel
    
    @State var path = NavigationPath()
    
    var body: some View {
        ZStack{
            if vm.isLoggedIn {
                NavigationStack(path: $path) {
                    MovieListView()
                }
                .onReceive(MyNotificationManager.alertNotificationPublisher) { _ in
                    print("Poseted Notification Received")
                    alertVM.createAlertNotification {
                        path = NavigationPath()
                        alertVM.alert.toggle()
                    }
                }
            }
            else {
                Login()
                    .onAppear{
                        authVM.deleteToken()
                    }
            }
            if alertVM.alert {
                ErrorView(error: $alertVM.error, alert: $alertVM.alert, isConfirmationView: $alertVM.isConfirmationView, alertTitle: $alertVM.alertTitle, okButtonAction: $alertVM.okBtnAction)
            }
        }
        .animation(.easeInOut, value: alertVM.alert)
    }
}
