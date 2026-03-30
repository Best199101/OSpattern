//
//  CMWhiteToolZoneBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板工具区分组 Group Board。

import UIKit

final class CMWhiteToolZoneBoard: CMRoomGroupBoard {

    private var vLayout: CMVLayout?

    override func groupHostView(in root: UIView) -> UIView? {
        vLayout
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [CMWhiteToolBoard.self]
    }

    private let toolStripWidth: CGFloat = 30

    override func onSetup(in superview: UIView) {
        let layout = CMVLayout(frame: .zero)
        layout.layoutConfig = CMLayoutConfig(width: .exact, height: .atMost)
        layout.width = toolStripWidth
        vLayout = layout
        superview.addSubview(layout)
    }
}
