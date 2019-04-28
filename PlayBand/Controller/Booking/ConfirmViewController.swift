//
//  ConfirmViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/9.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    private enum Text: String {
        
        case booking = "送出預定訂單"
        case message = "沒有訊息"
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBAction func bookingAction() {
        
        guard let storeName = storeData?.name else { return }
        var message = String()
        if messageTextField.text?.isEmpty == true ||
            messageTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            
            message = Text.message.rawValue
        } else {
            
            message = messageTextField.text ?? Text.message.rawValue
        }
        
        FirebaseManger.shared.bookingTimeEdit(
        storeName: storeName,
        bookingDatas: bookingTimeDatas,
        userMessage: message) { [weak self] (result) in
            
            switch result {
                
            case .success(let message):
                
                self?.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: {
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                })
                
            case .failure(let error):
                
                self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription, completionHanderInDismiss: nil)
                
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
            
            bookingDatasChange?(bookingTimeDatas)
            setupConuterLabel()
        }
    }
    var storeData: StoreData? {
        didSet {
            
            setupTableHeaderView()
        }
    }

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
    }
    
    private func setupTableHeaderView() {
        
        guard let headerView = UINib(
            nibName: String(describing: ConfirmTableViewHeaderView.self),
            bundle: nil
            ).instantiate(withOwner: nil,
                          options: nil)[0] as? ConfirmTableViewHeaderView
            else { return }
        
        tableView.layoutIfNeeded()
        tableView.tableHeaderView = headerView
        guard let data = storeData else { return }
        headerView.setupHeadView(storePhoto: data.photourl, storeName: data.name)
    }
    
    private func setupButton() {
        
        button.setTitle(Text.booking.rawValue, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setupButtonModelPlayBand()
    }
    
    private func setupConuterLabel() {
        
        var hour = 0
        for bookingData in bookingTimeDatas {
            
            hour += bookingData.hoursCount()
        }
        let text = "總共\(hour)小時"
        countHourLabel.text = text
    }
}

extension ConfirmViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(
                describing: ConfirmTableViewSectionHeaderView.self)
            ) as? ConfirmTableViewSectionHeaderView else { return UIView()}
        sectionHeader.setupCell(date: bookingTimeDatas[section].date.dateString(),
                                time: bookingTimeDatas[section].hoursString())
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
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return bookingTimeDatas.count
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            if bookingTimeDatas[indexPath.section].hour.count == 1 {
                
                bookingTimeDatas.remove(at: indexPath.section)
                tableView.deleteSections(indexSet, with: .automatic)
            } else {
                
                bookingTimeDatas[indexPath.section].hour.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                guard let header = tableView.headerView(forSection: indexPath.section) as? ConfirmTableViewSectionHeaderView else {return}
                
                header.deleteRowSetup(time: bookingTimeDatas[indexPath.section].hoursString())
            
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 56
    }
}
