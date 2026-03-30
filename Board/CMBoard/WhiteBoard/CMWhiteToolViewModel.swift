//
//  CMWhiteToolViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板工具区 ViewModel。

import UIKit

final class CMWhiteToolViewModel: CMViewModel<CMWhiteToolContentModel, CMWhiteToolViewHolder> {
    override func bind(model: CMWhiteToolContentModel, viewHolder: CMWhiteToolViewHolder) {
        viewHolder.apply(model)
    }
}
