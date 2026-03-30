//
//  CMVideoTileViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：`CMViewModel` 子类：单路宫格业务绑定。

import UIKit

final class CMVideoTileViewModel: CMViewModel<CMVideoParticipantModel, CMVideoTileViewHolder> {
    override func bind(model: CMVideoParticipantModel, viewHolder: CMVideoTileViewHolder) {
        viewHolder.apply(model)
    }
}
