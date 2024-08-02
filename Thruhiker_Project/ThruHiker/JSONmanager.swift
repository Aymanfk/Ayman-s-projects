// JSONManager.swift

import Foundation
struct MileMarker: Codable {
    let Mile: Double
    let Long: Double
    let Lat: Double
}

struct JSONManager {
    static func loadMileMarkers(from file: String) -> [MileMarker] {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            fatalError("Could not find \(file).json in bundle.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let mileMarkers = try decoder.decode([MileMarker].self, from: data)
            return mileMarkers
        } catch {
            fatalError("Failed to load mile markers from \(file).json: \(error.localizedDescription)")
        }
    }
    
    static func getCoord(for mile: Double, from file: String) -> (Long: Double, Lat: Double)? {
        let roundedMile = (mile * 2).rounded(.down) / 2
        let mileMarkers = loadMileMarkers(from: file)
        
        if let marker = mileMarkers.first(where: { $0.Mile == roundedMile }) {
            return (marker.Long, marker.Lat)
        }
        
        return nil
    }
}
