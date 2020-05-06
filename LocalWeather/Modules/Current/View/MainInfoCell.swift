//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class MainInfoCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var data: WeatherMainInfo? {
        didSet {
            guard let data = data else { return }
            
            summaryLabel.text = data.summary
            temperatureLabel.text = data.temperature
            
            if data.iconName.isEmpty == false, let image = UIImage(named: data.iconName) {
                iconImageView.image = image
            } else {
                iconImageView.image = #imageLiteral(resourceName: "unknown")
            }
        }
    }
}
