//
//  CMLikeAnimationViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：点赞动画 ViewModel。

import UIKit

final class CMLikeAnimationViewModel: CMViewModel<CMLikeAnimationContentModel, CMLikeAnimationViewHolder> {
    override func bind(model: CMLikeAnimationContentModel, viewHolder: CMLikeAnimationViewHolder) {}

    func handleLikeMessage() {
        CMMainQueue.async { [weak self] in
            guard let self else { return }
            self.viewHolder.playLikeBurst(from: self.model)
        }
    }
}
