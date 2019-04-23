//
//  CalendarTableViewCell.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    private enum TitleText: String {
        case user = "您預定的時間"
        case firebase = "此時間已被預訂囉"
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookingView: UIView! {
        didSet {
            bookingView.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var timeLabel: UILabel!

    @IBAction func bookingAction() {

 //       bookingView.backgroundColor = .green
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
    
    func setupCell(hour: Int) {

        setupText(hour: hour)
 //       bookingView.backgroundColor = .white
        bookingButton.isHidden = false
        bookingView.isHidden = true
        bookingView.backgroundColor = UIColor.white
        bookingButton.setImage(UIImage.asset(.add), for: .normal)
    }
    
    func userBookingSetup(hour: Int) {
        
        setupText(hour: hour)
        bookingButton.isHidden = false
        bookingView.isHidden = false
        bookingButton.setImage(UIImage.asset(.substract), for: .normal)
        bookingView.backgroundColor = UIColor.playBandColorEnd
        titleLabel.text = TitleText.user.rawValue
    }
    
    func fireBaseBookingSetup(hour: Int) {
        
        setupText(hour: hour)
        bookingButton.isHidden = true
        bookingView.isHidden = false
        bookingView.backgroundColor = UIColor.playBandColorPinkRed
        titleLabel.text = TitleText.firebase.rawValue
    }
    private func setupText(hour: Int) {
        
        self.timeLabel.text = String(hour) + ":00"
        bookingButton.tag = hour
    }
}
