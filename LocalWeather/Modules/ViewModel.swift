//  Copyright © 2020 Dmitrijs Beloborodovs. All rights reserved.

import Foundation
import UIKit

public protocol CoordinatorDelegate: class {

}

public protocol ViewDelegate: class {
    func reloadData()
    func show(message: String)
}

public protocol ViewModel: class {

}
