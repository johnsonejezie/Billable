//
//  TotalBillableHourTableViewCell.swift
//  Billable
//
//  Created by Johnson Ejezie on 22/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import UIKit

class TotalBillableHourTableViewCell: UITableViewCell {

    @IBOutlet var totalHourLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    static var Nib: UINib {
        return UINib.init(nibName: identifier, bundle: Bundle.init(for: TotalBillableHourTableViewCell.self))
    }

    func configure(total: String) {
        totalHourLabel.text = total
    }
    
}
