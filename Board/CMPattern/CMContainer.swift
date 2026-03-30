//
//  CMContainer.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：根容器：装配根 Board、`CMServiceContext`（`services`）；`post` 将 `CMLiveRoomMessage` 经 `handles`/`receive` 广播给根 Board。

import UIKit

open class CMContainer: CMServiceProviding, CMMessageBus {
    public weak var viewController: UIViewController?

    public var services = CMServiceContext()

    public private(set) var rootBoards: [CMBoard] = []

    private var retainedObservables: [ObjectIdentifier: CMObservable] = [:]
    private var messageRoutingCache: [AnyHashable: [CMWeakBoardBox]] = [:]

    private let stateLock = NSRecursiveLock()
    private let messageQueue = DispatchQueue(label: "com.cmpattern.container.message", qos: .userInitiated)
    private var isSetupValid = false

    /// 是否启用按 Message 缓存接收方弱引用。
    public var isMessageRoutingCacheEnabled = true

    public init() {}

    // MARK: - Root boards

    open func rootBoardTypes() -> [CMBoard.Type] { [] }

    open func onLoad() {
        stateLock.lock()
        let snapshot = Array(rootBoards)
        stateLock.unlock()
        snapshot.forEach { $0.callOnLoad() }
    }

    /// 对根快照依次 `callOnDestroy`；不清空 `rootBoards`。结束会话用 `clearContainer()`。
    open func onDestroy() {
        stateLock.lock()
        let snapshot = Array(rootBoards)
        stateLock.unlock()
        snapshot.forEach { $0.callOnDestroy() }
    }

    open func onAppear() {
        stateLock.lock()
        let snapshot = Array(rootBoards)
        stateLock.unlock()
        snapshot.forEach { $0.callOnAppear() }
    }

    open func onDisappear() {
        stateLock.lock()
        let snapshot = Array(rootBoards)
        stateLock.unlock()
        snapshot.forEach { $0.callOnDisappear() }
    }

    /// 有旧根时先 teardown（仅 `onDestroy`），再创建新根并 `callOnSetup`。界面仍可见且要对齐 `onAppear` 时，再次 setup 前可先 `onDisappear()`。
    public func setup(rootView: UIView?) {
        stateLock.lock()
        defer { stateLock.unlock() }
        teardownRootSessionLocked()
        let root = rootView ?? UIView()
        rootBoards = rootBoardTypes().map { $0.init(container: self) }
        rootBoards.forEach { $0.callOnSetup(in: root) }
        isSetupValid = true
    }

    /// `onDestroy` 旧根、清空列表与路由缓存；不 `onDisappear`。
    public func clearContainer() {
        stateLock.lock()
        defer { stateLock.unlock() }
        teardownRootSessionLocked()
    }

    /// - Warning: 勿在 `onDestroy()` 实现里调用 `clearContainer()`，避免重入。
    private func teardownRootSessionLocked() {
        isSetupValid = false
        messageRoutingCache.removeAll()
        guard !rootBoards.isEmpty else { return }
        stateLock.unlock()
        onDestroy()
        stateLock.lock()
        rootBoards.removeAll()
    }

    public func invalidateMessageRoutingCache() {
        stateLock.lock()
        defer { stateLock.unlock() }
        messageRoutingCache.removeAll()
    }

    public func rootBoardsIfNotEmpty() -> [CMBoard]? {
        stateLock.lock()
        defer { stateLock.unlock() }
        return rootBoards.isEmpty ? nil : Array(rootBoards)
    }

    // MARK: - CMMessageBus

    public func post(_ message: CMLiveRoomMessage) {
        messageQueue.async { [weak self] in
            self?.dispatchMessage(message)
        }
    }

    /// 少量必须主线程串行的场景用；默认优先 `post`。
    public func postOnMain(_ message: CMLiveRoomMessage) {
        CMMainQueue.asyncIfNeeded { [weak self] in
            self?.dispatchMessage(message)
        }
    }

    open func handles(_ message: CMLiveRoomMessage) -> Bool { false }

    open func receive(_ message: CMLiveRoomMessage) {}

    private func dispatchMessage(_ message: CMLiveRoomMessage) {
        let live = message
        let key = AnyHashable(live)
        stateLock.lock()
        let valid = isSetupValid
        let boardsSnapshot = Array(rootBoards)
        let cacheEnabled = isMessageRoutingCacheEnabled
        let cachedBoxes = cacheEnabled ? messageRoutingCache[key] : nil
        stateLock.unlock()
        guard valid else { return }

        if !cacheEnabled {
            boardsSnapshot.forEach { board in
                if board.handles(live) {
                    board.receive(live)
                }
            }
            return
        }

        if let cached = cachedBoxes {
            let aliveBoards = cached.compactMap(\.board)
            let currentHandlers = boardsSnapshot.filter { $0.handles(live) }
            let aliveIDs = Set(aliveBoards.map { ObjectIdentifier($0) })
            let currentIDs = Set(currentHandlers.map { ObjectIdentifier($0) })
            if !aliveBoards.isEmpty, aliveIDs == currentIDs {
                aliveBoards.forEach { board in
                    if board.handles(live) {
                        board.receive(live)
                    }
                }
                return
            }
            stateLock.lock()
            messageRoutingCache[key] = nil
            stateLock.unlock()
        }

        var weakBoxes: [CMWeakBoardBox] = []
        boardsSnapshot.forEach { board in
            if board.handles(live) {
                board.receive(live)
                weakBoxes.append(CMWeakBoardBox(board))
            }
        }
        stateLock.lock()
        if isSetupValid, !weakBoxes.isEmpty {
            messageRoutingCache[key] = weakBoxes
        }
        stateLock.unlock()
    }

    // MARK: - CMServiceProviding

    public func provide(_ object: AnyObject) { services.provide(object) }
    public func acquire<T>(_ type: T.Type) -> T? where T: AnyObject { services.acquire(type) }
    public func remove<T>(_ type: T.Type) where T: AnyObject { services.remove(type) }

    public func clear() {
        services.clear()
        stateLock.lock()
        retainedObservables.removeAll()
        stateLock.unlock()
    }

    public func observe<T>(_ type: T.Type) -> CMObservable? where T: AnyObject {
        let key = ObjectIdentifier(type)
        stateLock.lock()
        if let existing = retainedObservables[key] {
            stateLock.unlock()
            return existing
        }
        stateLock.unlock()
        guard let observable = services.observe(type) else { return nil }
        stateLock.lock()
        if let existing = retainedObservables[key] {
            stateLock.unlock()
            return existing
        }
        retainedObservables[key] = observable
        stateLock.unlock()
        return observable
    }
}
