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
    @IBOutlet weak var viewItemPicker: UIView!
    
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

        
        
        switch sender.tag {
        case 1:
            pickerType = .state
            // this can be filled using api data
            lblPickerTitle.text = PickerTitleEnum.state.rawValue
            showHidePickerView(true)
        
        case 2:
            pickerType = .city
            // this is can be filled using api data
            lblPickerTitle.text = PickerTitleEnum.city.rawValue
            showHidePickerView(true)
        default:
            break
        }
    
    }

    
    @IBAction func canelButtonPressed(_ sender: UIButton) {
       showHidePickerView(false)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {

        switch pickerType {
        case .state:
                txtState.text = stateArray[itemPickerView.selectedRow(inComponent: 0)]
               
        case .city:
                txtCity.text = cityArray[itemPickerView.selectedRow(inComponent: 0)]
                txtResidentialAddress.becomeFirstResponder()
               
               default:
                   break
               }
        
        showHidePickerView(false)
        
    }
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "AddPhotoViewController") as! AddPhotoViewController
        navigationController?.pushViewController(vc , animated: true)
    }
    
    
    func showHidePickerView(_ show: Bool) {
         if show {
             constraintBottomPickerView.constant = 0
             itemPickerView.selectRow(0, inComponent: 0, animated: true)
             itemPickerView.reloadAllComponents()
             UIView.animate(withDuration: 0.5) {
                 self.view.layoutIfNeeded()
             }
         }
         else {
                 constraintBottomPickerView.constant = -viewItemPicker.frame.height
         UIView.animate(withDuration: 0.5) {
             self.view.layoutIfNeeded()
         }
       }
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
