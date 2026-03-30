//
//  CMTopLayerBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：L9 顶层占位；子 Board 挂在 `CMLayerThroughView` 上。全屏收键盘由子 Board `CMKeyboardDismissBoard` 管理（手势挂在 VC 根 view，见该文件说明）。

import UIKit

open class CMTopLayerBoard: CMRoomGroupBoard {
    private var gestureHost: CMLayerThroughView?

    open override func groupHostView(in root: UIView) -> UIView? {
        gestureHost
    }

    open override func childBoardTypes() -> [CMBoard.Type] {
        [CMKeyboardDismissBoard.self] + additionalTopLayerChildBoardTypes()
    }

    /// 在 `CMKeyboardDismissBoard` 之后追加其它顶层子 Board。
    open func additionalTopLayerChildBoardTypes() -> [CMBoard.Type] { [] }

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
