//
//  FormTextView.swift
//
//  Created by srachha on 12/12/17.
//  Copyright © 2017 srachha. All rights reserved.
//

import UIKit

class FormTextView: UITextView,TextInputDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var formDelegate : TextInputDelegate!

    func designToolBarWithNext(isNext : Bool, withPrev isPrev: Bool, delegate:TextInputDelegate) -> Void
    {
        self.formDelegate = delegate
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0,
                                                        width: UIScreen.main.bounds.width, height: 44))
        toolbar.tintColor = UIColor.white
        toolbar.backgroundColor = UIColor.white
        let buttonPrev = UIBarButtonItem.init(title: "Prev",
                                              style: .plain, target: self, action: #selector(prevbuttonClicked))
        if(!isPrev)
        {
            buttonPrev.isEnabled = isPrev
        }
        let buttonNext = UIBarButtonItem.init(title: "Next", style: .plain,
                                              target: self, action: #selector(nextbuttonClicked))
        if(!isNext)
        {
            buttonNext.isEnabled = isNext
        }
        let bbiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let buttonDone = UIBarButtonItem.init(title: "Done", style: .plain,
                                              target: self, action: #selector(donebuttonClicked))
        toolbar.items = [buttonPrev, buttonNext, bbiSpacer, buttonDone]
        self.inputAccessoryView = toolbar
        
    }
    
    @objc func donebuttonClicked()
    {
        self.resignFirstResponder()
        self.formDelegate.textViewDidPressedDoneButton!(self)
    }
    
    @objc func nextbuttonClicked()
    {
        self.formDelegate.textViewDidPressedNextButton!(self)
    }
    
    @objc func prevbuttonClicked()
    {
        self.formDelegate.textViewDidPressedPreviousButton!(self)
    }

}
