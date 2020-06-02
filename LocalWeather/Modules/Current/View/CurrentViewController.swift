//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class CurrentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

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
        viewModel?.requestLocationUpdate()
    }
}

extension CurrentViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2// 1 + (viewModel?.itemsCount ?? 0)
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

//        guard let data = viewModel?.item(at: indexPath.row - 1) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScrollableCell",
                                                       for: indexPath) as? ScrollableCell else {
                                                        return UITableViewCell()
        }
//        cell.data = data
        cell.viewModel = viewModel
        return cell
    }
}

extension CurrentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.frame.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        } else {
            return UITableView.automaticDimension
        }
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

    func show(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
                self.tableView.contentOffset = CGPoint(x: 0, y: 0)
            }
            let alertController = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
            let okButtonAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okButtonAction)
            self.present(alertController, animated: true)
        }
    }
}


