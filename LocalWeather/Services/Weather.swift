//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

struct Weather: Codable {
    let time: Int
    let summary: String
    let icon: String
    let temperature: Double
    let pressure: Double
    let uvIndex: Int
}
