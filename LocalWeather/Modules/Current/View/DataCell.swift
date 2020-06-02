//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class DataCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    var data: WeatherMainInfo? {
        didSet {
            guard let data = data else { return }

            titleLabel.text = "Temp"
            valueLabel.text = data.temperature
        }
    }
}
