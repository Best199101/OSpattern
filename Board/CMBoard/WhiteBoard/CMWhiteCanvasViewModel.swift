//
//  CMWhiteCanvasViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：白板画布区 ViewModel。

import UIKit

final class CMWhiteCanvasViewModel: CMViewModel<CMWhiteCanvasContentModel, CMWhiteCanvasViewHolder> {
    override func bind(model: CMWhiteCanvasContentModel, viewHolder: CMWhiteCanvasViewHolder) {
        viewHolder.apply(model)
    }
}
