//
//  CMAnimationLayerBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：L5 动效层占位；子 Board 挂在 `CMLayerThroughView` 上。

import UIKit

open class CMAnimationLayerBoard: CMRoomGroupBoard {
    private var gestureHost: CMLayerThroughView?

    open override func groupHostView(in root: UIView) -> UIView? {
        gestureHost
    }

    open override func onSetup(in superview: UIView) {
        let host = CMLayerThroughView(frame: superview.bounds)
        host.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        host.backgroundColor = .clear
        host.isHidden = true
        host.isUserInteractionEnabled = true
        superview.addSubview(host)
        gestureHost = host
    }
    
    open override func onLoad() {
        gestureHost?.isHidden = childBoardTypes().isEmpty
    }

    open override func childBoardTypes() -> [CMBoard.Type] {
        [CMLikeAnimationBoard.self]
    }
}
