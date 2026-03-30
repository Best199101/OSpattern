//
//  CMChatViewModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：公屏聊天 ViewModel。

import UIKit

final class CMChatViewModel: CMViewModel<CMChatContentModel, CMChatViewHolder> {
    override func bind(model: CMChatContentModel, viewHolder: CMChatViewHolder) {
        viewHolder.apply(model)
    }
}
