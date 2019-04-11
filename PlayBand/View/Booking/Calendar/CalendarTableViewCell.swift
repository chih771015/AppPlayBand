//
//  CalendarTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var bookingView: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBAction func bookingAction() {

        bookingView.backgroundColor = .green
    }

    @IBOutlet weak var bookingButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func createGradientLayer() {

        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = self.bounds

        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]

        self.layer.addSublayer(gradientLayer)
    }

    func setupCell(hour: Int) {

        timeLabel.text = String(hour) + ":00"
        bookingButton.tag = hour
        bookingView.backgroundColor = .white
    }

    func resetCell() {

        bookingView.backgroundColor = .white
    }

}
