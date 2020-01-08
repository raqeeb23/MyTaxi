//
//  BankVerificationViewController.swift
//  My Taxi
//
//  Created by mac mini on 08/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit

class BankVerificationViewController: UIViewController {

    @IBOutlet weak var txtBankVerficationNo: myTaxiBasicTextfield!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtBankVerficationNo.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
    }
}


extension BankVerificationViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }
}
