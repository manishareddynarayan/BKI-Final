
//
//  File.swift
//  DrillLogs
//
//  Created by Sandeep Kumar on 21/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit


enum DateStatus {

    case equal
    case past
    case future
}
extension UITextField
{

    func applyAndroidTheame() -> Void {
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width:1.0, height:1.0)
        self.layer.shadowOpacity = 1.0

    }
    
    func applyTextFieldPrimaryTheme() -> Void {
        self.layer.cornerRadius = 13.0
        self.backgroundColor = UIColor.getTextFieldPrimaryBackgroundColor()
    }
    
    func addDropDownButton() -> UIButton {
        let button = UIButton.init(frame: self.bounds)
        self.addSubview(button)
        button.setImage(UIImage.init(named: "DownArrow_small"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -button.frame.size.width + 30)
                return button
    }
    
    @IBInspectable var leftImage: String {
        get { return "" }
        set {
            self.leftViewMode = UITextFieldViewMode.always
            self.leftView = UIImageView.init(image: UIImage(named: newValue))
        }
    }
    
    @IBInspectable var rightImage: String {
        get { return "" }
        set {
            self.rightViewMode = UITextFieldViewMode.always
            self.rightView = UIImageView.init(image: UIImage(named: newValue))
        }
    }


    func addLeftView(imageName:String) -> Void {
        
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = UIImageView.init(image: UIImage(named: imageName))
    }
    
    func addRightView(imageName:String) -> Void {
        
        self.rightViewMode = UITextFieldViewMode.always
        let imageview = UIImageView.init(image: UIImage(named: imageName))
        imageview.contentMode = .center
        imageview.isUserInteractionEnabled = true
        self.rightView = imageview
    }

    
    func addPickerView(with delegate:Any) -> Void {
        let pickerView = UIPickerView()
        pickerView.delegate = delegate as? UIPickerViewDelegate
        pickerView.dataSource = delegate as? UIPickerViewDataSource
        self.inputView = pickerView
        self.initToolBar()
    }
    
    func addDatePicker() -> Void {
        
        let dobPicker = UIDatePicker();
        dobPicker.datePickerMode = .date
        //dobPicker .addTarget(self, action: #selector(self.dateSelected(sender:)), for: .valueChanged)
        self.inputView = dobPicker;
        self.initToolBar()
        self.text = self .getStringFromSelectedDate(date: dobPicker.date as NSDate)
    }
    
    
    func initToolBar() -> Void {
        
         let keyBoardToolBar = UIToolbar()

        keyBoardToolBar.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:44);
        keyBoardToolBar .barTintColor = Color.white
        let spaceBtn = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem (title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAction(sender:)))
        
        
        self.inputAccessoryView = keyBoardToolBar
        
        keyBoardToolBar .setItems([spaceBtn,doneBtn], animated: true);
    }
    
    
    
    
    
    func getStringFromSelectedDate(date:NSDate) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let dateStr = formatter.string(from: date as Date)
        
        return dateStr;
    }

    
    func getDateFromString() -> NSDate? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
       // formatter.timeZone = NSTimeZone
        let (_,date) = self.text!.getDateFromParseDate()

        //let date = formatter.dateFromString(self.text!)
       // debug_print(date)
        return date! as NSDate?
    }
    
    @objc func doneButtonAction(sender:AnyObject?) -> Void {
        self.resignFirstResponder()
    }
//    
    
    
    // returns the # of rows in each component..
    
   
}

extension UIButton
{
    func addUnderLine() -> Void {
        
        let attributes = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let attributedText = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        self.titleLabel?.attributedText = attributedText
    }
    
    
    func applyBorderColor() -> Void {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = self.currentTitleColor.cgColor
    }
    
    func applyBorder(with color:UIColor) -> Void {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
        
    }
    

}

extension UITextView
{
 
    func initToolBar() -> Void {
        
        let keyBoardToolBar = UIToolbar()
        
        keyBoardToolBar.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:44);
        keyBoardToolBar .barTintColor = UIColor.white
        let spaceBtn = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem (title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAction(sender:)))
        
        self.inputAccessoryView = keyBoardToolBar
        
        keyBoardToolBar .setItems([spaceBtn,doneBtn], animated: true);
    }
    
    
    @objc func doneButtonAction(sender:AnyObject?) -> Void  {
        self.resignFirstResponder()
    }

    

}


extension String
{
    
   /* static func getLocationAddressWithLatitudeAndLongitude(latitude:Double,longitude:Double,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void ) -> Void {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                failureBlock(error: error!)
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                //self = pm.thoroughfare!+pm.locality!+pm.administrativeArea!
                success(result: pm.addressDictionary!)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }*/
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func containsSpecialCharacters() ->Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            print("could not handle special characters")
            return true
        }
        return false
    }
    
    func getStringSize(font:UIFont) -> CGSize {
        let size: CGSize = self.size(withAttributes: [NSAttributedStringKey.font: font])
        return size
    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    
    func convertIntToString(num:Int?) -> String? {
        
        return num?.description
    }
    
    
    func  getDateFromParseDate() -> (DateFormatter,Date?) {
        let formatter = self.setDateFormatter()
        if let date = formatter.date(from: self){
            return (formatter,date)
        }
        else {
            return (formatter,nil)
        }
    }
  
    
    func setDateFormatter() -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        formatter.timeZone = TimeZone.init(identifier: "UTC")
        
        return formatter
    }
    
    
    
    func convertDateIntoDaysAgo() -> String? {
        // *** Create date ***
        let date = NSDate()
        // *** create calendar object ***
        let calendar = NSCalendar.current
        // *** Get components using current Local & Timezone ***
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date)
        let (_,sourcDate) = self.getDateFromParseDate()
        let sourceDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: sourcDate!)

        var timestamp = ""
        let formatSourceDate = DateFormatter()
        formatSourceDate.amSymbol = "AM"
        formatSourceDate.pmSymbol = "PM"
        //same day - time in h:mm am/pm
        if components.day == sourceDateComponents.day {
            formatSourceDate.dateFormat = "h:mm a"
            timestamp = "\(formatSourceDate.string(from: NSDate() as Date))"
            return timestamp
        }
        else if components.day! - sourceDateComponents.day! == 1 {
            //yesterday
            timestamp = NSLocalizedString("Yesterday", comment: "")
            return timestamp
        }
        
        if components.year == sourceDateComponents.year {
            //september 29, 5:56 pm
            formatSourceDate.dateFormat = "MMMM d"
            timestamp = "\(self.getStringFromParseFullDate(formate: "dd-MMM-yyyy hh:mm a")!)"
            return timestamp
        }
        
        return nil
    }
    
    func getStringFromParseFullDate(formate:String) -> String? {
        let (df,d) = self.getDateFromParseDate()
        let timeZoneSeconds = NSTimeZone.system.secondsFromGMT(for: d!)
        let dateInLocalTimezone = d?.addingTimeInterval(Double(timeZoneSeconds))
        
        df.dateFormat = formate
        
        return df .string(from: dateInLocalTimezone! as Date)
    }
    
    //MARK:Converting Local Date from one formate to another formate
    
       func getFormattedDateString(formate:String, sourceformate:String) -> (String,Date)  {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = sourceformate
        let date = formatter.date(from: self)
        formatter.dateFormat = formate
        let str = formatter.string(from: date!)
        return (str,date!)
    }
    
    
    func getUTCDate(formate:String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formate
        //formatter.timeZone = TimeZone.init(identifier: "UTC")
        formatter.timeZone = NSTimeZone.local
        let date = formatter.date(from: self)
        return date!
    }
    func validateEmail() -> Bool? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailPredicate = NSPredicate (format:"SELF MATCHES %@",emailRegex)
        
        return emailPredicate.evaluate(with: self)
    }
    
    
    func validateCreditCardExpiryDate() -> Bool? {
        
        let emailRegex = "^((0[1-9])|(1[0-2]))\\/((2009)|(20[1-9][0-9]))$"
        let emailPredicate = NSPredicate (format:"SELF MATCHES %@",emailRegex)
        
        return emailPredicate.evaluate(with: self)
    }
    
     static func GetUUID() -> String {
        let theUUID: CFUUID = CFUUIDCreate(nil)
        let string: CFString = CFUUIDCreateString(nil, theUUID)
        return String(string)
    }
    
   /* func encodeStringWithUTF8() -> String
    {
      
        if UIDevice.current.versionLessThaniOS8() == true {
           return self
        }
        else
        {
            let urlSet = NSMutableCharacterSet()
            urlSet.formUnion(with: .urlFragmentAllowed)
            urlSet.formUnion(with: .urlHostAllowed)
            urlSet.formUnion(with: .urlPasswordAllowed)
            urlSet.formUnion(with: .urlQueryAllowed)
            urlSet.formUnion(with: .urlUserAllowed)

            return self.addingPercentEncoding(withAllowedCharacters: urlSet as CharacterSet)!
        }
    }*/
    
    
    func convertPhoneNumberToNumberString() -> String {
        let okayChars : Set<Character> =
            Set("0123456789+".characters)
        return String(self.characters.filter {okayChars.contains($0) })

    }
}

extension Date {
    
    func isBetween(startDate date1:Date, endDate date2: Date) -> Bool{
        
        //let isValid = date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
        let isValid = (date1 ... date2).contains(self)
        //let isValid1 = (min(date1, self) ... max(date1, self)).contains(Date())

        return isValid 
    }
    
    func getStrng(formate:String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formate
        let str = formatter.string(from: self)
        return str
    }
    
    func getStartOfTheDay() -> Date {
        let str = self.getStrng(formate: "dd-MMM-yyyy") + " 00:00:00"
        let startDate = str.getUTCDate(formate:"dd-MMM-yyyy HH:mm:ss")
        return startDate
    }
    
    func getEndOfTheDay() -> Date {
        let str = self.getStrng(formate: "dd-MMM-yyyy") + " 23:59:00"
        let endDate = str.getUTCDate(formate:"dd-MMM-yyyy HH:mm:ss")
        return endDate
    }
    
    func getOrdinalStringFromDate() -> String {
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: self)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM, yyyy"
        let newDate = dateFormate.string(from: self)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
    
    fileprivate struct Item {
        let multi: String
        let single: String
        let last: String
        let value: Int?
    }
    
    fileprivate var components: DateComponents {
        return Calendar.current.dateComponents(
            [.minute, .hour, .day, .weekOfYear, .month, .year, .second],
            from: self,
            to: Date()
        )
    }
    
    fileprivate var items: [Item] {
        return [
            Item(multi: "years ago", single: "1 year ago", last: "Last year", value: components.year),
            Item(multi: "months ago", single: "1 month ago", last: "Last month", value: components.month),
            Item(multi: "weeks ago", single: "1 week ago", last: "Last week", value: components.weekday),
            Item(multi: "days ago", single: "1 day ago", last: "Last day", value: components.day),
            Item(multi: "hours ago", single: "1 hour ago", last: "Last hour", value: components.hour),
            Item(multi: "mins ago", single: "1 min ago", last: "Last minute", value: components.minute)
        ]
    }
    
    public func timeAgo(numericDates: Bool = false) -> String {
        for item in items {
            switch (item.value, numericDates) {
            case let (.some(step), _) where step == 0:
                continue
            case let (.some(step), true) where step == 1:
                return item.last
            case let (.some(step), false) where step == 1:
                return item.single
            case let (.some(step), _):
                return String(step) + " " + item.multi
            default:
                continue
            }
        }
        return "Just now"
    }
    
    func getDay() -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "EEEE"
        let day = dateFormate.string(from: self)
        return day
    }
    
    func getDayAsNumber() -> Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let dateComponents = (calendar as NSCalendar?)?.components([.day, .month, .year, .timeZone,.weekday], from: self)
        let weekDay  = dateComponents?.weekday
        return weekDay!
    }
    
    func checkSelectedDateIsPastDate(referanceDate:Date) -> Bool {
        let days = self.differenceFrom(first: referanceDate)
        return days < 0 ? true : false
    }
    
    func differenceFrom(first:Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: first, to: self).day

        return days!
    }
    
    func differenceInMinutesFrom(first:Date) -> Int {

        let minutes = Calendar.current.dateComponents([.minute], from: self, to: first).minute
        return minutes!

    }
    
    
    func differenceInSecondsFrom(first:Date) -> Double {
        let seconds = Calendar.current.dateComponents([.second], from: self, to: first).second
        return Double(seconds!)
        
    }
    func differenceInHoursAndMinutesFrom(first:Date) -> (Int,Int) {
        let components = Calendar.current.dateComponents([.hour,.minute], from: self, to: first)
        let hr = components.hour!
        let min = components.minute!
        return (hr,min)
    }
    
    func getDateByAdding(days:Int) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: days, to: self)
        return date!
    }
    func isPreviousDay(from date:Date) -> DateStatus {
        let minutes = Calendar.current.dateComponents([.minute], from: date, to: self).minute
        if minutes! < 0 {
            return DateStatus.past
        }
        else if minutes! > 0 {
            return DateStatus.future
        }
        return DateStatus.equal
    }
    
    func startOfWeek(formate:String) -> String {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: date.addingTimeInterval(dslTimeOffset))
    }
    
    func endOfWeek(formate:String) -> String {
        let startOfWeekDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: startOfWeekDate)
        let date = Calendar.current.date(byAdding: .second, value: 604799, to:startOfWeekDate.addingTimeInterval(dslTimeOffset))!
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: date)
    }
    
    func startDayOfMonth(month:String,formate:String) -> String {
        
        return ""
    }
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        let startOfMonth = Calendar.current.date(from: components)
        return startOfMonth!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, second: -1), to: self.startOfMonth())!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    func startDayForDays(days:Int) -> Date {
//        var components = DateComponents()
//        components.day = days
        return Calendar.current.date(byAdding: DateComponents( day:days), to: startOfDay)!

//        return Calendar.current.date(byAdding: components, to: startOfDay)

    }
}

extension NSMutableAttributedString
{
    func addGrayColorAttribute(string:String) -> Void {
        let str = self.string as NSString
        let firstAttributes = UIColor.getGrayColorFontAttribute()
        self.addAttributes(firstAttributes, range: str.range(of: string))
    }
    
    func addSquashColorAttribute(string:String) -> Void {
        let str = self.string as NSString
        let firstAttributes = UIColor.getSquashColorFontAttribute()
        self.addAttributes(firstAttributes, range: str.range(of: string))
    }
    
    func addBlackColorAttribute(string:String) -> Void {
        let str = self.string as NSString
        let firstAttributes = UIColor.getBlackColorFontAttribute()
        self.addAttributes(firstAttributes, range: str.range(of: string))
    }
    
    func addStrikeLableCOlorAttribute(string:String) -> Void {
        let str = self.string as NSString
        let firstAttributes = UIColor.getStrikeColorFontAttribute()
        self.addAttributes(firstAttributes, range: str.range(of: string))
    }

}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UIColor
{
    class func pointColor() -> UIColor
    {
        return UIColor.init(red: 245.0/255.0, green: 166/255.0, blue: 35/255.0, alpha: 1)
    }
    class func pointColorWithAlpha() -> UIColor
    {
        return UIColor.init(red: 245.0/255.0, green: 166/255.0, blue: 35/255.0, alpha: 0.5)
    }
    class func borderColor() -> UIColor
    {
        return UIColor.init(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)
    }
    class func arcColor() -> UIColor
    {
        return UIColor.init(red: 1.0/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
    }
    class func categorySelectedColor() -> UIColor
    {
      return UIColor.init(red: 0.0/255.0, green: 171/255.0, blue: 190/255.0, alpha: 1)
    }
    class func categoryDeselectedColor() -> UIColor
    {
        return UIColor.init(red: 116.0/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)
    }
    class func buttonBlurColor() -> UIColor
    {
        return UIColor.init(red: 0.0/255.0, green: 116/255.0, blue: 176.0/255.0, alpha: 0.24)

    }
    class func titleColor() -> UIColor
    {
        return UIColor.init(red: 104/255.0, green: 104/255.0, blue: 104/255.0, alpha: 1)

    }
    class func lablePink() -> UIColor
    {
        return UIColor.init(red: 255/255.0, green: 80/255.0, blue: 101/255.0, alpha: 1)
        
    }
    class func seperatorWithAlpha() -> UIColor
    {
        return UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 0.6)
        
    }
    class func lightGray() -> UIColor
    {
        return UIColor.init(red: 154/255.0, green: 154/255.0, blue: 154/255.0, alpha: 1)
        
    }
    
   class func labelPlaceHolderColor() -> UIColor
    {
        
        return UIColor.gray
    }
    
    class func labelBlackColor() -> UIColor
    {
        
        return UIColor.black
    }

    
    class func appTheamColor() -> UIColor
    {
       return UIColor.init(red: 55.0/255.0, green: 84.0/255.0, blue: 141.0/255.0, alpha: 1.0)
    }
    
    class func getSquashColorFontAttribute() -> [NSAttributedStringKey:AnyObject]
    {
        return [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Color.squashColor()]
    }
    
    class func getGrayColorFontAttribute() -> [NSAttributedStringKey:AnyObject]
    {
        return [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.gray]
    }
    
    class func getStrikeColorFontAttribute() -> [NSAttributedStringKey:AnyObject]
    {
        return [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black]
    }

    
    class func getBlackColorFontAttribute() -> [NSAttributedStringKey:AnyObject]
    {
        return [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black]
    }
    
    class func getTextFieldPrimaryBackgroundColor( )-> UIColor
    {
        return UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 250/255.0, alpha: 1.0)
    }
    
}

extension NSMutableDictionary
{
    
    func getPointerObject(key:String, className:String, objectId:String) -> Void
    {
        self[key] = NSDictionary.init(objects:["Pointer",className,objectId], forKeys: ["__type" as NSCopying,"className" as NSCopying,"objectId" as NSCopying])
    }
    
    func getDateObject(key:String, date:String) -> Void
    {
        self[key] = NSDictionary.init(objects:["Date",date], forKeys: ["__type" as NSCopying,"iso" as NSCopying])
    }
}


extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
    
}

extension Array {
    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [[Element]] {
        var groups = [[Element]]()
        
        for element in self {
            let key = groupClosure(element)
            var active = Int()
            var isNewGroup = true
            var array = [Element]()
            
            for (index, group) in groups.enumerated() {
                let firstKey = groupClosure(group[0])
                if firstKey == key {
                    array = group
                    active = index
                    isNewGroup = false
                    break
                }
            }
            
            array.append(element)
            
            if isNewGroup {
                groups.append(array)
            } else {
                groups.remove(at: active)
                groups.insert(array, at: active)
            }
        }
        
        return groups
    }
    
    
}





