//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import UIKit
import CoreLocation

class CurrentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()

    var viewModel: CurrentViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Updating...")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateLocation()
    }
}

private extension CurrentViewController {

    @objc
    private func refreshWeatherData(_ sender: Any) {
        updateLocation()
    }

    func updateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension CurrentViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (viewModel?.itemsCount ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0, let mainData = viewModel?.mainWeatherInfo {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainInfoCell",
                                                           for: indexPath) as? MainInfoCell else {
                                                            return UITableViewCell()
            }
            cell.data = mainData
            return cell
        }

        guard let data = viewModel?.item(at: indexPath.row - 1) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MinorInfoCell",
                                                       for: indexPath) as? MinorInfoCell else {
                                                        return UITableViewCell()
        }
        cell.data = data
        return cell
    }
}

extension CurrentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.frame.size.height
        } else {
            return UITableView.automaticDimension
        }
    }
}
extension CurrentViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentPosition = locations.first else { return }
        viewModel?.getForecastFor(latitude: currentPosition.coordinate.latitude,
                                  longitude: currentPosition.coordinate.longitude)
        manager.stopUpdatingLocation()
    }
}

extension CurrentViewController: CurrentViewDelegate {

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}


