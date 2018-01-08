//
//  WXImagePickerModule.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/7.
//  Copyright © 2018年 delite. All rights reserved.
//


import UIKit
import WeexSDK


/// 图片最大边长
fileprivate let ImageMaxWidthHeight: CGFloat = 800

/// 图片选择器
fileprivate let picker : UIImagePickerController = {
    $0.allowsEditing = true //正方形裁切框
    $0.sourceType = .photoLibrary
    return $0
}(UIImagePickerController())

/// weex回调
fileprivate var mcallback: WXModuleCallback?



public extension WXImagePickerModule {
    
    /// 打开相机拍照图片
    ///
    /// - Parameters:
    ///   - userID: 要上传照片的用户ID
    ///   - callback: 回调图片base64给weex
    @objc func openCamera(_ userID: String, callback: WXModuleCallback? ) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            Log("相机暂时不可用")
            return
        }
        mcallback = callback
        picker.delegate = self
        picker.sourceType = .camera
        UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true)
    }
    
    
    /// 打开相册选择图片
    ///
    /// - Parameters:
    ///   - userID: 要上传照片的用户ID
    ///   - callback: 回调图片base64给weex
    @objc func openAlbum(_ userID: String, callback: WXModuleCallback? ) {
        mcallback = callback
        picker.delegate = self
        picker.sourceType = .photoLibrary
        UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true)
    }
    
}



// MARK: - UIImagePickerControllerDelegate
extension WXImagePickerModule: UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage] as! UIImage, nil, nil, nil)
        }
        // 缩放成最大限制
        var selectedImage = UIImage()
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            selectedImage = img.scale(toMaxSize: ImageMaxWidthHeight)
        } else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImage = img.scale(toMaxSize: ImageMaxWidthHeight)
        }
        // 有损压缩图片质量
        var data = Data()
        if let compressed = UIImageJPEGRepresentation(selectedImage, 0.80) {
            data = compressed
        } else if let compressed = UIImagePNGRepresentation(selectedImage) {
            data = compressed
        }
        // 转base64
        let base64 = data.base64EncodedString()
        Log("base64:\(base64)")
        // 回调给weex
        mcallback?(base64)
        picker.dismiss(animated: true)
    }
    
}

extension WXImagePickerModule: UINavigationControllerDelegate {
    
}
