//
//  CMLiveRoomToolZoneBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：底部区域：全宽底栏。

import UIKit

class CMLiveRoomToolZoneBoard: CMRoomGroupBoard {
    
    lazy var contentView: UIView  = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private var hLayout: CMHLayout?

    override func groupHostView(in root: UIView) -> UIView? {
        contentView
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [CMToolBoard.self]
    }
    
    /// 底栏高度；工具条真实高度在本 Board 内约定。
    private let bottomBarHeight: CGFloat = 48

    override func onSetup(in superview: UIView) {
        contentView.layoutConfig = CMLayoutConfig(width: .atMost, height: .atMost)

        let layout = cmHLayout([contentView])
        layout.layoutConfig = CMLayoutConfig(width: .atMost, height: .exact)
        layout.height = bottomBarHeight
        hLayout = layout
        superview.addSubview(layout)
    }
}

