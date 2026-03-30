//
//  CMToolViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：工具栏 ViewModel。

import UIKit

final class CMToolViewModel: CMViewModel<CMToolContentModel, CMToolViewHolder> {
    override func bind(model: CMToolContentModel, viewHolder: CMToolViewHolder) {
        viewHolder.apply(model)
    }
}
