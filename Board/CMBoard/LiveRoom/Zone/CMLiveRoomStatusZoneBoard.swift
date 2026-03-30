//
//  CMLiveRoomStatusZoneBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：顶部区域组合 Board：子 Board `CMStatusBarBoard` 承载标题与直播状态等。

import UIKit

final class CMLiveRoomStatusZoneBoard: CMRoomGroupBoard {

    lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    override func groupHostView(in root: UIView) -> UIView? {
        contentView
    }

    override func childBoardTypes() -> [CMBoard.Type] {
        [CMStatusBarBoard.self]
    }

    private let topBarHeight: CGFloat = 30

    override func onSetup(in superview: UIView) {
        contentView.layoutConfig = CMLayoutConfig(width: .atMost, height: .exact)
        contentView.height = topBarHeight
        superview.addSubview(contentView)
    }
}
