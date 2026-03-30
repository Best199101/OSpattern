//
//  CMStatusBarBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：顶栏状态子 Board：由 `CMLiveRoomTopBoard` 挂载。

import UIKit

final class CMStatusBarBoard: CMRoomBoard {
    private var statusViewModel: CMStatusViewModel?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        let content = CMStatusContentModel()
        let holder = CMStatusViewHolder(superView: superview)
        holder.onMicTapped = { [weak self] in
            self?.statusViewModel?.updateModel { $0.isMicEnabled.toggle() }
        }
        holder.onCameraTapped = { [weak self] in
            self?.statusViewModel?.updateModel { $0.isCameraEnabled.toggle() }
        }
        holder.onFlipCameraTapped = { [weak self] in
            self?.post(CMLiveRoomMessage.flipCamera)
        }
        statusViewModel = CMStatusViewModel(model: content, viewHolder: holder)
    }
}
