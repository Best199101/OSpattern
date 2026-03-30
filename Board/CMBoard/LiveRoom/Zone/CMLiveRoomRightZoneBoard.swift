//
//  CMLiveRoomRightZoneBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：右侧区域组合 Board：子 Board `CMChatBoard` 承载聊天互动。

import UIKit

final class CMLiveRoomRightZoneBoard: CMRoomGroupBoard {
    
    lazy var contentView: UIView  = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    override func groupHostView(in root: UIView) -> UIView? {
        contentView
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [CMChatBoard.self]
    }

    /// 右侧聊天栏固定宽度；占满父级在竖向上的高度由 `height: .atMost` 完成。
    private let chatSidebarWidth: CGFloat = 200

    override func onSetup(in superview: UIView) {
        contentView.layoutConfig = CMLayoutConfig(width: .exact, height: .atMost)
        contentView.width = chatSidebarWidth
        superview.addSubview(contentView)
    }
}
