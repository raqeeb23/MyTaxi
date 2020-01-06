//
//  VerificationCodeViewController.swift
//  My Taxi
//
//  Created by mac mini on 03/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class VerificationCodeViewController: UIViewController {
    
    @IBOutlet weak var txtCodeField1: UITextField!
    @IBOutlet weak var txtCodeField2: UITextField!
    @IBOutlet weak var txtCodeField3: UITextField!
    @IBOutlet weak var txtCodeField4: UITextField!
    @IBOutlet weak var txtCodeField5: UITextField!
    @IBOutlet weak var txtCodeField6: UITextField!
    
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.show()
        txtCodeField1.addTarget(self, action: #selector(self.textfieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtCodeField2.addTarget(self, action: #selector(self.textfieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtCodeField3.addTarget(self, action: #selector(self.textfieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtCodeField4.addTarget(self, action: #selector(self.textfieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtCodeField5.addTarget(self, action: #selector(self.textfieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtCodeField6.addTarget(self, action: #selector(self.textfieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        
        
        
        //print(UserDefaults.standard.string(forKey: "smsVerificationId"))
        // Do any additional setup after loading the view.
        
        
        //keyboard listners
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtCodeField1.becomeFirstResponder()
    }
    
    
    @objc func textfieldDidChange(textField: UITextField) {
        let text = textField.text
        
        if text!.count > 0 {
            switch textField{
            case txtCodeField1:
                txtCodeField2.becomeFirstResponder()
            case txtCodeField2:
                txtCodeField3.becomeFirstResponder()
            case txtCodeField3:
                txtCodeField4.becomeFirstResponder()
            case txtCodeField4:
                txtCodeField5.becomeFirstResponder()
            case txtCodeField5:
                txtCodeField6.becomeFirstResponder()
            default:
                resignFirstResponder()
            }
        }
            
        else if text!.count == 0 {
            switch textField {
            case txtCodeField1:
                txtCodeField1.becomeFirstResponder()
            case txtCodeField2:
                txtCodeField1.becomeFirstResponder()
            case txtCodeField3:
                txtCodeField2.becomeFirstResponder()
            case txtCodeField4:
                txtCodeField3.becomeFirstResponder()
            case txtCodeField5:
                txtCodeField4.becomeFirstResponder()
            case txtCodeField6:
                txtCodeField5.becomeFirstResponder()
                
            default:
                resignFirstResponder()
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        var fullCode: String?
        if txtCodeField1.text == nil{
            
        }else{
        if let dgOne = txtCodeField1.text,
            let dgTwo = txtCodeField2.text,
            let dgThree = txtCodeField3.text,
            let dgFour = txtCodeField4.text,
            let dgFive = txtCodeField5.text,
            let dgSix = txtCodeField6.text{
            
            let fullCode = "\(dgOne)\(dgTwo)\(dgThree)\(dgFour)\(dgFive)\(dgSix)"
            
            guard let verificationKey = UserDefaults.standard.string(forKey: "smsVerificationId") else { return }
            
            
            print(verificationKey)
            
            let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationKey,
            verificationCode: fullCode )
            
            showLoader()
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
              if let error = error {
                print(error.localizedDescription)
                self.hideLoader()
                return
              }
                self.hideLoader()
                if authResult != nil {
                    let vc = self.storyboard?.instantiateViewController(identifier: "PersonalInfoViewController") as! PersonalInfoViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
              }
            
              }
        }
   
    }
    
    
    
    //MARK: Keyboard custom methods
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
        btnBottomConstraint.constant = keyboardShowing ? keyboardHeight + 20 : 50
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
        })
    }
    
    
    func showLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
        SVProgressHUD.dismiss()
        }
    }
    
    
}


