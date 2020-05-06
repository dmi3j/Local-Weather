//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import Foundation
import CoreLocation

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
    func requestLocationUpdate()
}

final class CurrentViewModelClass: NSObject, CurrentViewModel {

    private let weatherService: WeatherService
    private var latitude: Double = 0 // check Null Island weather, if not know where you are
    private var longitude: Double = 0 // check Null Island weather, if not know where you are
    private var forecast: Forecast?
    private var items = [WeatherMinorInfo]()
    private var isRequestInProgress = false
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        return locationManager
    }()

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

    func requestLocationUpdate() {
        guard CLLocationManager.locationServicesEnabled() else {
            prepareViewModel()
            viewDelegate?.show(message: "Location services disabled.")
            return
        }

        update(for: CLLocationManager.authorizationStatus())
    }
}

private extension CurrentViewModelClass {

    func getData() {
        guard isRequestInProgress == false else { return }
        isRequestInProgress = true
        weatherService.getForecastFor(latitude: latitude, longitude: longitude) { (result) in
            switch result {
            case .failure(let error):
                self.prepareViewModel()
                debugPrint(error)
                self.viewDelegate?.show(message: "Something went wrong. Try later.")
            case .success(let forecast):
                self.forecast = forecast
                self.prepareViewModel()
            }
            self.isRequestInProgress = false
        }
    }

    func getForecastFor(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude

        getData()
    }
    
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

    func update(for status: CLAuthorizationStatus) {
        prepareViewModel()

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            viewDelegate?.show(message: "Location not permitted. Enable location services in app settings.")
        case .restricted:
            viewDelegate?.show(message: "Location services disabled.")
        default:
            viewDelegate?.show(message: "Something went wrong. Try later.")
        }
    }
}

extension CurrentViewModelClass: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentPosition = locations.first else { return }
        getForecastFor(latitude: currentPosition.coordinate.latitude,
                       longitude: currentPosition.coordinate.longitude)
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        update(for: status)
    }
}
