//
//  CMMessageBus.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：消息总线：收发均为 `CMLiveRoomMessage`（`post` / `postOnMain` / `handles` / `receive`）。

import UIKit

// MARK: - Bus

/// 直播间场景消息能力（单一消息类型）。
public protocol CMMessageBus: AnyObject {
    func post(_ message: CMLiveRoomMessage)
    func postOnMain(_ message: CMLiveRoomMessage)
    func handles(_ message: CMLiveRoomMessage) -> Bool
    func receive(_ message: CMLiveRoomMessage)
}
