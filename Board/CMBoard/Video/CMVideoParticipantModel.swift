//
//  CMVideoParticipantModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：单个视频宫格业务数据（需 class 以满足 CMViewModel 的 AnyObject 约束）。

import Foundation

final class CMVideoParticipantModel: NSObject {
    var slotIndex: Int
    var displayName: String
    var subtitle: String

    init(slotIndex: Int, displayName: String? = nil, subtitle: String? = nil) {
        self.slotIndex = slotIndex
        if let displayName {
            self.displayName = displayName
        } else {
            self.displayName = slotIndex == 0 ? "老师" : "学员 \(slotIndex)"
        }
        if let subtitle {
            self.subtitle = subtitle
        } else {
            self.subtitle = slotIndex == 0 ? "直播中" : "麦克风 · 0"
        }
        super.init()
    }

    var isTeacherSlot: Bool { slotIndex == 0 }
}
