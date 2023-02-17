//
//  RunLogCell.swift
//  Treads
//
//  Created by Ben Gauger on 2/16/23.
//

import UIKit

class RunLogCell: UITableViewCell {
    
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(run: RunModel) {
        durationLabel.text = run.duration.formatTimeDurationToString()
        distanceLabel.text = "\(run.distance.metersToKilometers(places: 2))"
        paceLabel.text = run.pace.formatTimeDurationToString()
        dateLabel.text = run.date.getDateString()
    }

    
}
