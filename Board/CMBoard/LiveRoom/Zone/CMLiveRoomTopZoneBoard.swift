//
//  CMLiveRoomTopZoneBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：中上区域组合 Board：自身不写业务 UI，子 Board 负责具体模块（当前为 `CMVideoBoard` 承载视频条）。

import UIKit

final class CMLiveRoomTopZoneBoard: CMRoomGroupBoard {

    lazy var contentView: UIView  = {
        let view = UIView(frame: .zero)
        return view
    }()

    private var vLayout: CMVLayout?

    override func groupHostView(in root: UIView) -> UIView? {
        contentView
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [CMVideoBoard.self]
    }

    /// 视频条默认高度；需随业务变化时只改本 Board。
    private let videoStripHeight: CGFloat = 120

    override func onSetup(in superview: UIView) {
        contentView.layoutConfig = CMLayoutConfig(width: .atMost, height: .atMost)
        let layout = cmVLayout([contentView])
        layout.layoutConfig = CMLayoutConfig(width: .atMost, height: .exact)
        layout.height = videoStripHeight
        vLayout = layout
        superview.addSubview(layout)
        
    }
}
