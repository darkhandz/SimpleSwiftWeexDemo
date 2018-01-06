//
//  WXImageLoader.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/5.
//  Copyright © 2018年 delite. All rights reserved.
//

import UIKit
import WeexSDK
import SDWebImage

class WXImageLoader: NSObject, WXImgLoaderProtocol {
    
    func downloadImage(withURL url: String!, imageFrame: CGRect, userInfo options: [AnyHashable : Any]! = [:], completed completedBlock: ((UIImage?, Error?, Bool) -> Void)!) -> WXImageOperationProtocol! {
        Log("weex加载图片:", url)
        guard let url = url else {
            Log("weex传入的图片URL无效")
            return nil
        }
        let fullURL = url.hasPrefix("//")  ?  ("http:" + url)  :  url
        guard let validURL = URL(string: fullURL) else {
            Log("weex图片URL无效：", fullURL)
            return nil
        }
        
        let downloadTask = SDWebImageManager.shared().downloadImage(with: validURL, options: .retryFailed, progress: nil) { (image, error, cacheType, finished, imageURL) in
            completedBlock?(image, error, finished)
        }
        return downloadTask as? WXImageOperationProtocol
    }
    
}
