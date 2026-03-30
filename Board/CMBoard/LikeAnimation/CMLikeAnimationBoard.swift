//
//  CMLikeAnimationBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：点赞等全屏动效子 Board：由 `CMAnimationLayerBoard` 挂载；内部 `CMLikeAnimationViewModel` + `CMLikeAnimationViewHolder`。

import UIKit

final class CMLikeAnimationBoard: CMRoomBoard {
    private var likeViewModel: CMLikeAnimationViewModel?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        let content = CMLikeAnimationContentModel()
        let holder = CMLikeAnimationViewHolder(superView: superview)
        likeViewModel = CMLikeAnimationViewModel(model: content, viewHolder: holder)
    }

    override func handles(_ message: CMLiveRoomMessage) -> Bool {
        if case .like = message { return true }
        return false
    }

    override func receive(_ message: CMLiveRoomMessage) {
        guard case .like = message else { return }
        likeViewModel?.handleLikeMessage()
    }
}
