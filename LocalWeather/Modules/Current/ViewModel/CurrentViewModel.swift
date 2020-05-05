//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

protocol CurrentViewModelCoordinatorDelegate: CoordinatorDelegate {

}

protocol CurrentViewDelegate: ViewDelegate {

}

protocol CurrentViewModel: ViewModel {
    var coordinatorDeletage: CurrentViewModelCoordinatorDelegate? { get set }
    var viewDelegate: CurrentViewDelegate? { get set }

    var mainWeatherInfo: WeatherMainInfo? { get }
    var itemsCount: Int { get }
    func item(at index: Int) -> WeatherMinorInfo?
    func getForecastFor(latitude: Double, longitude: Double)
}

final class CurrentViewModelClass: CurrentViewModel {

    private let weatherService: WeatherService
    private var latitude: Double = 0 // check Null Island weather, if not know where you are
    private var longitude: Double = 0 // check Null Island weather, if not know where you are
    private var forecast: Forecast?
    private var items = [WeatherMinorInfo]()

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }

    // MARK: - CurrentViewModel
    weak var coordinatorDeletage: CurrentViewModelCoordinatorDelegate?
    weak var viewDelegate: CurrentViewDelegate?

    var mainWeatherInfo: WeatherMainInfo?

    var itemsCount: Int {
        return items.count
    }

    func item(at index: Int) -> WeatherMinorInfo? {
        return items.indices.contains(index) ? items[index] : nil
    }

    func getData() {
        weatherService.getForecastFor(latitude: latitude, longitude: longitude) { (result) in
            switch result {
            case .failure(let error):
                self.viewDelegate?.show(message: error.localizedDescription)
            case .success(let forecast):
                self.forecast = forecast
                self.prepareViewModel()
            }
        }
    }

    func getForecastFor(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude

        getData()
    }
}

private extension CurrentViewModelClass {

    func prepareViewModel() {
        items = [WeatherMinorInfo]()

        guard let forecast = forecast else {
            mainWeatherInfo = WeatherMainInfo(title: "---", temperature: "---", summary: "---", iconName: "")
            viewDelegate?.reloadData()
            return
        }

        mainWeatherInfo = WeatherMainInfo(title: forecast.timezone,
                                          temperature: "\(Int(forecast.currently.temperature.rounded()))℃",
                                          summary: forecast.currently.summary,
                                          iconName: forecast.currently.icon)

        items.append(WeatherMinorInfo(title: "Pressure", value: "\(Int(forecast.currently.pressure.rounded())) hPa"))
        items.append(WeatherMinorInfo(title: "UV Index", value: "\(forecast.currently.uvIndex)"))
        viewDelegate?.reloadData()
    }
}
