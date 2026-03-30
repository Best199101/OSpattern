//
//  CMMessageListener.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：直播间消息**监听**：根树上的 `CMMessageListenerBoard` 在 `receive` 时把同一条 `CMLiveRoomMessage` 分发给已注册的闭包（不拦截、不改链路，与 `rootBoardTypes()` 顺序一致）。

import UIKit

public typealias CMMessageListenerHandler = (CMLiveRoomMessage) -> Void

public final class CMMessageListenerStore {
    public var listenersByID: [UUID: CMMessageListenerHandler] = [:]

    public init() {}
}

open class CMMessageListenerBoard: CMRoomBoard {
    open override func handles(_ message: CMLiveRoomMessage) -> Bool { true }

    open override func receive(_ message: CMLiveRoomMessage) {
        if let store = acquire(CMMessageListenerStore.self) {
            store.listenersByID.values.forEach { $0(message) }
        }
    }

    open override func onDestroy() {
        remove(CMMessageListenerStore.self)
        super.onDestroy()
    }

    // MARK: - Registration

    @discardableResult
    public func addListener(_ handler: @escaping CMMessageListenerHandler) -> UUID {
        let store = acquire(CMMessageListenerStore.self) ?? {
            let created = CMMessageListenerStore()
            provide(created)
            return created
        }()
        let id = UUID()
        store.listenersByID[id] = handler
        return id
    }

    public func removeListener(id: UUID) {
        acquire(CMMessageListenerStore.self)?.listenersByID[id] = nil
    }

    public func removeAllListeners() {
        acquire(CMMessageListenerStore.self)?.listenersByID.removeAll()
    }
}
