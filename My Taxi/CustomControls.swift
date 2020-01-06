//
//  myTaxiOTPTextfield.swift
//  My Taxi
//
//  Created by mac mini on 04/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit

class myTaxiOTPTextfield: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.orange.cgColor
    }

}


class myTaxiBasicTextfield: UITextField{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "" ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.orange.cgColor
    }
}


class MyTaxiHeaderLabels: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textColor = UIColor.orange
        
    }


}

