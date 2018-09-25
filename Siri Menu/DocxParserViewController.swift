//
//  DocxParserViewController.swift
//  Siri Menu
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import UIKit
import WebKit

class DocxParserViewController: UIViewController {
    
    let webView = WKWebView(frame: .zero)
    
    let filePath: URL
    let completionHandler: (Menu) -> Void
    
    init(with filePath: URL, completionHandler: @escaping (Menu) -> Void) {
        self.filePath = filePath
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubviewAndConstrainToEqualSize(webView)
        webView.navigationDelegate = self
        webView.loadFileURL(filePath, allowingReadAccessTo: filePath)
    }
}


// MARK:  - WKNavigationDelegate

extension DocxParserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            webView.evaluateJavaScript("document.documentElement.innerText", completionHandler: { result, error in
                DispatchQueue.main.async {
                    self.completionHandler(Menu(from: result as! String))
                    self.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
    
}
