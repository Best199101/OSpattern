//
//  CMChatBoard.swift
//  CMBoard
//
//  Created by fei on 2026/3/28.
//

// 介绍：聊天子 Board：由 `CMLiveRoomRightBoard` 挂载；内部 `CMChatViewModel` + `CMChatViewHolder`。全屏点空白收键盘见 `CMKeyboardDismissBoard`。

import UIKit

final class CMChatBoard: CMRoomBoard {
    private var chatViewModel: CMChatViewModel?

    override func onSetup(in superview: UIView) {
        super.onSetup(in: superview)
        let content = CMChatContentModel()
        let holder = CMChatViewHolder(superView: superview)
        chatViewModel = CMChatViewModel(model: content, viewHolder: holder)
    }
}
