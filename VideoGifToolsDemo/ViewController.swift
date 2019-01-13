//
//  ViewController.swift
//  VideoGifToolsDemo
//
//  Created by sischen on 2019/1/13.
//  Copyright © 2019 CC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var startButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("点我", for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(onStart), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.frame = CGRect(x: 0, y: 0, width: 90, height: 40)
        startButton.center = self.view.center
        self.view.addSubview(startButton)
    }

    @objc func onStart() {
        let vvc = VideoTestViewController()
        present(vvc, animated: true, completion: nil)
    }
}

