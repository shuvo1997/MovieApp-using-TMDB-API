//
//  URLImageView.swift
//  MovieApp
//
//  Created by BS1010 on 14/11/22.
//

import SwiftUI


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
