//
//  CMKeyboardDismissBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：作为 `CMTopLayerBoard` 的子 Board 管理生命周期；手势挂在 `container.viewController?.view`（整屏根视图），因子 Board 的 `superview` 为穿透层 `CMLayerThroughView`，不能用于全屏命中。

import UIKit

/// 无界面：仅注册全屏点空白收键盘。
final class CMKeyboardDismissBoard: CMRoomBoard {
    private weak var rootHostView: UIView?
    private var tap: UITapGestureRecognizer?
    private var proxy: CMKeyboardDismissProxy?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        guard let root = container?.viewController?.view else { return }

        let p = CMKeyboardDismissProxy()
        let g = UITapGestureRecognizer(target: p, action: #selector(CMKeyboardDismissProxy.handleTap(_:)))
        g.cancelsTouchesInView = false
        g.delegate = p
        root.addGestureRecognizer(g)
        proxy = p
        tap = g
        rootHostView = root
    }

    override func onDestroy() {
        if let g = tap, let v = rootHostView {
            v.removeGestureRecognizer(g)
        }
        tap = nil
        rootHostView = nil
        proxy = nil
        super.onDestroy()
    }
}

// MARK: - `CMBoard` 非 NSObject，手势 target / delegate 用独立 NSObject

private final class CMKeyboardDismissProxy: NSObject, UIGestureRecognizerDelegate {
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        gesture.view?.endEditing(true)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !CMKeyboardDismissProxy.touchTargetsTextInput(touch)
    }

    private static func touchTargetsTextInput(_ touch: UITouch) -> Bool {
        var v: UIView? = touch.view
        while let c = v {
            if c is UITextField || c is UITextView { return true }
            v = c.superview
        }
        return false
    }
}
