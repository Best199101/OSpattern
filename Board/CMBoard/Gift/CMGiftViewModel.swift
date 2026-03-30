//
//  CMGiftViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：礼物弹层 ViewModel。

import UIKit

final class CMGiftViewModel: CMViewModel<CMGiftContentModel, CMGiftViewHolder> {
    override func bind(model: CMGiftContentModel, viewHolder: CMGiftViewHolder) {
        viewHolder.apply(model)
    }
}
