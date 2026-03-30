//
//  CMVideoBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：视频条子 Board：由 `CMLiveRoomMiddleTopBoard` 挂载；内部用 `CMVideoAreaViewModel` + `CMVideoAreaViewHolder` 搭建。

import UIKit

final class CMVideoBoard: CMRoomBoard {
    private var areaViewModel: CMVideoAreaViewModel?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        let content = CMVideoContentModel()
        let holder = CMVideoAreaViewHolder(superView: superview)
        areaViewModel = CMVideoAreaViewModel(model: content, viewHolder: holder)
    }
}
