//
//  DrawingVC.swift
//  BKI
//
//  Created by srachha on 21/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class DrawingVC: BaseViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var webView: UIWebView!
    //MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let urlStr = (self.spool?.pdfUrl != nil) ? self.spool?.pdfUrl : "https://retail.onlinesbi.com/sbi/downloads/form15-g.pdf"
        let request = URLRequest.init(url: URL.init(string: urlStr!)!)
        self.webView.loadRequest(request)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override var shouldAutorotate: Bool
    {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
       return UIInterfaceOrientationMask.landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation
    {
        return UIInterfaceOrientation.landscapeRight
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
//MARK:- Webview Delegate Methods
extension DrawingVC:UIWebViewDelegate
{
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        MBProgressHUD.showHud(view: webView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        MBProgressHUD.hideHud(view: webView)
    }
}
