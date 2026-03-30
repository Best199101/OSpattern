//
//  CMVideoContentModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：视频区域聚合数据模型（配合 `CMVideoAreaViewModel` / `CMVideoAreaViewHolder`）。

import Foundation
import UIKit

enum CMVideoLayout {
    static let slotCount = 8
    static let tileWidth: CGFloat = 104
    static let horizontalSpacing: CGFloat = 8
    static let stripInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
}

/// 整路视频区业务数据：多路参与者与 `CMVideoContentModel` 绑定。
final class CMVideoContentModel: NSObject {
    let participants: [CMVideoParticipantModel]

    init(slotCount: Int = CMVideoLayout.slotCount) {
        self.participants = (0..<slotCount).map { CMVideoParticipantModel(slotIndex: $0) }
        super.init()
    }
}
