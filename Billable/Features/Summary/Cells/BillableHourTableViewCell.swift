//
//  BillableHourTableViewCell.swift
//  Billable
//
//  Created by Johnson Ejezie on 22/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import UIKit

class BillableHourTableViewCell: UITableViewCell {

    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }
    
    static var Nib: UINib {
        return UINib.init(nibName: identifier, bundle: Bundle.init(for: BillableHourTableViewCell.self))
    }

    func configure(card: TimeCard) {
        hourLabel.text = "\(card.hour)"
        endLabel.text = card.endTimeAsString
        startLabel.text = card.startTimeAsString
        rateLabel.text = "\(card.rate)"
        dateLabel.text = card.dateAsString
    }
}
