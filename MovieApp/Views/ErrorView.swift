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
    
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    Text("Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                Button(action: {
                    self.alert.toggle()
                }){
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .padding(.leading,30)
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
        
        
        
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView()
//    }
//}
