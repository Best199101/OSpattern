//
//  CMLayerThroughVLayout.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：CMPattern/CMLayout 在 `onSetup` 里需要 **CMLayout 竖直排版** 且 **空白处仍穿透** 时使用：等同 `CMVLayout`，但 `hitTest` 与 `CMLayerThroughView` 一致。 典型：`CMLayerThroughView` 铺满父视图，其内再 `addSubview` 本类铺满；`groupHostView` 返回本实例，子 Board 根视图设 `layoutConfig` 即可。

import UIKit

open class CMLayerThroughVLayout: CMVLayout {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func hitTest(_ location: CGPoint, with event: UIEvent?) -> UIView? {
        guard !subviews.isEmpty else { return nil }
        guard isUserInteractionEnabled, !isHidden, alpha >= 0.01 else { return nil }
        guard self.point(inside: location, with: event) else { return nil }

        for subview in subviews {
            if let hit = cmThroughFindHit(in: subview, location: location, event: event) {
                return hit
            }
        }
        return nil
    }

    private func cmThroughFindHit(in child: UIView, location: CGPoint, event: UIEvent?) -> UIView? {
        guard child.isUserInteractionEnabled, !child.isHidden, child.alpha >= 0.01 else { return nil }
        let childPoint = convert(location, to: child)
        guard child.point(inside: childPoint, with: event) else { return nil }
        return child.hitTest(childPoint, with: event)
    }
}
