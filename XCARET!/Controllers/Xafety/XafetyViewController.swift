//
//  XafetyViewController.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 02/06/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit
import WebKit

class XafetyViewController: UIViewController {
//
//    @IBOutlet weak var xafetyWebView: WKWebView!
//
    @IBOutlet weak var closeButton: UIImageView!
    @IBOutlet weak var contentCloseButton: UIView!
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        self.contentCloseButton.addGestureRecognizer(tapRecognizer)
        self.closeButton.tintColor = UIColor.black
        
        let stringRequest = Constants.LANG.current == "es" ? "https://www.xcaret.com/es/protocolos-de-sanidad-grupo-xcaret/" : "https://www.xcaret.com/en/sanity-protocols-grupo-xcaret/"
        
        let webViewPref = WKPreferences()
        webViewPref.javaScriptEnabled = true
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.preferences = webViewPref
        
        webView = WKWebView(frame: CGRect(x: 0, y: UIDevice().setTopWKWebView(), width: self.view.frame.width, height: self.view.frame.height), configuration: webViewConfig)
        webView.backgroundColor = .black
        view.addSubview(webView)
        
        load(url: stringRequest)
        
    }
    
    func load(url: String){
        webView.load(URLRequest(url: URL(string: url)!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        webView.backgroundColor = .black
        }
    
    @objc public func close() {
       dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
