//
//  EnterPhoneViewController.swift
//  My Taxi
//
//  Created by mac mini on 02/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit
import CountryPickerView
import FirebaseAuth
class EnterPhoneViewController: UIViewController {

    var countryPickerView: CountryPickerView?
    var smsVerificationKey: String?
    @IBOutlet weak var txtPhone: UITextField!

    @IBOutlet weak var btnContraintBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUi()
        //simpleBackButton()
        //BackButtonSetup()
        
        
        //keyboard listners
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        txtPhone.becomeFirstResponder()
    }
    
    func setupUi(){
        countryPickerView = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        countryPickerView!.font = UIFont.systemFont(ofSize: 13)
        countryPickerView!.flagSpacingInView = 4.0
        countryPickerView?.hostViewController = self
        countryPickerView?.bounds = CGRect(x: -5 , y: 0 , width: 120, height: 20)
        countryPickerView?.showCountryCodeInView = false
        countryPickerView?.textColor = .white
        countryPickerView?.flagSpacingInView = 10.0
        
        //countryPickerView?.layer.borderColor = UIColor.orange.cgColor
        //countryPickerView?.flagImageView.tintColor = .orange
        
        txtPhone.leftView = countryPickerView
        txtPhone.leftViewMode = .always
        txtPhone.backgroundColor = .clear
        
        txtPhone.textColor = .white
        txtPhone.layer.cornerRadius = 8.0
        txtPhone.layer.masksToBounds = true
        txtPhone.layer.borderWidth = 1.0
        txtPhone.layer.borderColor = UIColor.orange.cgColor
    }
    
    
    func BackButtonSetup() {
        let navBackButtonImage = #imageLiteral(resourceName: "keyboard-left-arrow-button")
        let backButton = UIBarButtonItem(image: navBackButtonImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func simpleBackButton () {
        let navigationButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = navigationButton
    }
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func gotoAccountVerification(_ sender: UIButton) {
        
        let fullNumber = "\(countryPickerView?.selectedCountry.phoneCode as! String)\(txtPhone.text!)"
        print(fullNumber)
        print(countryPickerView?.selectedCountry.phoneCode as! String)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(fullNumber, uiDelegate: nil) { (responseString , error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if responseString != nil {
                let smsVerificationId = responseString
                UserDefaults.standard.set(smsVerificationId, forKey: "smsVerificationId")
            }
        }
        
        
        let vc = storyboard?.instantiateViewController(identifier: "VerificationCodeViewController") as! VerificationCodeViewController
        //vc.verificationKey = smsVerificationKey
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func keyBoardWillChange(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                print(keyboardFrame)
                
                let keyBoardHeight = keyboardFrame.height
                let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
                
                  keyboardChanged(keyboardShowing: isKeyboardShowing, keyboardHeight: keyBoardHeight)
            }
        }
    }

    func keyboardChanged(keyboardShowing: Bool, keyboardHeight: CGFloat) {
        btnContraintBottom.constant = keyboardShowing ? keyboardHeight + 20 : 50
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
        })
    }
    
    

}

extension EnterPhoneViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

