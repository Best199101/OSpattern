//
//  CMLiveRoomMiddleZoneBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：中下横向三区：左条 | 白板（flex）| 右侧聊天；根视图直接挂在 `CMHLayout` 上，避免单容器叠两层子 Board。

import UIKit

final class CMLiveRoomMiddleZoneBoard: CMRoomGroupBoard {

    private var hLayout: CMHLayout?

    override func groupHostView(in root: UIView) -> UIView? {
        hLayout
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [
            CMWhiteBoardZoneBoard.self,
            CMLiveRoomRightZoneBoard.self,
        ]
    }

    override func onSetup(in superview: UIView) {
        let layout = CMHLayout(frame: .zero)
        var cfg = CMLayoutConfig(width: .atMost, height: .atMost)
        cfg.weight = 1
        layout.layoutConfig = cfg
        hLayout = layout
        superview.addSubview(layout)
    }
}
