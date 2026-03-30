//
//  CMWhiteBoardZoneBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板区域组合 Board：横向 `CMHLayout`，左为工具区、右为画布区；子 Board 根视图并列铺满宽度。

import UIKit

final class CMWhiteBoardZoneBoard: CMRoomGroupBoard {

    private var hLayout: CMHLayout?

    override func groupHostView(in root: UIView) -> UIView? {
        hLayout
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [
            CMWhiteToolZoneBoard.self,
            CMWhiteCanvasZoneBoard.self,
        ]
    }

    override func onSetup(in superview: UIView) {
        let layout = CMHLayout(frame: .zero)
        let cfg = CMLayoutConfig(width: .atMost, height: .atMost)
        cfg.weight = 1
        layout.layoutConfig = cfg
        layout.width = 0
        hLayout = layout
        superview.addSubview(layout)
    }
}
