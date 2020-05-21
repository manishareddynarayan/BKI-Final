//
//  AUSessionField.swift
//  AuthenticationManager
//
//  Created by srachha on 01/08/17.
//  Copyright © 2017 srachha. All rights reserved.
//

import UIKit

@objc protocol TextInputDelegate  {
    
    @objc optional func textFieldDidPressedNextButton(_ textField: AUSessionField)
    @objc optional func textFieldDidPressedPreviousButton(_ textField: AUSessionField)
    @objc optional func textFieldDidPressedDoneButton(_ textField: AUSessionField)
    @objc optional func textFieldDidSelected(_ textField: AUSessionField,object:[String:AnyObject])
    @objc optional func textFieldDidSelectedDate(_ textField: AUSessionField,date:Date)

    @objc optional func textViewDidPressedNextButton(_ textView: FormTextView)
    @objc optional func textViewDidPressedPreviousButton(_ textView: FormTextView)
    @objc optional func textViewDidPressedDoneButton(_ textView: FormTextView)

}

@IBDesignable
@objc  class AUSessionField: UITextField,UIPickerViewDelegate,UIPickerViewDataSource {

    enum FieldType:Int {
       
        case Default
        case Email
        case Password
    }

    var padding = UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 13)

    var pickerModel = [[String:AnyObject]]()
    var titleKey = ""
    weak var formDelegate : TextInputDelegate!
    var dateFormate = ""
    var type:FieldType = .Default
    var selectedDate:Date?
    
    @IBInspectable var fieldType:Int = 0 {
        didSet(index) {
            self.type = FieldType(rawValue: index) ?? .Default
        }
    }
    
    var minimumCharacters = 0
    
    @IBInspectable var requiredCharacters:Int = 0 {
        didSet {
            self.minimumCharacters = requiredCharacters
        }
    }
    var isrequired = false

    @IBInspectable var isRequired:Bool = false {
        didSet {
          self.isrequired = isRequired
        }
    }
    
    var alphanumeric = false
    
    
    @IBInspectable var isAlphanumeric:Bool = false{
        didSet {
            self.alphanumeric = isAlphanumeric
        }
    }
    
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setupFieldUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFieldUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFieldUI()
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
        // Drawing code
    }*/
 
    func setupFieldUI() -> Void {
        self.textColor = UIColor.greyishBrown
        self.font = UIFont.init(name: "Averta-Light", size: 14)
    }

    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    func getTextRect() -> CGRect {
        let rect = bounds.inset(by: padding)
        if self.rightViewMode == .always {
            return adjustTextRectWithRightView(bounds: rect)
        }
        else if self.leftViewMode == .always {
            return adjustTextRectWithLeftView(bounds: rect)
        }
        return rect

    }
    
    func adjustTextRectWithRightView(bounds:CGRect) -> CGRect {
        var rect = bounds
        rect.size.width  -= (self.rightView?.frame.width)! - padding.right
        return rect
    }
    
    func adjustTextRectWithLeftView(bounds:CGRect) -> CGRect {
        var rect = bounds
        rect.size.width  += (self.leftView?.frame.width)! + padding.left + 21
        return rect
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let originalValue = super.leftViewRect(forBounds: bounds)
        return originalValue.offsetBy(dx: 21, dy: 0)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let originalValue = super.rightViewRect(forBounds: bounds)
        return originalValue.offsetBy(dx: -10, dy: 0)
    }
    
    func addPickerViewAsInputView(data:[[String:AnyObject]],titleKey:String) -> Void
    {
        self.pickerModel = data
        self.titleKey = titleKey
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.inputView = pickerView
        let dict = self.pickerModel[0]
        self.text = dict["name"] as? String
        //self.formDelegate.textFieldDidSelected!(self, object: dict)
    }
    
    func addDatePickerAsInputView(with formate:String,mode:UIDatePicker.Mode, setCurrentDateAsMinimumDate:Bool) -> Void{
        let dobPicker = UIDatePicker();
        dobPicker.datePickerMode = mode

        dobPicker .addTarget(self, action: #selector(AUSessionField.dateSelected(sender:)), for: .valueChanged)

      
        self.inputView = dobPicker;
        self.dateFormate = formate
        self.text = dobPicker.date.getStrng(formate: self.dateFormate)
        selectedDate = dobPicker.date
        if setCurrentDateAsMinimumDate {
            dobPicker.minimumDate = selectedDate
        }
        
       // self.formDelegate.textFieldDidSelectedDate!(self, date: dobPicker.date)
    }
    
    @objc func dateSelected(sender:AnyObject?) -> Void
    {
        let dp = sender as! UIDatePicker
        self.text = dp.date.getStrng(formate: self.dateFormate)
        selectedDate = dp.date
        self.formDelegate.textFieldDidSelectedDate!(self, date: dp.date)
    }
    
    func designToolBarWithNext(isNext : Bool, withPrev isPrev: Bool, delegate:TextInputDelegate) -> Void
    {
        self.formDelegate = delegate
        
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0,
                                                        width: UIScreen.main.bounds.width, height: 44))
        toolbar.tintColor = UIColor.brickRed
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
        self.formDelegate.textFieldDidPressedDoneButton!(self)
    }
    
    @objc func nextbuttonClicked()
    {
        self.formDelegate.textFieldDidPressedNextButton!(self)
    }
    
     @objc func prevbuttonClicked()
    {
        self.formDelegate.textFieldDidPressedPreviousButton!(self)
    }
    
    
    
    public  func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        
    {
        return self.pickerModel.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let dict = self.pickerModel[row]
        self.text = dict["name"] as? String
        self.formDelegate.textFieldDidSelected!(self, object: dict)
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let dict = self.pickerModel[row]
        return dict["name"] as? String
    }
}

extension UITextField {
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            guard let currentAttributedPlaceholderColor = attributedPlaceholder?.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as? UIColor else { return UIColor.clear }
            return currentAttributedPlaceholderColor
        }
        set {
            guard let currentAttributedString = attributedPlaceholder else { return }
            let attributes = [NSAttributedString.Key.foregroundColor : newValue]
            
            attributedPlaceholder = NSAttributedString(string: currentAttributedString.string, attributes: attributes)
        }
    }
    
    func shakeTextField (numberOfShakes : Int, direction: CGFloat, maxShakes : Int) {
        let interval : TimeInterval = 0.03
        
        UIView.animate(withDuration: interval, animations: { () -> Void in
            self.transform = CGAffineTransform(translationX: 5 * direction, y: 0)
            
        }, completion: { (aBool :Bool) -> Void in
            
            if (numberOfShakes >= maxShakes) {
                self.transform = .identity
                //self.becomeFirstResponder()
                return
            }
            self.shakeTextField(numberOfShakes: numberOfShakes + 1, direction: direction * -1, maxShakes: maxShakes )
        })
    }
}
