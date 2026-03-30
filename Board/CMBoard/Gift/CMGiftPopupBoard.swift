//
//  CMGiftPopupBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：礼物弹窗子 Board：继承 `CMPopupBoard`；内部 `CMGiftViewModel` + `CMGiftViewHolder` + `CMGiftContentModel`。

import UIKit

final class CMGiftPopupBoard: CMRoomPopupBoard {
    private var giftViewModel: CMGiftViewModel?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        let content = CMGiftContentModel()
        let holder = CMGiftViewHolder(superView: superview)
        holder.onGiftSelected = { [weak self] giftId in
            guard let self else { return }
            self.post(CMLiveRoomMessage.sendGift(giftId: giftId))
            self.dismiss(completion: nil)
        }
        holder.onCloseTapped = { [weak self] in
            self?.dismiss(completion: nil)
        }
        giftViewModel = CMGiftViewModel(model: content, viewHolder: holder)
        popupView = holder.view
        let h = CMGiftViewHolder.panelHeight
        let w = superview.bounds.width
        popupView?.frame = CGRect(x: 0, y: superview.bounds.height, width: w, height: h)
        popupView?.autoresizingMask = [.flexibleWidth]
    }

    override func handles(_ message: CMLiveRoomMessage) -> Bool {
        switch message {
        case .openGiftPanel, .closeGiftPanel:
            return true
        default:
            return false
        }
    }

    override func receive(_ message: CMLiveRoomMessage) {
        switch message {
        case .openGiftPanel:
            show(completion: nil)
        case .closeGiftPanel:
            dismiss(completion: nil)
        default:
            break
        }
    }
}
