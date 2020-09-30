//
//  HttpWrapper.swift
//  UOVO
//
//  Created by Ravi Kiran on 12/04/17.
//  Copyright © 2017 Ravi Kiran. All rights reserved.
//

import UIKit
import  Bolts

//import SVProgressHUD
//import CRNotifications
struct Constant {
//    let kBaseURL = "http://192.168.0.110:3001/api/v1/"
//    let kBaseURL = "http://192.168.0.103:3001/api/v1/"
//    let kBaseURL = "http://192.168.0.203:3001/api/v1/"
    //Nishanth
//    let kBaseURL = "http://10.10.10.204:3001/api/v1/"
    //Harshitha
    //let kBaseURL = "http://192.168.0.6:3000/api/v1/"
     //let kBaseURL = "http://869c8d41.ngrok.io/"
    // Satging
    let kBaseURL = "http://54.196.109.252/api/v1/"
//    let kBaseURL = "https://6c9446ec41ea.ngrok.io/api/v1/"
    //Production
    //let kBaseURL = "https://api.bkimechanical.com/api/v1/"
//        let kBaseURL = "https://9894ef426022.ngrok.io/api/v1/"
}

func validateMetaData(meta:[String:Int?]) -> (Int,Bool)
{
    var isNextPageAvailable = false
    var pageIndex = 1
    if  let currentPage = meta["current_page"] as? Int
    {
        if let totalPages = meta["total_pages"] as? Int
        {
            if currentPage < totalPages
            {
                    pageIndex = currentPage + 1
                    isNextPageAvailable = true
            }
            else
            {
                isNextPageAvailable = false
                pageIndex = 1
            }
        }
    }
    return (pageIndex,isNextPageAvailable)
}


class HTTPWrapper: NSObject {
    
    var constant = Constant()
    var xAccessToken:String = "x-access-token"
    
    typealias SuccessHandler = ([String:AnyObject]) -> ()
    typealias FailureHandler = (NSError?) -> ()
    
    var token = String()
    
    // Can't init is singleton
    private override init() {
        
//        xAccessToken = "X-ACCESS-TOKEN" //self.constant.kBaseURL == "http://54.196.109.252/api/v1/" ? "X-ACCESS-TOKEN" : "x-access-token"
        //userType = UserType.Client
    }
    
    //MARK: Shared Instance
    
    static let sharedInstance: HTTPWrapper = HTTPWrapper()
    
    func performAPIRequest(_ urlSchema:String?, methodType:String, parameters:[String:AnyObject]?,successBlock:@escaping SuccessHandler,failBlock:@escaping FailureHandler) {

        guard urlSchema != nil else {
            
            let userInfo: [AnyHashable : Any] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Please provide a valid url", comment: "") ,
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Please provide a valid url", comment: "")
            ]
            
            let err = NSError(domain: "UOVOErrorDomain", code: 401, userInfo: userInfo as? [String : Any])
            DispatchQueue.main.async {
                self.dissmissHud(error: err)
            }
            failBlock(err)
            return
        }
        
        let urlString = constant.kBaseURL+urlSchema!.encodeStringWithUTF8()
        
        let url:NSURL = NSURL(string:urlString)!
        
        let request = NSMutableURLRequest(url: url as URL)
        if parameters != nil {
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: parameters!,
                options: []) {
                request.httpBody = theJSONData
            }
        }
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        //request.setValue(token, forHTTPHeaderField: "X-API-TOKEN")
        request.httpMethod = methodType
        let defs = BKIModel.initUserdefsWithSuitName()
        if defs?.object(forKey: "access-token") != nil {
            let token = (defs?.object(forKey: "access-token") as? String)!
            request.setValue(token, forHTTPHeaderField: xAccessToken)
        }        //phone: <user phone number>, role: "client" }, action: 'sign_in'
        self.sendRequest(request: request, successBlock: successBlock, failBlock: failBlock)
    }
    
    
    func uploadImage(urlSchema:String,parameters1:[Any],body:[Any],successBlock:@escaping SuccessHandler,failBlock:@escaping FailureHandler,uploadMultipleImages:Bool) {
        let urlString = constant.kBaseURL+urlSchema
        let url:NSURL = NSURL(string:urlString)!
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        let boundary: String = "---011000010111000001101001"
        let contentType: String = "multipart/form-data; boundary=\(boundary)"
        request.addValue(contentType, forHTTPHeaderField: "content-type")
//        let token = HTTPWrapper.sharedInstance.token
        let defs = BKIModel.initUserdefsWithSuitName()
        if defs?.object(forKey: "access-token") != nil {
            let token = (defs?.object(forKey: "access-token") as? String)!
            request.setValue(token, forHTTPHeaderField: xAccessToken)
        }        

        var postbody = Data()
        for i in 0..<body.count {
            var attributeName = parameters1[i] as! String
            if uploadMultipleImages {
                attributeName = parameters1[i] as! String + "[]"
            }
            postbody.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            if (body[i] is Data) {
                print("image data")
                _ = Date().timeIntervalSinceNow
                let videoData: Data? = body[i] as? Data
                    postbody.append("Content-Disposition: form-data;name=\"\(attributeName)\";filename=\"\(attributeName)\"\r\n".data(using: String.Encoding.utf8)!)
                    postbody.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
//                postbody.append("Content-Disposition: form-data;name=\"\(attachmentName)\";original_filename=\"\(attachmentName)\";filename=\"\(attributeName)\"\r\n".data(using: String.Encoding.utf8)!)
//                postbody.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
                
                postbody.append(videoData!)
            }
            else {
                postbody.append("Content-Disposition: form-data; name=\(parameters1[i])\r\n\r\n".data(using: String.Encoding.utf8)!)
                postbody.append("\(body[i])".data(using: String.Encoding.utf8)!)
            }
        }

        postbody.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        //finally setBody
        request.httpBody = postbody
        
        let postLength: String = "\(UInt(postbody.count))"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        
        self.sendRequest(request: request, successBlock: successBlock, failBlock: failBlock)
    }
    
    
    /*func performUploadMultipleImages(endPoint:String, images:NSMutableArray,successBlock:@escaping ([[String:AnyObject]]) -> (),failBlock:@escaping FailureHandler) {
        
     //   SVProgressHUD.show(withStatus: "Uploading", maskType: SVProgressHUDMaskType.gradient)
        var tasksArray = Array<BFTask<AnyObject>>()
        for (index, item) in images.enumerated() {
            ////print("Found \(item) at position \(index)")
            
            var newImage : UIImage! = (item as! PHPhotoAsset).fullScreenImage
//            newImage = newImage.fixOrientation()
//            //Reducing Images Size to half
//            let newSize = CGSize(width: newImage.size.width/2.0, height: newImage.size.height/2.0)
//
//            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//            newImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//
//            UIGraphicsEndImageContext()
            
            let imageName = String(index)+"png"
            
            var imageCaption = ""
            if (item as! PHPhotoAsset).caption.characters.count > 0{
                imageCaption.append("\"")
                imageCaption.append((item as! PHPhotoAsset).caption)
            }
            
            let attachmentTask = self.createTaskForAttachmentUpload(endPoint:endPoint,image: newImage, name:imageName,caption:imageCaption, successBlock: successBlock,failBlock: failBlock)
            tasksArray.append(attachmentTask)
        }
        
        guard tasksArray.count > 0 else {
            
            return
        }
        
        self.executeUploadAttachmnetQueue(tasks: tasksArray, successBlock: successBlock, failBlock: failBlock)
        
    }*/
    
    
    func createTaskForAttachmentUpload(endPoint:String,image:UIImage,name:String,caption:String?,successBlock:@escaping ([[String:AnyObject]]) -> (),failBlock:@escaping FailureHandler) -> BFTask<AnyObject> {
        
        let taskResource = BFTaskCompletionSource<AnyObject>()
        
        let imageData = image.pngData()!
        self.uploadImage(urlSchema: endPoint, parameters1: ["comment[image]"], body: [imageData], successBlock: { (responseData) in
            taskResource.set(result: responseData as AnyObject)

        }, failBlock: { (error) in
            taskResource.set(error: error!)
                        failBlock(error)

        }, uploadMultipleImages: false)
        return taskResource.task
    }
    
    
    func executeUploadAttachmnetQueue(tasks:[BFTask<AnyObject>],successBlock:@escaping ([[String:AnyObject]]) -> (),failBlock:@escaping FailureHandler)->Void{
        
        //let taskQueue = BFTask<AnyObject>.init(forCompletionOfAllTasks: tasks)
        
        let taskQueue = BFTask<AnyObject>.init(forCompletionOfAllTasksWithResults: tasks)
        taskQueue.continueWith { (task) -> Any? in
            
            if (taskQueue.isCompleted) {
                
                //success all tasks are completed
                
                if  (taskQueue.error == nil){
                    
                    // all tasks are completed successfully
                    DispatchQueue.main.async {
                       // SVProgressHUD.dismiss()
                        let completResult = taskQueue.result! as! [[String : AnyObject]]
                        successBlock(completResult)
                    }
                } else {
                    print("uploading image error+++\(String(describing: taskQueue.error?.localizedDescription))")
                    
                    failBlock(taskQueue.error! as NSError)
                    
                }
            }
            
            return taskQueue
        }
       /* taskQueue.continue({ (task) -> Any? in
            
            if (taskQueue.isCompleted) {
                
                //success all tasks are completed
                
                if  (taskQueue.error == nil){
                    
                    // all tasks are completed successfully
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        let completResult = taskQueue.result! as! [[String : AnyObject]]
                        successBlock(completResult)
                    }
                } else {
                    print("uploading image error+++\(String(describing: taskQueue.error?.localizedDescription))")
                    
                    failBlock(taskQueue.error! as NSError)
                    
                }
            }
            
            return taskQueue
        })*/
    }
    
        
    func sendRequest(request:NSMutableURLRequest, successBlock:@escaping SuccessHandler,failBlock:@escaping FailureHandler) -> Void {
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let data = data, error == nil else {
                //print("error")
                DispatchQueue.main.async {
                    self.dissmissHud(error: error)
                }
                failBlock(error! as NSError)
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            let headers = (response as! HTTPURLResponse).allHeaderFields
            print("headre \(headers)")
            let defs = BKIModel.initUserdefsWithSuitName()
            //print("StatusCoe\(statusCode)")
            if headers[self.xAccessToken] != nil {
                defs?.set( headers[self.xAccessToken] as? String, forKey: "access-token")
            }
            
            if statusCode >= 400 {
                if statusCode == 401{
                    self.showAlertView(message: "Authorisation expired. Please sign in again.")
                    return
                }
                 if statusCode == 403{
                    let error = self.getErrorResponse(errorDescription:"You don't have a permission to access this item." , statusCode: statusCode)
                    failBlock(error as NSError)

                    return
                }
                do{
                    let object =  try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]

                    var userInfoDict:[String:String]!
                    if object["error"] is [String:AnyObject] {
                        let dic = object["error"] as? [String:AnyObject]
                        if dic?["msg"] != nil {
                            userInfoDict = [ NSLocalizedDescriptionKey :  dic?["msg"]as! String]
                        }else {
                            let errorKeys:[String] = Array(dic!.keys)
                            
                            for (_,key) in errorKeys.enumerated() {
                                
                                let errorDict = dic?[key]
                                if errorDict is [String] {
                                    DispatchQueue.main.async {
                                        var  errorMessage = ""
                                        if key == "employee_code" || key == "email" {
                                            errorMessage = ((errorDict as? [String])?[0])!
                                        }
                                        else {
                                            errorMessage = key + " " + ((errorDict as? [String])?[0])!
                                        }
                                        let error = self.getErrorResponse(errorDescription:errorMessage , statusCode: statusCode)
                                        failBlock(error as NSError)
                                    }
                                }
                                else {
                                    DispatchQueue.main.async {
                                        let errorMessage = errorDict as? String
                                        let error = self.getErrorResponse(errorDescription:errorMessage! , statusCode: statusCode)
                                        failBlock(error as NSError)
                                    }
                                }
                            }
                        }
                    } else if object["errors"] is [AnyObject] {
                        DispatchQueue.main.async {
                            let errors = object["errors"] as? [String]
                            let errorMessage = errors?.first
                            let error = self.getErrorResponse(errorDescription:errorMessage! , statusCode: statusCode)
                            failBlock(error )
                        }
                    }
                    else {
                        if object["errors"] is String {
                            userInfoDict = [ NSLocalizedDescriptionKey : object["errors"] as! String]
                        }else if object["error"] is String{
                            userInfoDict = [ NSLocalizedDescriptionKey : object["error"] as! String]
                        }else if object["msg"] is String{
                            userInfoDict = [ NSLocalizedDescriptionKey : object["msg"] as! String]
                        }
                        else {
                            let errorDescription = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                            userInfoDict = [ NSLocalizedDescriptionKey : errorDescription]
                        }
                    }
                    let error = NSError(domain:"", code:statusCode, userInfo:userInfoDict)
                    DispatchQueue.main.async {
                        failBlock(error)
                    }
                }
                catch let jsonError{
                    failBlock(jsonError as NSError)
                }
            }
            else {
                self.parseSuccessResponse(responseData: data, successBlock: successBlock, failBlock: failBlock)
            }
        }
        task.resume()
    }
    
    
    func parseSuccessResponse(responseData:Data, successBlock:@escaping SuccessHandler,failBlock:@escaping FailureHandler) -> Void {
        do
        {
            let obj =  try JSONSerialization.jsonObject(with: responseData, options: [])
            var object = [String:AnyObject]()
            if obj is Array<AnyObject> {
                object["result"] = obj as AnyObject
            }
            else {
                object = obj as! [String:AnyObject]
            }
            
            //print("Response Object:\(object)")
            if object["error"] is String {
                let error = self.getErrorResponse(errorDescription: object["error"]as! String, statusCode: 404)
                DispatchQueue.main.async {
                    self.dissmissHud(error: error)
                }
                failBlock(error)
            }
            else {
                DispatchQueue.main.async {
                    self.dissmissHud(error:nil)
                }
                successBlock(object)
            }
        }
        catch let jsonError{
            DispatchQueue.main.async {
                self.dissmissHud(error: jsonError )
            }
            failBlock(jsonError as NSError)
        }
    }
    
    
    func getErrorResponse(errorDescription:String,statusCode:Int) -> NSError  {
        let userInfoDict = [ NSLocalizedDescriptionKey :  errorDescription]
        let error = NSError(domain:"", code:statusCode, userInfo:userInfoDict)
        return error
    }
    
    func dissmissHud(error:Error?) -> Void {
        DispatchQueue.main.async {
            //SVProgressHUD.dismiss()
            if error != nil {
               // CRNotifications.showNotification(type: .error, title: "Error!", message: (error?.localizedDescription)!, dismissDelay: 3)

            }
        }
    }
    
    func showAlertView(message: String){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let topVC = appDelegate.window?.rootViewController
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.redirectUserToSignInScreenOnAuthExpire()
            }))
            topVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    func redirectUserToSignInScreenOnAuthExpire(){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            BKIModel.resetUserDefaults()
            appDelegate.setupRootViewController()
        }
    }
}



