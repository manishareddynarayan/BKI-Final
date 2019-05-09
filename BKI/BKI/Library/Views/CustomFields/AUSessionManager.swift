//
//  AUSessionManager.swift
//  AuthenticationManager
//
//  Created by srachha on 01/08/17.
//  Copyright © 2017 srachha. All rights reserved.
//

import UIKit

class AUSessionManager: NSObject {

    static let shared = AUSessionManager()
    var requiredFields = [[String:AnyObject]]()
    
    func validateRequiredFields() -> [String:AnyObject]? {
        
        for (_,field) in self.requiredFields.enumerated() {
            
            var fieldDict = field
            let textField = fieldDict["Field"] as! UITextField
            
            if textField is AUSessionField {
               let currentTextField = textField as! AUSessionField
                
                if (currentTextField.text?.isEmpty)! && currentTextField.isRequired {
                    fieldDict["Error"] = "\(fieldDict["Key"] as! String) is required." as AnyObject
                    currentTextField.shakeTextField(numberOfShakes: 0, direction: 1, maxShakes: 6)
                    return fieldDict
                }
                
                if currentTextField.type == .Email  {
                    guard (self.validateEmail(email:currentTextField.text!))! else {
                        //Field Key error
                        fieldDict["Error"] = "Invalid E-mail format." as AnyObject
                        currentTextField.shakeTextField(numberOfShakes: 0, direction: 1, maxShakes: 6)
                        return fieldDict
                    }
                }
                else {
                    
                     if currentTextField.requiredCharacters > 0 && (currentTextField.text?.count)! < currentTextField.requiredCharacters && currentTextField.isRequired{
                        if currentTextField is AUFormattedField {
                            fieldDict["Error"] = "\(fieldDict["Key"] as! String) should contain \(currentTextField.requiredCharacters) digits." as AnyObject
                        }
                        else {
                            fieldDict["Error"] = "\(fieldDict["Key"] as! String) should contain \(currentTextField.requiredCharacters) characters." as AnyObject
                        }
                        currentTextField.shakeTextField(numberOfShakes: 0, direction: 1, maxShakes: 6)

                        return fieldDict
                    }
                    else if currentTextField.alphanumeric && !((currentTextField.text!.rangeOfCharacter(from:CharacterSet.letters) != nil) && (currentTextField.text!.rangeOfCharacter(from:CharacterSet.decimalDigits) != nil)) {
                        
                        fieldDict["Error"] = "\(fieldDict["Key"] as! String) must contain atleast one alphabet and one number." as AnyObject
                        currentTextField.shakeTextField(numberOfShakes: 0, direction: 1, maxShakes: 6)

                        return fieldDict
                    }
                }
                
            }
            else {
                let currentTextField = textField as! REFormattedNumberField
                if (currentTextField.text?.isEmpty)! && currentTextField.isRequired {
                    fieldDict["Error"] = "Please enter \(fieldDict["Key"] as! String)." as AnyObject
                    currentTextField.shakeTextField(numberOfShakes: 0, direction: 1, maxShakes: 6)

                    return fieldDict
                }
                else if currentTextField.format != nil
                {
                    if currentTextField.format.count != currentTextField.text?.count {
                        fieldDict["Error"] = "Please enter phone number in \(currentTextField.format!) format" as AnyObject
                        currentTextField.shakeTextField(numberOfShakes: 0, direction: 1, maxShakes: 6)

                        return fieldDict
                    }
                }
            }
        }
                return nil
    }

    
    func validateEmail(email:String) -> Bool?
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailPredicate = NSPredicate (format:"SELF MATCHES %@",emailRegex)
        
        return emailPredicate.evaluate(with: email)
    }
    
   
}


