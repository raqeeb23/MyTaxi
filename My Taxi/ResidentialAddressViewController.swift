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
    
    let stateArray = ["Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Lakshadweep",
    "Puducherry"]
    let cityArray = ["Ujjain", "Bhopal" , "Dewas" , "Indore" , "Maksi" ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtResidentialAddress.delegate = self
        txtZipCode.delegate = self
        
        itemPickerView.delegate = self
        itemPickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func OpenPickerView(_ sender: UIButton) {
        //Zubair: Rather than switching sender, you can assign the tag for each button from storyboard and then use sender.tag to switch. This way you won't have to create IBOutlets for all the buttons
        switch sender {
        case btnState:
            //Zubair: Inside any case you should only assign the value to your pickerType variable and set the picker title. The rest of the operations can be performed outside the switch case.
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
        //Zubair: Can't you switch using the value assigned to pickerType earlier?
        switch lblPickerTitle.text {
               
               case PickerTitleEnum.state.rawValue:
                txtState.text = stateArray[itemPickerView.selectedRow(inComponent: 0)]
               
               case PickerTitleEnum.city.rawValue:
                txtCity.text = cityArray[itemPickerView.selectedRow(inComponent: 0)]
                txtResidentialAddress.becomeFirstResponder()
               
               default:
                   break
               }
        
        constraintBottomPickerView.constant = -500
        UIView.animate(withDuration: 0.4, delay: 0 , options: .curveEaseOut , animations: {self.view.layoutIfNeeded()} , completion: nil)
        
    }
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "AddPhotoViewController") as! AddPhotoViewController
        navigationController?.pushViewController(vc , animated: true)
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
        case txtResidentialAddress:
            txtZipCode.becomeFirstResponder()
        case txtZipCode:
            textField.resignFirstResponder()
        default:
            resignFirstResponder()
        }
        return true
    }
}
