//
//  CMPopupLayerBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：L7 弹窗层：对齐 ObjC `CRPopupGroupBoard` + `CRPopViewContainer`。 - 初始 `isHidden = true`、`isUserInteractionEnabled = false`，无弹窗时不拦截底层。 - 展示弹窗时 `setPopupContainerActive(true)`；全部收起后 `setPopupContainerActive(false)`。 - `CMPopupThroughView` 在交互开启时：子视图逆序命中，空白 `hitTest` 返回自身（全屏 dismiss）。

import UIKit

open class CMPopupLayerBoard: CMRoomGroupBoard {
    private var gestureHost: CMPopupThroughView?

    open override func groupHostView(in root: UIView) -> UIView? {
        gestureHost
    }

    open override func onSetup(in superview: UIView) {
        let host = CMPopupThroughView(frame: superview.bounds)
        host.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        host.backgroundColor = .clear
        host.isHidden = true
        host.isUserInteractionEnabled = false
        superview.addSubview(host)
        gestureHost = host
    }
    
    open override func onDestroy() {
        gestureHost?.subviews.forEach { $0.removeFromSuperview() }
        gestureHost?.removeFromSuperview()
        gestureHost = nil
        super.onDestroy()
    }

    open override func childBoardTypes() -> [CMBoard.Type] {
        [CMGiftPopupBoard.self]
    }
}
