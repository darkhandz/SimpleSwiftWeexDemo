//
//  ViewController.swift
//  SwiftWeex
//
//  Created by darkhandz on 2018/1/5.
//  Copyright © 2018年 delite. All rights reserved.
//

import UIKit
import WeexSDK

class ViewController: UIViewController {
    
    var jsURL: URL?
    
    fileprivate var instance: WXSDKInstance?
    fileprivate var weexView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(jsURL != nil, "未赋值jsURL")
        title = "示例"
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        render()
    }
    
    deinit {
        instance?.destroy()
        Log("deinit")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateInstanceState(to: .WeexInstanceAppear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateInstanceState(to: .WeexInstanceDisappear)
    }
    
    
    
    func render() {
        guard jsURL != nil else {
            Log("jsURL is nil")
            return
        }
        instance?.destroy()
        instance = WXSDKInstance()
        instance?.viewController = self
        instance?.frame = CGRect(origin: .zero, size: view.bounds.size)
        instance?.onCreate = { [unowned self] view in
            guard let v = view else { return }
            self.weexView.removeFromSuperview()
            self.weexView = v
            self.view.addSubview(self.weexView)
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, v)
        }
        instance?.onFailed = { error in
            Log("instance failed:\(error?.localizedDescription ?? "")")
        }
        instance?.renderFinish = { [weak self] view in
            Log("instance render finish")
            self?.updateInstanceState(to: .WeexInstanceAppear)
        }
        instance?.updateFinish = { view in
            Log("instance update finish")
        }
        instance?.render(with: jsURL, options: ["bundleUrl": WeexBundleFolder], data: nil)
    }
    
    
    fileprivate func updateInstanceState(to newState: WXState) {
        guard instance?.state != newState else { return }
        instance?.state = newState
        switch newState {
        case .WeexInstanceAppear:
            WXSDKManager.bridgeMgr().fireEvent(instance?.instanceId, ref: WX_SDK_ROOT_REF, type: "viewappear", params: nil, domChanges: nil)
        case .WeexInstanceDisappear:
            WXSDKManager.bridgeMgr().fireEvent(instance?.instanceId, ref: WX_SDK_ROOT_REF, type: "viewdisappear", params: nil, domChanges: nil)
        default:
            break
        }
    }

}

