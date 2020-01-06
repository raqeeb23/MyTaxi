//
//  PersonalInfoViewController.swift
//  My Taxi
//
//  Created by mac mini on 04/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController {

    @IBOutlet weak var txtFirstName: myTaxiBasicTextfield!
    @IBOutlet weak var txtLastName: myTaxiBasicTextfield!
    
    @IBOutlet weak var txtEmail: myTaxiBasicTextfield!
    
    @IBOutlet weak var txtDateOfBirth: myTaxiBasicTextfield!
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        
        // Do any additional setup after loading the view.
        createDatePicker()
    }
    
    
    func createDatePicker() {
        
        datePicker.datePickerMode = .date
        datePicker.tintColor = UIColor.orange
        txtDateOfBirth.inputView = datePicker
        
        
        
        // creating my toolbar for txtbirthdate picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
    
        
        toolbar.setItems([doneButton], animated: true)
        
        txtDateOfBirth.inputAccessoryView = toolbar
    }
 
    @objc func donePressed() {
        print(datePicker.date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        print(dateFormatter.string(from: datePicker.date))
        txtDateOfBirth.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "AddVehicleViewController") as! AddVehicleViewController
        navigationController?.pushViewController(vc , animated: true)
        
    }
}
   

extension PersonalInfoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        switch textField {
        case txtFirstName :
            txtLastName.becomeFirstResponder()
        case txtLastName:
            txtEmail.becomeFirstResponder()
        case txtEmail:
            textField.resignFirstResponder()
        
        default:
            resignFirstResponder()
        }
        
        
        
        return true
    }
}
