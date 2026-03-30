//
//  CMLiveRoomMainThroughView.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：直播间总容器：继承 `CMVLayout`，自上而下排列子 Board 的根视图，直至父视图高度。 各子 Board 在自身 `onSetup` 中为根视图设置 `layoutConfig`（含 `weight`）约定高度策略。

import UIKit

open class CMLiveRoomMainThroughView: CMVLayout {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
