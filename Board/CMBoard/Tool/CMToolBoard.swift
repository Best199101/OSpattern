//
//  CMToolBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：工具条子 Board：由 `CMLiveRoomMiddleBottomBoard` 挂载。

import UIKit

final class CMToolBoard: CMRoomBoard {
    private var toolViewModel: CMToolViewModel?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        let content = CMToolContentModel()
        let holder = CMToolViewHolder(superView: superview)
        holder.onItemSelected = { [weak self] kind in
            guard let self else { return }
            switch kind {
            case .like:
                self.post(CMLiveRoomMessage.like)
            case .gift:
                self.post(CMLiveRoomMessage.openGiftPanel)
            default:
                break
            }
        }
        toolViewModel = CMToolViewModel(model: content, viewHolder: holder)
    }
}
