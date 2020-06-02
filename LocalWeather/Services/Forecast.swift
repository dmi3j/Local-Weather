//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

struct Forecast: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: Weather
    let hourly: Hourly
}

struct Hourly: Codable {
    let data: [Weather]
}
