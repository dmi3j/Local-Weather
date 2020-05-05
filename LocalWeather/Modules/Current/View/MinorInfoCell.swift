//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class MinorInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    var data: WeatherMinorInfo? {
        didSet {
            guard let data = data else { return }

            titleLabel.text = data.title
            valueLabel.text = data.value
        }
    }
}
