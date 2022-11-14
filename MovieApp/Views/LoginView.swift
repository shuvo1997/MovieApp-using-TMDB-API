//
//  ContentView.swift
//  MovieApp
//
//  Created by BS1010 on 7/11/22.
//

import SwiftUI

struct Login: View {
    @State var color = Color.black.opacity(0.7)
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert: Bool = false
    @State var isVisible: Bool = false
    @State var alert = false
    @State var error = ""
    @State private var isVerified = false
    @State private var isConfirmationView = false
    @State private var alertTitle = ""
    
    
    @State private var keychainUsername: String = ""
    @State private var keychainPassword: String = ""
    
    @EnvironmentObject var vm: UserStateViewModel
    @EnvironmentObject var authViewModel: AuthTokenViewModel
    @EnvironmentObject var alertViewModel: AlertDialogViewModel
    
    init() {
        saveData()
    }
    
    func getData() {
        guard let dic = KeychainManager.get(service: "api.themoviedb.org")
        else {
            print("Failed to read password")
            return
        }
        keychainUsername = dic[kSecAttrAccount] as! String
        let passwordData = dic[kSecValueData] as! Data
        keychainPassword = String(data: passwordData, encoding: .utf8) ?? ""
        print(keychainUsername)
        print(keychainPassword)
    }
    
    func saveData() {
        do {
            try KeychainManager.save(service: "api.themoviedb.org", account: "Shuvo123", data: "123".data(using: .utf8) ?? Data())
        } catch {
            print(error)
        }
    }
    
    func deleteData() {
        KeychainManager.delete(service: "api.themoviedb.org")
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
                        
                        TextField("Username", text: $username)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.username != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                        
                        HStack (spacing: 15){
                            VStack{
                                if self.isVisible{
                                    TextField("Password", text: self.$password)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.none)
                                }
                                else {
                                    SecureField("Password", text: self.$password)
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
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Color") : self.color, lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            self.verify()
                            Task {
                                if isVerified {
                                    let result = await vm.signIn(username: username, password: password)
                                    //                                        path.append(.ok)
                                    authViewModel.saveToken()
                                    print("Navigating to movielist screen")
                                    print(result)
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
                    .padding(.horizontal, 25)
                    //                    if self.alert {
                    //                        ErrorView(error: self.$error, alert: self.$alert, isConfirmationView: $isConfirmationView, alertTitle: $alertTitle)
                    //                    }
                }
            }
        }
        .navigationTitle("")
    }
    
 func verify() {
        if self.username != "" && self.password != "" {
            getData()
            if username != keychainUsername {
                configureAlertView(errorMsg: "Username is incorrect", errorTitle: "Error")
                return
            }
            if password != keychainPassword {
                configureAlertView(errorMsg: "Password is incorrect", errorTitle: "Error")
                return
            }
            self.isVerified.toggle()
        }
        else {
            configureAlertView(errorMsg: "Please fill all the contents properly", errorTitle: "Error")
            return
        }
    }
    
    func configureAlertView(errorMsg: String, errorTitle: String) {
        alertViewModel.isConfirmationView = false
        alertViewModel.error = errorMsg
        alertViewModel.alertTitle = errorTitle
        alertViewModel.alert.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

