//
//  TSWebViewController.swift
//  TSWeChat
//
//  Created by Hilen on 1/29/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit
import WebKit

private let kKVOContentSizekey: String = "contentSize"
private let kKVOTitlekey: String = "title"

class TSWebViewController: UIViewController {
    var webView: WKWebView?
    var URLString: String!
    var titleString: String?
    
    init(title: String? = nil, URLString: String) {
        super.init(nibName: nil, bundle: nil)
        if let theTitle = title {
            self.title = theTitle
            self.titleString = theTitle
        }
        self.URLString = URLString
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgba: "#2D3132")
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        guard let theWebView = self.webView else {
            return
        }

        theWebView.scrollView.bounces = true
        theWebView.scrollView.scrollEnabled = true
        theWebView.navigationDelegate = self
        
        let urlRequest = NSURLRequest(URL: NSURL(string: URLString!)!)
        theWebView.loadRequest(urlRequest)
        self.view.addSubview(theWebView)
        
        theWebView.addObserver(self, forKeyPath:kKVOContentSizekey, options:.New, context:nil)
        theWebView.addObserver(self, forKeyPath:kKVOTitlekey, options:.New, context:nil)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case kKVOContentSizekey?:
            if let height = change![NSKeyValueChangeNewKey] as? Float {
                self.webView?.scrollView.contentSize.height = CGFloat(height)
            }
            break
        case kKVOTitlekey?:
            if self.titleString != nil {
                return
            }
            if let title = change![NSKeyValueChangeNewKey] as? String {
                self.title = title
            }
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath:kKVOContentSizekey)
        self.webView?.removeObserver(self, forKeyPath:kKVOTitlekey)
    }
}

// MARK: - @delegate WKNavigationDelegate
extension TSWebViewController: WKNavigationDelegate {
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: ((WKNavigationResponsePolicy) -> Void)){
        print(navigationResponse.response.MIMEType)
        decisionHandler(.Allow)
    }
}



