//
//  CMStatusViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：状态栏区域 ViewModel。

import UIKit

final class CMStatusViewModel: CMViewModel<CMStatusContentModel, CMStatusViewHolder> {
    override func bind(model: CMStatusContentModel, viewHolder: CMStatusViewHolder) {
        viewHolder.apply(model)
    }
}
