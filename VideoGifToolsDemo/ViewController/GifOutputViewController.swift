//
//  GifOutputViewController.swift
//  VideoGifToolsDemo
//
//  Created by sischen on 2019/1/13.
//  Copyright © 2019 CC. All rights reserved.
//

import UIKit
import WebKit

class GifOutputViewController: UIViewController {
    
    //MARK: ------------------------ Variables & Constants
    var targetURL: URL?
    
    
    //MARK: ------------------------ Lazy Subviews
    fileprivate lazy var closeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 40, y: 20, width: 40, height: 40)
        button.backgroundColor = UIColor.clear
        button.setTitle("❌", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var webView: WKWebView = {
        let view = WKWebView(frame: UIScreen.main.bounds)
        return view
    }()
    
    //MARK: ------------------------ LifeCycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.initData()
    }
    
    fileprivate func initUI() -> () {
        view.addSubview(webView)
        view.addSubview(closeBtn)
    }
    
    fileprivate func initData() -> () {
        if let targetURL = targetURL {
            let request = URLRequest(url: targetURL)
            webView.load(request)
        }
    }
    
    //MARK: ------------------------ Event Handle
    @objc fileprivate func onDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: ------------------------ Private
    
}
