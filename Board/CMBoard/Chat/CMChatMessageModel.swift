//
//  CMChatMessageModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：公屏单条消息模型。

import Foundation

final class CMChatMessageModel: NSObject {
    var text: String
    var isOutgoing: Bool

    init(text: String, isOutgoing: Bool) {
        self.text = text
        self.isOutgoing = isOutgoing
        super.init()
    }
}
