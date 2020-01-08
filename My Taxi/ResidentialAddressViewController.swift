//
//  ResidentialAddressViewController.swift
//  My Taxi
//
//  Created by mac mini on 07/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit

enum PickerTitleEnum: String {
    case state  = "State"
    case city   = "City"
}

class ResidentialAddressViewController: UIViewController {

    @IBOutlet weak var txtState: myTaxiBasicTextfield!
    @IBOutlet weak var txtCity: myTaxiBasicTextfield!
    @IBOutlet weak var txtResidentialAddress: myTaxiBasicTextfield!
    @IBOutlet weak var itemPickerView: UIPickerView!
    @IBOutlet weak var txtZipCode: myTaxiBasicTextfield!
    
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    
    @IBOutlet weak var lblPickerTitle: UILabel!
    
    @IBOutlet weak var constraintBottomPickerView: NSLayoutConstraint!
    
    var pickerType: PickerType = .state
    
    let stateArray = ["MP"]
    let cityArray = ["Ujjain"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func OpenPickerView(_ sender: UIButton) {
        
        
        switch sender {
        case btnState:
            pickerType = .state
            // this can be filled using api data
            itemPickerView.reloadAllComponents()
            lblPickerTitle.text = PickerTitleEnum.state.rawValue
            constraintBottomPickerView.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
        
        case btnCity:
            pickerType = .city
            // this is can be filled using api data
            itemPickerView.reloadAllComponents()
            lblPickerTitle.text = PickerTitleEnum.city.rawValue
            constraintBottomPickerView.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
        default:
            break
        }
    
    }

    
    @IBAction func canelButtonPressed(_ sender: UIButton) {
        constraintBottomPickerView.constant = -500
        UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        switch lblPickerTitle.text {
               
               case PickerTitleEnum.state.rawValue:
                txtState.text = stateArray[itemPickerView.selectedRow(inComponent: 0)]
               
               case PickerTitleEnum.city.rawValue:
                txtCity.text = cityArray[itemPickerView.selectedRow(inComponent: 0)]
                txtResidentialAddress.becomeFirstResponder()
               
               default:
                   break
               }
    }
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "AddPhotoViewController") as! AddPhotoViewController
    }
}

extension ResidentialAddressViewController: UIPickerViewDelegate{
    
}

extension ResidentialAddressViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerType {
        case .state:
            return stateArray.count
        case .city:
            return cityArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        switch pickerType {
        case .state:
            title = stateArray[row]
            return title
        case .city:
            title = cityArray[row]
            return title
        default:
            return title
        }
    }
}

extension ResidentialAddressViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtResidentialAddress :
            txtZipCode.becomeFirstResponder()
        case txtZipCode:
            textField.resignFirstResponder()
        default:
            resignFirstResponder()
        }
        return true
    }
}
