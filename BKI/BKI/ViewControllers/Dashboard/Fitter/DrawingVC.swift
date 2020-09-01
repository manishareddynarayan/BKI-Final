//
//  DrawingVC.swift
//  BKI
//
//  Created by srachha on 21/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

enum WEBURLState
{
    case pdfURL
    case ISOURL
}

class DrawingVC: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    var urltype = WEBURLState.pdfURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
}
//MARK:Private  Methods
extension DrawingVC
{
    fileprivate func updateWebView()
    {
        var urlStr = "https://retail.onlinesbi.com/sbi/downloads/form15-g.pdf"
        switch urltype {
        case .pdfURL:
            urlStr = (self.spool != nil ? ((self.spool?.pdfUrl != nil) ? self.spool?.pdfUrl : urlStr) : ((self.hanger?.drawingUrl != nil) ? self.hanger?.drawingUrl : urlStr))!
            break
        case .ISOURL:
            urlStr = ((self.spool?.isoDrawingURL != nil) ? self.spool?.isoDrawingURL : urlStr)!
            break
        }
        let request = URLRequest.init(url: URL.init(string: urlStr)!)
        self.webView.loadRequest(request)
    }
}
//MARK:Webview Delegate Methods
extension DrawingVC:UIWebViewDelegate
{
    func webViewDidStartLoad(_ webView: UIWebView) {
        MBProgressHUD.showHud(view: webView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hideHud(view: webView)
    }
}
