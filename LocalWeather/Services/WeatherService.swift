//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

protocol WeatherService {
    func getForecastFor(latitude: Double, longitude: Double, completion: @escaping (Result<Forecast, Error>) -> Void)
}

final class DarkSkyWeatherService: WeatherService {
    private let baseURL = "https://api.darksky.net/forecast"
    private let apiKey: String

    private lazy var urlSession: URLSession = {
        let internalURLSession = URLSession(configuration: .default)
        return internalURLSession
    }()

    private lazy var baseURLWithAPIKey: String = {
        return baseURL + "/" + apiKey
    }()

    init(with apiKey: String) {
        self.apiKey = apiKey
    }

    func getForecastFor(latitude: Double, longitude: Double, completion: @escaping (Result<Forecast, Error>) -> Void) {
        let fullURLString = baseURLWithAPIKey + "/\(latitude),\(longitude)"
        guard var url = URL(string: fullURLString) else {
            completion(.failure(WeatherError.noData))
            return
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "units", value: "si")]

        if let modifiedURL = urlComponents?.url {
            url = modifiedURL
        }

        let request = URLRequest(url: url)

        let task = urlSession.dataTask(with: request) { (data, responce, error) in
            guard let data = data, error == nil else {
                completion(.failure(WeatherError.noData))
                return
            }

            let encodedData: Forecast
            do {
                let decoder = JSONDecoder()
                encodedData = try decoder.decode(Forecast.self, from: data)
            } catch {
                completion(.failure(error))
                return
            }

            completion(.success(encodedData))
        }
        task.resume()
    }
}

enum WeatherError: Error {
    case noData
}
