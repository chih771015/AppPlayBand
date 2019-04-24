//
//  ConfirmViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/9.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    private enum ButtonText: String {
        
        case booking = "送出預定訂單"
    }
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBAction func bookingAction() {
        
        guard let storeName = storeData?.name else { return }
        FirebaseManger.shared.bookingTimeEdit(
        storeName: storeName,
        bookingDatas: bookingTimeDatas,
        userMessage: "hi") { (result) in
            
            switch result {
                
            case .success(let message):
                UIAlertController.alertMessageAnimation(
                    title: message,
                    message: nil,
                    viewController: self, completionHanderInDismiss: { [weak self] in
                        self?.navigationController?.popToRootViewController(animated: true)
                })
            case .failure(let error):
                UIAlertController.alertMessageAnimation(
                    title: FirebaseEnum.fail.rawValue,
                    message: error.localizedDescription,
                    viewController: self, completionHanderInDismiss: nil)
                
            }
        }
    }
    @IBOutlet weak var countHourLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {

            setupTableView()
        }
    }
    var bookingDatasChange: (([BookingTime]) -> Void)?
    var bookingTimeDatas: [BookingTime] = [] {
        
        didSet {
            
            //tableView.reloadData()
            bookingDatasChange?(bookingTimeDatas)
        }
    }
    var storeData: StoreData?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
        setupButton()
    }

    private func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(identifier: String(describing: ConfirmTableViewCell.self), bundle: nil)
        tableView.lv_registerHeaderWithNib(
            identifier: String(
                describing: ConfirmTableViewSectionHeaderView.self
            ),
            bundle: nil
        )

         guard let headerView = UINib(
            nibName: String(describing: ConfirmTableViewHeaderView.self),
            bundle: nil
            ).instantiate(withOwner: nil,
                          options: nil)[0] as? ConfirmTableViewHeaderView
            else { return }
        
        tableView.layoutIfNeeded()
        tableView.tableHeaderView = headerView
        
    }
    
    private func setupButton() {
        
        button.setTitle(ButtonText.booking.rawValue, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setupButtonModelPlayBand()
    }
}

extension ConfirmViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(
                describing: ConfirmTableViewSectionHeaderView.self)
            ) as? ConfirmTableViewSectionHeaderView else { return UIView()}
        sectionHeader.dateLabel.text = "\(bookingTimeDatas[section].date.year)年 \(bookingTimeDatas[section].date.month)月\(bookingTimeDatas[section].date.day)日"
        sectionHeader.timeLabel.text = "總共\(bookingTimeDatas[section].hour.count)小時"
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookingTimeDatas[section].hour.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ConfirmTableViewCell.self),
            for: indexPath) as? ConfirmTableViewCell else {

                return UITableViewCell()
            }
        let text = "\(bookingTimeDatas[indexPath.section].hour[indexPath.row]):00"
        cell.setupCell(text: text)
        //cell.titleLabel.text = "\(bookingTimeDatas[indexPath.section].hour[indexPath.row]):00"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return bookingTimeDatas.count
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if bookingTimeDatas[indexPath.section].hour.count == 1 {
                
                bookingTimeDatas.remove(at: indexPath.section)
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                tableView.deleteSections(indexSet, with: .automatic)
                
            } else {
                
                bookingTimeDatas[indexPath.section].hour.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
}
