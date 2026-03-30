//
//  CMDriver.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：与融合侧 `CMDriver` 对齐：驱动直播间容器分支（如纯音频 vs 视频 vs IM vs 白板）。

import Foundation

public protocol CMDriver: AnyObject {
    /// `true` 时走「侧滑容器」等音频直播栈；`false` 走默认多层渲染栈。
    var isAudioLive: Bool { get }
}

/// 默认实现，便于 Demo 与单测。
public final class CRDefaultDriver: CMDriver {
    public var isAudioLive: Bool

    public init(isAudioLive: Bool = false) {
        self.isAudioLive = isAudioLive
    }
}
