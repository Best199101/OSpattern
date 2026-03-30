//
//  CMWhiteToolBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板工具条子 Board：由 `CMWhiteZoneBoard` 挂载在画布下方。

import UIKit

final class CMWhiteToolBoard: CMRoomBoard {

    private var toolViewModel: CMWhiteToolViewModel?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        let content = CMWhiteToolContentModel()
        let holder = CMWhiteToolViewHolder(superView: superview)
        var cfg = CMLayoutConfig(width: .atMost, height: .atMost)
        cfg.weight = 1
        holder.view.layoutConfig = cfg
        toolViewModel = CMWhiteToolViewModel(model: content, viewHolder: holder)
    }
}
