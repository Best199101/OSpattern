//
//  CMWhiteCanvasZoneBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板画布分区 Group Board。

import UIKit

final class CMWhiteCanvasZoneBoard: CMRoomGroupBoard {

    private var vLayout: CMVLayout?

    override func groupHostView(in root: UIView) -> UIView? {
        vLayout
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [CMWhiteCanvasBoard.self]
    }

    override func onSetup(in superview: UIView) {
        let layout = CMVLayout(frame: .zero)
        let cfg = CMLayoutConfig(width: .atMost, height: .atMost)
        cfg.weight = 1
        layout.layoutConfig = cfg
        layout.width = 0
        vLayout = layout
        superview.addSubview(layout)
    }
}
