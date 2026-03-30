//
//  CMFloatLayerBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：L6 浮窗层占位；子 Board 挂在 `CMLayerThroughView` 上。

import UIKit

open class CMFloatLayerBoard: CMRoomGroupBoard {
    private var gestureHost: CMLayerThroughView?

    open override func groupHostView(in root: UIView) -> UIView? {
        gestureHost
    }

    open override func onSetup(in superview: UIView) {
        let host = CMLayerThroughView(frame: superview.bounds)
        host.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        host.backgroundColor = .clear
        host.isUserInteractionEnabled = true
        superview.addSubview(host)
        gestureHost = host
    }
    
    open override func onLoad() {
        gestureHost?.isHidden = childBoardTypes().isEmpty
    }
    
}
