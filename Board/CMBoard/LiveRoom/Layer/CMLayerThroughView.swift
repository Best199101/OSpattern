//
//  CMLayerThroughView.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：自身不作为命中视图，触摸只交给子树；无命中返回 `nil`。与 `CMPopupThroughView` 等配对用于层 Board 宿主。 子视图正序遍历（对齐 ObjC）；若要与系统一致「上层优先」可改为 `reversed()`。 在 `onSetup` 里要用 CMLayout 排子 Board：`groupHostView` 若返回普通 `CMVLayout`，空白处常会命中布局自身而不穿透。 请用 `CMLayerThroughVLayout`（竖直 + 穿透），或：外层本类、内层 `CMLayerThroughVLayout` 铺满，`groupHostView` 返回内层。

import UIKit

open class CMLayerThroughView: UIView {

    open override func hitTest(_ location: CGPoint, with event: UIEvent?) -> UIView? {
        guard !subviews.isEmpty else { return nil }
        guard isUserInteractionEnabled, !isHidden, alpha >= 0.01 else { return nil }
        guard self.point(inside: location, with: event) else { return nil }

        for subview in subviews {
            if let hit = findHit(in: subview, location: location, event: event) {
                return hit
            }
        }
        return nil
    }

    private func findHit(in child: UIView, location: CGPoint, event: UIEvent?) -> UIView? {
        guard child.isUserInteractionEnabled, !child.isHidden, child.alpha >= 0.01 else { return nil }
        let childPoint = convert(location, to: child)
        guard child.point(inside: childPoint, with: event) else { return nil }
        return child.hitTest(childPoint, with: event)
    }
}
