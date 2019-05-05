//
//  SignUpViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    enum SignUpError: String {
        
        case account = "帳號不能為空"
        case password = "密碼不能為空"
        case passwordConfirm = "密碼輸入不一樣請重新確認"
        case name = "名字不能為空"
        case email = "信箱不能為空"
        case phone = "電話不能為空"
        case band = "樂團不能為空"
        case facebook = "沒粉絲團就給個人頁面吧"
    }
    
    private func errorAlert(message: String?) {
        
        self.addErrorAlertMessage(message: message)
    }
    
    @IBAction func signUpAction() {
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorAlert(message: SignUpError.account.rawValue)
            return
        }
        if password.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorAlert(message: SignUpError.password.rawValue)
            return
        }
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorAlert(message: SignUpError.name.rawValue)
            return
        }
        if phone.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorAlert(message: SignUpError.phone.rawValue)
            return
        }
        if band.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorAlert(message: SignUpError.band.rawValue)
            return
        }
        if facebook.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorAlert(message: SignUpError.facebook.rawValue)
            return
        }
        if password != passwordConfirm {
            errorAlert(message: SignUpError.passwordConfirm.rawValue)
            return
        }
        
        let account = self.email
        let password = self.password
        let user = UserData(
            name: name, phone: phone, band: band, email: email,
            facebook: facebook, status: UsersKey.Status.user.rawValue)
        
        PBProgressHUD.addLoadingView(at: view, animated: true)
        
        FirebaseManger.shared.signUpAccount(
            email: account,
            password: password,
            completionHandler: { [weak self] result, error in
                
                guard result != nil else {
                    guard error != nil else {
                        
                        return
                    }
                    PBProgressHUD.dismissLoadingView(animated: true)
                    self?.addErrorTypeAlertMessage(error: error)
                    return
                }
                
                self?.signIn(account: account, password: password, userData: user)
        })
    }
    
    private func signIn(account: String, password: String, userData: UserData) {
        
        FirebaseManger.shared.signInAccount(
            email: account,
            password: password,
            completionHandler: { [weak self] (result, error) in
                
                guard result != nil else {
                    PBProgressHUD.dismissLoadingView(animated: true)
                    self?.addErrorTypeAlertMessage(error: error)
                    return
                }
                FirebaseManger.shared.editProfileInfo(userData: userData)
                
                PBProgressHUD.dismissLoadingView(animated: true)
                self?.addSucessAlertMessage(title: "歡迎進入", message: nil, completionHanderInDismiss: {
                    
                    guard let rootVC = UIStoryboard.main.instantiateInitialViewController() else {return}
                    guard let appdelgate = UIApplication.shared.delegate as? AppDelegate else {return}
                    appdelgate.window?.rootViewController = rootVC
                    self?.presentedViewController?.dismiss(animated: false, completion: nil)
                    self?.dismiss(animated: false, completion: nil)
                })
        })
    }
    
    var dataSignUp: [ProfileContentCategory] = [
        .email, .password, .passwordConfirm, .name,
        .phone, .band, .facebook]
    var userData = [String(), String(), String(), String(), String(), String(), String()]
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            setupTableView()
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
    var account = String()
    var password = String()
    var passwordConfirm = String()
    var name = String()
    var email = String()
    var phone = String()
    var facebook = String()
    var band = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButton()
    }
    private func setupButton() {
        view.layoutIfNeeded()
        button.setupButtonModelPlayBand()
    }
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(identifier: String(describing: EditTableViewCell.self), bundle: nil)
        tableView.lv_registerCellWithNib(
            identifier: String(describing: EditSectionHeaderTableViewCell.self), bundle: nil)
    }
    
}
extension SignUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: EditSectionHeaderTableViewCell.self)) as? EditSectionHeaderTableViewCell else {
                    return UIView()
        }
        header.setupCell(title: "申請帳號")
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSignUp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dataSignUp[indexPath.row].cellForIndexPathInSignUp(
            indexPath, tableView: tableView, textFieldDelegate: self, text: userData[indexPath.row])
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let placeholder = textField.placeholder
        
        switch placeholder {
        case ProfileContentCategory.name.rawValue:
            self.name = textField.text ?? ""
            userData[3] = self.name
        case ProfileContentCategory.passwordConfirm.rawValue:
            self.passwordConfirm = textField.text ?? ""
            userData[2] = self.passwordConfirm
        case ProfileContentCategory.password.rawValue:
            self.password = textField.text ?? ""
            userData[1] = self.password
        case ProfileContentCategory.account.rawValue:
            self.account = textField.text ?? ""
        case ProfileContentCategory.phone.rawValue:
            self.phone = textField.text ?? ""
            userData[4] = self.phone
        case ProfileContentCategory.facebook.rawValue:
            self.facebook = textField.text ?? ""
            userData[6] = self.facebook
        case "信箱帳號":
            self.email = textField.text ?? ""
            userData[0] = self.email
        case ProfileContentCategory.band.rawValue:
            self.band = textField.text ?? ""
            userData[5] = self.band
        default:
            print("nothing")
        }
        
    }
}
