//
//  Log.swift
//
//  Created by darkhandz on 2017/02/08.
//  Copyright © 2017年 darkhandz. All rights reserved.
//
import Foundation
#if DEBUG_LOG
fileprivate let logFormatter: DateFormatter = {
    $0.dateFormat = "HH:mm:ss.SSS"
    return $0
}(DateFormatter())
    
#endif


/**
 用于调试时打印Log，需要在Build Setting-Other Swift Flag-Debug里添加 -D DEBUG_LOG 参数，
 Release时不打印任何Log。
 - parameter message:    需要打印的信息
 - parameter funcName:   Log所在函数名
 - parameter lineNumber: Log所在文件代码行数
 - parameter fileName:   Log所在文件名
 */
func Log(_ message:Any?..., funcName:String = #function, lineNumber:Int = #line, fileName:String = #file){
    #if DEBUG_LOG
        let time = logFormatter.string(from: Date())
        
        let fileN = ((fileName as NSString).lastPathComponent as NSString).deletingPathExtension
        let prefix = "👉 \(fileN) (\(lineNumber))\t\(time): "
        
        if message.count == 1 {
            if let msg = message[0] {
                if msg is [String: Any] { //字典加个换行对齐
                    print("\(prefix)\n\(msg)\n")
                } else {
                    print("\(prefix) \(msg)")
                }
            }else{
                print("\(prefix) empty")
            }
            
        }else{            
            let msg = message.reduce("", { temp, part in
                if let part = part{
                    return temp.appending("\(part) ")
                }else{
                    return temp.appending("nil ")
                }
            })
            print("\(prefix) \(msg)")
        }
        
    #endif
}
