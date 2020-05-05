//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import Foundation
import UIKit

protocol CurrentCoordinatorDelegate: class {

}

class CurrentCoordinator: Coordinator {
    weak var delegate: CurrentCoordinatorDelegate?

    private let window: UIWindow
    private var navigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            guard let viewController = UIStoryboard(name: "Current", bundle: nil)
                .instantiateViewController(withIdentifier: "CurrentViewController") as? CurrentViewController else {
                    return
            }
            let service = DarkSkyWeatherService(with: Configiration().apiKey)
            viewController.viewModel = CurrentViewModelClass(weatherService: service)

            self.navigationController = UINavigationController(rootViewController: viewController)
            self.navigationController.navigationBar.isHidden = true
            self.window.rootViewController = self.navigationController
            self.window.makeKeyAndVisible()
        }
    }
}
