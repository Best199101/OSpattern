//
//  CMStatusContentModel.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：状态栏区域内容模型。

import Foundation

final class CMStatusContentModel: NSObject {
    /// 房间标题（如课程名）
    var roomTitle: String
    /// 是否直播中
    var isLive: Bool
    /// 左侧状态文案（如信号、网络）
    var statusSubtitle: String
    /// 麦克风是否开启（仅 UI 状态，业务在回调里同步真实采集）。
    var isMicEnabled: Bool
    /// 摄像头是否开启
    var isCameraEnabled: Bool

    init(
        roomTitle: String = "小花课：课堂示例",
        isLive: Bool = true,
        statusSubtitle: String = "直播中 · 信号良好",
        isMicEnabled: Bool = true,
        isCameraEnabled: Bool = true
    ) {
        self.roomTitle = roomTitle
        self.isLive = isLive
        self.statusSubtitle = statusSubtitle
        self.isMicEnabled = isMicEnabled
        self.isCameraEnabled = isCameraEnabled
        super.init()
    }
}
