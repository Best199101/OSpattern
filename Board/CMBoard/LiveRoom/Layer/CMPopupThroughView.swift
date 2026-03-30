//
//  CMPopupThroughView.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：弹窗宿主：子视图逆序 hitTest（与 `CMLayerThroughView` 一致为「上层优先」）；有子视图时未命中子树则 `self` 接全屏 dismiss。 无子视图时返回 `nil`，与穿透层一致——避免仅误开 `userInteractionEnabled` 时整屏吃掉底层（如工具条）。 非全屏弹窗需自行加全屏透明底或依赖宿主空白 `self` 做 dismiss。

import UIKit

open class CMPopupThroughView: UIView {

    /// 预留与融合侧弹窗栈同步；当前命中顺序以 `subviews`（逆序）为准。
    public private(set) var popViewStack = NSMutableSet()

    open override func hitTest(_ location: CGPoint, with event: UIEvent?) -> UIView? {
        guard !subviews.isEmpty else { return nil }
        guard isUserInteractionEnabled, !isHidden, alpha >= 0.01 else { return nil }
        guard self.point(inside: location, with: event) else { return nil }

        for subview in subviews.reversed() {
            if let hit = findHitForPopSubview(subview, location: location, event: event) {
                return hit
            }
        }
        return self
    }

    private func findHitForPopSubview(_ child: UIView, location: CGPoint, event: UIEvent?) -> UIView? {
        guard child.isUserInteractionEnabled, !child.isHidden, child.alpha >= 0.01 else { return nil }
        let childPoint = convert(location, to: child)
        guard child.point(inside: childPoint, with: event) else { return nil }
        return child.hitTest(childPoint, with: event)
    }
}
