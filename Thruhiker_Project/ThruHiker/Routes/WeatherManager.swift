//
//  WeatherManager.swift
//  ThruHiker
//
//  Created by Gavin Lebo on 5/17/24.
//

import Foundation
import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weatherIconURL: URL?
    @Published var temperature: Double?
    
    func fetchWeather(lat: Double, lon: Double) {
        let apiKey = "0963b4703e67cc7f93b9daaf7db9bef4"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    if let icon = weatherData.weather.first?.icon {
                        self.weatherIconURL = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                    }
                    self.temperature = weatherData.main.temp
                }
            }
        }.resume()
    }
}



struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
    }
}
