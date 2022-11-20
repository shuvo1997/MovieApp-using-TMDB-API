//
//  ContentView.swift
//  MovieApp
//
//  Created by BS1010 on 7/11/22.
//

import SwiftUI

struct Login: View{
    @State private var color = Color.black.opacity(0.7)
    @State private var isVisible: Bool = false
    
    @StateObject var dataManager = LoginDataManager()

    @EnvironmentObject var vm: UserStateViewModel
    @EnvironmentObject var authViewModel: AuthTokenViewModel
    @EnvironmentObject var alertViewModel: AlertDialogViewModel
    
    fileprivate func UserNameTextField() -> some View {
        TextField("Username", text: $dataManager.username)
            .padding()
            .background(RoundedRectangle(cornerRadius: 4).stroke(dataManager.username != "" ? Color("Color") : self.color, lineWidth: 2))
            .padding(.top, 25)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
    }
    
    fileprivate func PasswordTextField() -> some View {
        HStack (spacing: 15){
            VStack{
                if self.isVisible{
                    TextField("Password", text: $dataManager.password)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.none)
                }
                else {
                    SecureField("Password", text: $dataManager.password)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.none)
                }
            }
            Button(action: {
                self.isVisible.toggle()
            }){
                Image(systemName: self.isVisible ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(self.color)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 4).stroke(dataManager.password != "" ? Color("Color") : self.color, lineWidth: 2))
        .padding(.top, 25)
        
    }
    
    fileprivate func LoginButton() -> some View {
        Button(action: {
            Task {
                switch dataManager.verify() {
                case .AllOk:
                    let result = await vm.signIn(username: dataManager.username, password: dataManager.password)
                    authViewModel.saveToken()
                    print("Navigating to movielist screen")
                    print(result)
                case .UserNameIncorrect:
                    alertViewModel.configureAlertViewForLogin(errorMsg: "Username is incorrect", errorTitle: "Error")
                case .PasswordIncorrect:
                    alertViewModel.configureAlertViewForLogin(errorMsg: "Password is incorrect", errorTitle: "Error")
                case .EmptyField:
                    alertViewModel.configureAlertViewForLogin(errorMsg: "Please fill all the contents properly", errorTitle: "Error")
                    
                    
                }
            }
        }){
            Text("Login")
                .foregroundColor(.white)
                .bold()
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 50)
        }
        .background(Color("Color"))
        .cornerRadius(10)
        .padding(.top, 25)
    }
    
    var body: some View {
        VStack {
            if vm.isBusy {
                ProgressView()
            }
            else {
                ZStack {
                    VStack {
                        Image("logo")
                        
                        Text("Login to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        UserNameTextField()
                        PasswordTextField()
                        LoginButton()
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
        .onDisappear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                MyNotificationManager.postNotification()
            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                alertViewModel.sessionTimeOutAlert()
//            }
        }
        .navigationTitle("")
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

