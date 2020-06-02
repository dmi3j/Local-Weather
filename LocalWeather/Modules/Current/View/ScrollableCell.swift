//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class ScrollableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: CurrentViewModel? {
        didSet {
//            viewModel?.viewDelegate = self
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ScrollableCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.itemsCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCell", for: indexPath as IndexPath) as! DataCell

        if let data = viewModel?.item(at: indexPath.row) {
            cell.data = data
        }

        return cell
    }
}
