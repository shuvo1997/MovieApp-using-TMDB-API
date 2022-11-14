//
//  ErrorView.swift
//  MovieApp
//
//  Created by BS1010 on 10/11/22.
//

import SwiftUI



struct ErrorView: View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var error: String
    @Binding var alert: Bool
    @Binding var isConfirmationView: Bool
    @Binding var alertTitle: String
    
    @EnvironmentObject var userVM: UserStateViewModel
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    Text(alertTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                HStack {
                    Spacer()
                    if isConfirmationView {
                        ErrorViewButton(alert: $alert, buttonText: "OK",action: {
                            Task {
                                await userVM.signOut()
                            }
                            self.alert.toggle()
                        })
                    }
                    ErrorViewButton(alert: $alert, buttonText: "Cancel", action: {
                        if alertTitle == "Session Expired" {
                            Task {
                                await userVM.signOut()
                            }
                            
                            self.alert.toggle()
                        }
                        else {
                            self.alert.toggle()
                        }
                    })
                }
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .padding(.leading,30)
        .padding(.top, 100)
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}

struct ErrorViewButton: View {
    @Binding var alert: Bool
    let buttonText: String
    let action: () -> Void
    var body: some View {
        Button(action: action){
            Text(buttonText)
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width / 2 - 120)
        }
        .background(Color("Color"))
        .cornerRadius(10)
        .padding(.top, 25)
        .padding(.trailing, 10)
        
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView()
//    }
//}
