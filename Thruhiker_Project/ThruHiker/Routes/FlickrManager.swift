//
//  FlickrManager.swift
//  ThruHiker
//
//  Created by Gavin Lebo on 5/17/24.
//

import Foundation
import SwiftUI
import Combine

struct FlickrPhoto: Identifiable, Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    var imageUrl: String {
        "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
    }
}

struct FlickrResponse: Decodable {
    let photos: FlickrPhotos
}

struct FlickrPhotos: Decodable {
    let photo: [FlickrPhoto]
}

class FlickrViewModel: ObservableObject {
    @Published var photos: [FlickrPhoto] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPhotos(latitude: Double, longitude: Double) {
        let apiKey = "37c4832b78e1bbcd26e9968d87e9dec6"
        let radius = 15
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(latitude)&lon=\(longitude)&radius=\(radius)&format=json&nojsoncallback=1"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .replaceError(with: FlickrResponse(photos: FlickrPhotos(photo: [])))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.photos = response.photos.photo
            }
            .store(in: &cancellables)
    }
}
