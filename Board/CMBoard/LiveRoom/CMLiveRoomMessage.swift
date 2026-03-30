//
//  CMLiveRoomMessage.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：直播间域内消息枚举；收发契约见 `CMMessageBus` / `CMBoard.handles` · `receive`。

import Foundation

public enum CMLiveRoomMessage: Hashable, Sendable {
    /// 占位：按需扩展为 `case userJoined(id:)` 等带关联值形式。
    case ping
    /// 触发点赞飘心等动效（可后续改为带屏幕坐标、用户 id 等关联值）。
    case like
    /// 打开礼物面板（工具条「礼物」等）。
    case openGiftPanel
    /// 关闭礼物面板。
    case closeGiftPanel
    /// 用户选定礼物（业务层可订阅做送礼接口、动效等）。
    case sendGift(giftId: String)
    /// 切换前置/后置摄像头（业务层接 RTC / 采集）。
    case flipCamera
}
