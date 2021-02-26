//
//  MemeTextDelegate.swift
//  MemeMe 1.0
//
//  Created by Myron Govender on 2021/02/26.
//

import Foundation
import UIKit

class MemeTextDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //Clear textField containing default text
        if ((textField.text == defaultTopText) || (textField.text == defaultBottomText)){
            textField.text = ""
        }
    }
    
}
