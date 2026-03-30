//
//  CMBoard.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：单块 UI/逻辑单元（与消息类型解耦）：生命周期 + 容器引用 + 服务转发。 消息能力见 `CMMessageBus`：默认 `post*` 转容器；`handles` / `receive`（直播间消息）由子类按需覆盖。

import UIKit

open class CMBoard: CMServiceProviding, CMMessageBus {
    public weak var container: CMContainer?

    /// 调试：释放时回调类型名。
    public var onDeinit: ((String) -> Void)?

    public required init(container: CMContainer) {
        self.container = container
    }

    deinit {
        onDeinit?(String(describing: Self.self))
    }

    open func callOnLoad() { onLoad() }
    open func callOnDestroy() { onDestroy() }
    open func callOnAppear() { onAppear() }
    open func callOnDisappear() { onDisappear() }
    open func callOnSetup(in superview: UIView) { onSetup(in: superview) }

    // MARK: - Lifecycle

    open func onLoad() {}
    open func onDestroy() {}
    open func onAppear() {}
    open func onDisappear() {}
    open func onSetup(in superview: UIView) {}
    
    // MARK: - Service（转发容器）
    
    public func provide(_ object: AnyObject) { container?.provide(object) }
    public func acquire<T>(_ type: T.Type) -> T? where T: AnyObject { container?.acquire(type) }
    public func remove<T>(_ type: T.Type) where T: AnyObject { container?.remove(type) }

    public func clear() { container?.clear() }

    public func observe<T>(_ type: T.Type) -> CMObservable? where T: AnyObject {
        container?.observe(type)
    }

    // MARK: - CMMessageBus（接收；发送在 extension）

    open func handles(_ message: CMLiveRoomMessage) -> Bool { false }

    open func receive(_ message: CMLiveRoomMessage) {}
    
    public func post(_ message: CMLiveRoomMessage) {
        container?.post(message)
    }

    public func postOnMain(_ message: CMLiveRoomMessage) {
        container?.postOnMain(message)
    }
}
