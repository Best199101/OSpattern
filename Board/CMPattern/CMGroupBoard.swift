//
//  CMGroupBoard.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：多子 Board 的父节点：子树生命周期 + 对子节点用 `CMMessageBus` 的 `handles` / `receive` 转发（与容器规则一致）。

import UIKit

open class CMGroupBoard: CMRoomBoard {
    public private(set) var children: [CMBoard] = []
    private var childMessageRoutingCache: [AnyHashable: [CMWeakBoardBox]] = [:]

    private let childStateLock = NSLock()

    public var isChildMessageRoutingCacheEnabled = true

    open func childBoardTypes() -> [CMBoard.Type] { [] }

    /// 非 nil 时子视图挂到此 view，否则挂 `superview`。
    open func groupHostView(in root: UIView) -> UIView? { nil }

    open override func callOnLoad() {
        super.callOnLoad()
        forEachChildSnapshot { $0.callOnLoad() }
    }

    open override func callOnDestroy() {
        super.callOnDestroy()
        forEachChildSnapshot { $0.callOnDestroy() }
    }

    open override func callOnAppear() {
        super.callOnAppear()
        forEachChildSnapshot { $0.callOnAppear() }
    }

    open override func callOnDisappear() {
        super.callOnDisappear()
        forEachChildSnapshot { $0.callOnDisappear() }
    }

    open override func callOnSetup(in superview: UIView) {
        super.callOnSetup(in: superview)
        makeChildBoards()
        installChildBoards(in: superview)
    }

    /// 已有子项时先 `disappear` → `destroy` 再建新子项；`onDisappear` 宜幂等。
    public func makeChildBoards() {
        guard let container else {
            assertionFailure("CMGroupBoard 需要有效的 container")
            return
        }
        childStateLock.lock()
        if !children.isEmpty {
            let old = children
            children.removeAll()
            childMessageRoutingCache.removeAll()
            childStateLock.unlock()
            old.forEach { $0.callOnDisappear() }
            old.forEach { $0.callOnDestroy() }
            childStateLock.lock()
        }
        children = childBoardTypes().map { $0.init(container: container) }
        childStateLock.unlock()
    }

    open func installChildBoards(in superview: UIView) {
        let host = groupHostView(in: superview) ?? superview
        childStateLock.lock()
        let snapshot = Array(children)
        childStateLock.unlock()
        snapshot.forEach { $0.callOnSetup(in: host) }
    }

    open override func handles(_ message: CMLiveRoomMessage) -> Bool {
        childStateLock.lock()
        let list = children
        childStateLock.unlock()
        return list.contains { $0.handles(message) }
    }

    open override func receive(_ message: CMLiveRoomMessage) {
        let key = AnyHashable(message)
        childStateLock.lock()
        let snapshot = Array(children)
        let cacheEnabled = isChildMessageRoutingCacheEnabled
        let cachedBoxes = cacheEnabled ? childMessageRoutingCache[key] : nil
        childStateLock.unlock()

        if !cacheEnabled {
            snapshot.forEach { child in
                if child.handles(message) {
                    child.receive(message)
                }
            }
            return
        }

        if let cached = cachedBoxes {
            let aliveBoards = cached.compactMap(\.board)
            let currentHandlers = snapshot.filter { $0.handles(message) }
            let aliveIDs = Set(aliveBoards.map { ObjectIdentifier($0) })
            let currentIDs = Set(currentHandlers.map { ObjectIdentifier($0) })
            if !aliveBoards.isEmpty, aliveIDs == currentIDs {
                aliveBoards.forEach { child in
                    if child.handles(message) {
                        child.receive(message)
                    }
                }
                return
            }
            childStateLock.lock()
            childMessageRoutingCache[key] = nil
            childStateLock.unlock()
        }

        var weakBoxes: [CMWeakBoardBox] = []
        snapshot.forEach { child in
            if child.handles(message) {
                child.receive(message)
                weakBoxes.append(CMWeakBoardBox(child))
            }
        }
        childStateLock.lock()
        if !weakBoxes.isEmpty {
            childMessageRoutingCache[key] = weakBoxes
        }
        childStateLock.unlock()
    }

    public func invalidateChildMessageRoutingCache() {
        childStateLock.lock()
        defer { childStateLock.unlock() }
        childMessageRoutingCache.removeAll()
    }

    public func childBoardsIfNotEmpty() -> [CMBoard]? {
        childStateLock.lock()
        defer { childStateLock.unlock() }
        return children.isEmpty ? nil : Array(children)
    }

    private func forEachChildSnapshot(_ body: (CMBoard) -> Void) {
        childStateLock.lock()
        let snapshot = Array(children)
        childStateLock.unlock()
        snapshot.forEach(body)
    }
}
