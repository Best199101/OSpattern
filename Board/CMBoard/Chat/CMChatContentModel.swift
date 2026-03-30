//
//  CMChatContentModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：公屏聊天内容模型。

import Foundation

final class CMChatContentModel: NSObject {
    var title: String
    var messages: [CMChatMessageModel]

    init(title: String = "聊天互动", messages: [CMChatMessageModel] = CMChatContentModel.placeholderMessages()) {
        self.title = title
        self.messages = messages
        super.init()
    }

    private static func placeholderMessages() -> [CMChatMessageModel] {
        [
            CMChatMessageModel(text: "欢迎来到直播间", isOutgoing: false),
            CMChatMessageModel(text: "老师好", isOutgoing: true),
        ]
    }
}
