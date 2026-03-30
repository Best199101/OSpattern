//
//  CMRoomPopupBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：弹窗子 Board：仅通过 `show` / `dismiss` 管理宿主与弹窗（`popViewStack`、点遮罩、位移动画）；不在 `onDestroy` 里做清理。 `onSetup` 的 `superview` 即全屏宿主；`popupView` 须已加入宿主子树。

import UIKit

private final class CMPopupBackdropTapProxy: NSObject, UIGestureRecognizerDelegate {
    weak var board: CMRoomPopupBoard?

    @objc func tapped() {
        board?.onBackdropTap()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let b = board, b.isTapEnabled, let host = b.fullScreenView else { return false }
        return touch.view === host
    }
}

open class CMRoomPopupBoard: CMBoard {
    /// 全屏宿主（ObjC `fullScreenView`）。
    public private(set) weak var fullScreenView: UIView?

    /// 弹窗根视图；赋值后保持隐藏直至 `show`。
    public var popupView: UIView? {
        didSet { popupView?.isHidden = true }
    }

    public var isTapEnabled = true
    public var duration: TimeInterval = 0.2
    public var disableShowAnimation = false

    /// 是否处于已展示态（动画结束后的可见期，主线程读写语义）。
    public private(set) var isShow = false

    private let tapProxy = CMPopupBackdropTapProxy()
    private let backdropTap = UITapGestureRecognizer()

    public required init(container: CMContainer) {
        super.init(container: container)
        backdropTap.addTarget(tapProxy, action: #selector(CMPopupBackdropTapProxy.tapped))
        backdropTap.delegate = tapProxy
        tapProxy.board = self
    }

    open override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        fullScreenView = superview
        tapProxy.board = self
    }

    open func willShow() {}
    open func onShowed() {}
    open func willDismiss() {}
    open func onDismissed() {}

    open func show(completion: (() -> Void)? = nil) {
        CMMainQueue.asyncIfNeeded { [weak self] in
            self?.showOnMain(completion: completion)
        }
    }

    open func dismiss(completion: (() -> Void)? = nil) {
        CMMainQueue.asyncIfNeeded { [weak self] in
            self?.dismissOnMain(completion: completion)
        }
    }

    fileprivate func onBackdropTap() {
        dismiss(completion: nil)
    }

    private func showOnMain(completion: (() -> Void)?) {
        guard !isShow, let host = fullScreenView, let popup = popupView else {
            completion?()
            return
        }

        willShow()

        host.isUserInteractionEnabled = true
        host.isHidden = false

        if backdropTap.view !== host {
            backdropTap.view?.removeGestureRecognizer(backdropTap)
            host.addGestureRecognizer(backdropTap)
        }

        let h = host.bounds.height
        popup.frame.origin.y = h
        popup.isHidden = false

        if let through = host as? CMPopupThroughView {
            through.popViewStack.add(self)
        }
        popup.superview?.bringSubviewToFront(popup)

        let finish: () -> Void = {
            self.isShow = true
            self.onShowed()
            completion?()
        }

        if disableShowAnimation {
            popup.frame.origin.y = h - popup.bounds.height
            finish()
        } else {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                popup.frame.origin.y = h - popup.bounds.height
            } completion: { _ in
                finish()
            }
        }
    }

    private func dismissOnMain(completion: (() -> Void)?) {
        guard isShow else {
            completion?()
            return
        }

        willDismiss()

        if let through = fullScreenView as? CMPopupThroughView {
            through.popViewStack.remove(self)
            if through.popViewStack.count == 0 {
                through.isUserInteractionEnabled = false
                through.removeGestureRecognizer(backdropTap)
            }
        } else {
            fullScreenView?.removeGestureRecognizer(backdropTap)
        }

        guard let host = fullScreenView, let popup = popupView else {
            applyDismissedState()
            isShow = false
            completion?()
            return
        }

        let h = host.bounds.height
        let done: () -> Void = {
            self.applyDismissedState()
            self.isShow = false
            completion?()
        }

        if disableShowAnimation {
            popup.frame.origin.y = h
            done()
        } else {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                popup.frame.origin.y = h
            } completion: { _ in
                done()
            }
        }
    }

    private func applyDismissedState() {
        popupView?.isHidden = true
        if let through = fullScreenView as? CMPopupThroughView, through.popViewStack.count == 0 {
            through.isHidden = true
            through.isUserInteractionEnabled = false
        }
        fullScreenView?.removeGestureRecognizer(backdropTap)
        onDismissed()
    }
}
