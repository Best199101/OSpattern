//
//  CMLiveRoomMainLayerBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：直播间主界面层 Group Board（中间区域子 Board 容器）。

import UIKit

final class CMLiveRoomMainLayerBoard: CMRoomGroupBoard {

    private var vLayout: CMLiveRoomMainThroughView?

    override func groupHostView(in root: UIView) -> UIView? {
        vLayout
    }

    override func onSetup(in superview: UIView) {
        let layout = CMLiveRoomMainThroughView(frame: superview.bounds)
        vLayout = layout
        superview.addSubview(layout)
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [
            CMLiveRoomStatusZoneBoard.self,
            CMLiveRoomTopZoneBoard.self,
            CMLiveRoomMiddleZoneBoard.self,
            CMLiveRoomToolZoneBoard.self,
        ]
    }
}
