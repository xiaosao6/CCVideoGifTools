//
//  VideoTestViewController.swift
//  VideoGifToolsDemo
//
//  Created by sischen on 2019/1/13.
//  Copyright © 2019 CC. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class VideoTestViewController: UIViewController {
    
    //MARK: ------------------------ Variables & Constants
    fileprivate var player: AVPlayer?
    
    fileprivate lazy var videoFileURL: URL = {
        let path = Bundle.main.path(forResource: "videoToMakeGif", ofType: "mp4")!
        let url = URL(fileURLWithPath: path)
        return url
    }()
    
    //MARK: ------------------------ Lazy Subviews
    lazy var closeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.setTitle("❌", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var exportButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("导出", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(onExport), for: .touchUpInside)
        return button
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var videoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var previewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var timeLineSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0
        slider.addTarget(self, action: #selector(onSliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    //MARK: ------------------------ LifeCycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.initData()
    }
    
    fileprivate func initUI() -> () {
        view.backgroundColor = UIColor.white
        
        view.addSubview(stateLabel)
        stateLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(60)
            $0.top.equalToSuperview().offset(65)
        }
        
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.centerY.equalTo(stateLabel)
            $0.left.equalToSuperview().offset(10)
        }
        
        view.addSubview(exportButton)
        exportButton.snp.makeConstraints {
            $0.centerY.equalTo(stateLabel)
            $0.right.equalToSuperview().inset(10)
        }
        
        let minsize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        view.addSubview(videoContainerView)
        videoContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stateLabel).offset(50)
            $0.size.equalTo(CGSize(width: minsize, height: minsize))
        }
        
        view.addSubview(previewContainerView)
        previewContainerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(5)
            $0.top.equalTo(videoContainerView.snp.bottom).offset(10)
            $0.height.equalTo(80)
        }
        
        view.addSubview(timeLineSlider)
        timeLineSlider.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(5)
            $0.top.equalTo(previewContainerView.snp.bottom)
        }
    }
    
    fileprivate func initData() -> () {
        player = AVPlayer(url: videoFileURL)
        
        let size = UIScreen.main.bounds.width
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.masksToBounds = true
        playerLayer.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        videoContainerView.layer.addSublayer(playerLayer)
        
        stateLabel.text = "生成预览图..."
        CCVideoImageTool.createPreviewsForVideo(fileURL: videoFileURL, previewCounts: 8) { (imgs, error) in
            if let imgs = imgs {
                self.stateLabel.text = "已生成预览"
                self.resetPreviews(imgs: imgs)
            } else {
                self.stateLabel.text = "预览错误:\(error?.localizedDescription ?? "")"
            }
        }
    }
    
    
    //MARK: ------------------------ Event Handle
    @objc fileprivate func onSliderValueChanged() {
        let asset = AVURLAsset(url: videoFileURL)
        let videoSeconds = Double(asset.duration.value) / Double(asset.duration.timescale)
        let percent = Double(timeLineSlider.value)
        player?.seek(to: CMTime(seconds: percent * videoSeconds, preferredTimescale: asset.duration.timescale))
    }
    
    @objc fileprivate func onExport() {
        let asset = AVURLAsset(url: videoFileURL)
        let videoSeconds = Float(asset.duration.value) / Float(asset.duration.timescale)
        let startSecond = TimeInterval(timeLineSlider.value * videoSeconds)
        stateLabel.text = "正在导出gif..."
        CCVideoImageTool.generateGIFfromVideoFileURL(videoFileURL, startTime: startSecond) { (outputFileUrl, error) in
            if let error = error {
                self.stateLabel.text = "错误:\(error.localizedDescription)"
            } else {
                self.stateLabel.text = "导出完成!"
                print("outputFileUrl：\(outputFileUrl?.absoluteString ?? "")")
                
                let rvc = GifOutputViewController()
                rvc.targetURL = outputFileUrl
                self.present(rvc, animated: true, completion: nil)
            }
        }
    }
    
    @objc fileprivate func onDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: ------------------------ Private
    fileprivate func resetPreviews(imgs: [UIImage]) {
        previewContainerView.subviews.forEach({
            $0.removeFromSuperview()
        })
        for i in 0..<imgs.count {
            let img = imgs[i]
            let imgv = UIImageView(image: img)
            let itemWidth = self.previewContainerView.bounds.width / CGFloat(imgs.count)
            let itemHeight = self.previewContainerView.bounds.height
            imgv.frame = CGRect(x: CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: itemHeight)
            self.previewContainerView.addSubview(imgv)
        }
    }
}
