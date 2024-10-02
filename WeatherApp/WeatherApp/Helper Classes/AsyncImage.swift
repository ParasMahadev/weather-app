//
//  AsyncImage.swift
//  WeatherApp
//
//  Created by Paras Navadiya on 10/1/24.
//

import SwiftUI

struct AsyncImage: View {
    @State private var image: UIImage? = nil
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}
