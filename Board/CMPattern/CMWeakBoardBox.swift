//
//  CMWeakBoardBox.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：消息路由缓存中持有 Board 弱引用（与具体 Message 类型无关）。

import Foundation

internal final class CMWeakBoardBox {
    weak var board: CMBoard?

    init(_ board: CMBoard) {
        self.board = board
    }
}
