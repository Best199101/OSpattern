//
//  CMWhiteCanvasBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板主绘制区子 Board，由 `CMWhiteZoneBoard` 纵向布局挂载在工具条上方。

import UIKit

final class CMWhiteCanvasBoard: CMRoomBoard {
    private var canvasViewModel: CMWhiteCanvasViewModel?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        let content = CMWhiteCanvasContentModel()
        let holder = CMWhiteCanvasViewHolder(superView: superview)
        var cfg = CMLayoutConfig(width: .atMost, height: .atMost)
        cfg.weight = 1
        holder.view.layoutConfig = cfg
        canvasViewModel = CMWhiteCanvasViewModel(model: content, viewHolder: holder)
    }
}
