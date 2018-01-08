//
//  UIImage+Extension.swift
//
//
//  Created by darkhandz on 2017/2/9.
//  Copyright © 2017年 DejingIT. All rights reserved.
//

import UIKit

extension UIImage{
    
    convenience init(uiColor color: UIColor){
        self.init(uiColor: color, size:CGSize(width: 1, height: 1))
    }
    
    convenience init (uiColor color: UIColor, size: CGSize){
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        self.init(cgImage: image.cgImage!)
    }
    
    
    /// 方形图片裁剪成圆形
    func toCircle() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: self.size))
        path.addClip()
        self.draw(at: .zero)
        let roundedRectImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedRectImg ?? UIImage()
    }
    
    
    /// 生成指定圆角的纯色图片
    ///
    /// - Parameters:
    ///   - bgColor: 背景颜色
    ///   - rect: 矩形
    ///   - corners: 哪些角
    ///   - radii: 圆角半径
    static func generateRoundRectImage(by bgColor: UIColor, rect: CGRect, corners: UIRectCorner, radii: CGSize) -> UIImage {
        let pureColorImage = UIImage(uiColor: bgColor, size: rect.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii).addClip()
        pureColorImage.draw(at: .zero)
        let roundedRectImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedRectImg ?? UIImage()
    }
    
    
    /// 如果图片太大，把图像等比例缩到最大边长为wOh的尺寸，再压缩到80%
    func scale(toMaxSize wOh:CGFloat) -> UIImage{
        var w = self.size.width
        var h = self.size.height
        if w < wOh && h < wOh { return self }
        let scale = wOh / max(w, h)
        w = w * scale
        h = h * scale
        
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext(), let data = UIImageJPEGRepresentation(newImage, 0.8) else {
            return UIImage()
        }
        let compressed = UIImage(data: data)
        UIGraphicsEndImageContext()
        return compressed ?? UIImage()
    } 
    
    /// 旋转一个角度
    func rotatedByDegrees(deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
