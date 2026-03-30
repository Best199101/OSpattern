//
//  CMVideoAreaViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：`CMViewModel` 子类：视频区域业务，将 `CMVideoContentModel` 同步到各路 `CMVideoTileViewModel`。

import Foundation

final class CMVideoAreaViewModel: CMViewModel<CMVideoContentModel, CMVideoAreaViewHolder> {
    override func bind(model: CMVideoContentModel, viewHolder: CMVideoAreaViewHolder) {
        let n = min(model.participants.count, viewHolder.tileViewModels.count)
        for i in 0..<n {
            let src = model.participants[i]
            viewHolder.tileViewModels[i].updateModel { m in
                m.slotIndex = src.slotIndex
                m.displayName = src.displayName
                m.subtitle = src.subtitle
            }
        }
    }
}
