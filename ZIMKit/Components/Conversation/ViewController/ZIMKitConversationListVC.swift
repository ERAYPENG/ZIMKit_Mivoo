//
//  ZIMKitConversationListVC.swift
//  ZIMKitConversation
//
//  Created by Kael Ding on 2022/7/29.
//

import UIKit
import ZegoPluginAdapter
import ZIM
import Combine

open class ZIMKitConversationListVC: _ViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    @objc public weak var delegate: ZIMKitConversationListVCDelegate?
    @objc public weak var messageDelegate: ZIMKitMessagesListVCDelegate?
    
    private var navigateConversationID: String?
    
    lazy var viewModel = ConversationListViewModel()
    
    lazy var noDataView: ConversationNoDataView = {
        let noDataView = ConversationNoDataView(frame: view.bounds).withoutAutoresizingMaskConstraints
        noDataView.delegate = self
        return noDataView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain).withoutAutoresizingMaskConstraints
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = view.backgroundColor
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.reuseIdentifier)
        tableView.register(ConversationApplicationCell.self, forCellReuseIdentifier: ConversationApplicationCell.reuseIdentifier)
        tableView.rowHeight = 74
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        return tableView
    }()
    
    open override func setUp() {
        super.setUp()
        view.backgroundColor = .mivoo_backgroundDarkBlue1
        self.navigationItem.title = "In-app Chat"
    }
    
    open override func setUpLayout() {
        super.setUpLayout()
        
        view.embed(tableView)
        view.addSubview(noDataView)
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: view.topAnchor, constant: 68), // 預留 index 0 高度
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
//        LocalAPNS.shared.setupLocalAPNS() // 改為 Mivoo 發送
        initCallConfig()
        initBinding()
        ZIMKitCore.shared.getNewestFriendApplication()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getConversationList()
    }
    
    func initCallConfig() {
        
        let appID = ZIMKit().imKitConfig.appID
        let appSign = ZIMKit().imKitConfig.appSign
        let userID = ZIMKit.localUser?.id ?? ""
        let userName = ZIMKit.localUser?.name ?? ""
        let callConfig = ZIMKit().imKitConfig.callPluginConfig
        if (appID ?? 0 <= 0) || appSign.count <= 0  || callConfig == nil {return}
        ZegoPluginAdapter.callPlugin?.initWith(appID: appID!, appSign: appSign, userID: userID, userName: userName, callPluginConfig: callConfig!)
        
    }
    
    deinit {
        //        ZIMKit.disconnectUser()
        cancellables.removeAll()
    }
    
    private func initBinding() {
        ZIMKitCore.shared.$newestFriendApplicationInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] applicationInfo in
                guard let self else { return }
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ConversationApplicationCell {
                    cell.model = applicationInfo
                    cell.updateUnreadStatus(isUnread: applicationInfo != nil)
                }
            }
            .store(in: &cancellables)
    }
    
    func configViewModel() {
        // listen the conversations change and reload.
        viewModel.$conversations.bind { [weak self] _ in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
    private func handleNavigationChat() {
        if let navigateConversationID, let conversation = viewModel.conversations.first(where: { $0.id == navigateConversationID }) {
            let defaultAction = { }
            self.delegate?.conversationList?(self, didSelectWith: conversation, defaultAction: defaultAction)
            self.viewModel.clearConversationUnreadMessageCount(conversation.id, type: conversation.type)
            self.navigateConversationID = nil
        }
    }
    
    open func getConversationList(completion: (() -> Void)? = nil) {
        viewModel.getConversationList { [weak self] conversations, error in
            guard let self = self else { return }
            if error.code == .ZIMErrorCodeSuccess {
                completion?()
                return
            }
            self.noDataView.setButtonTitle(L10n("conversation_reload"))
            self.noDataView.isHidden = false
            HUDHelper.showErrorMessageIfNeeded(error.code.rawValue,
                                               defaultMessage: L10n("conversation_wait_login"))
        }
    }
    
    open func gotoChatVC(by conversationID: String) {
        self.navigateConversationID = conversationID
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.handleNavigationChat()
        }
    }
    
    open func gotoInvite() {
        delegate?.didTapFriendApplicationCell?(self)
    }
    
    func loadMoreConversations() {
        viewModel.loadMoreConversations()
    }
}

extension ZIMKitConversationListVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.noDataView.isHidden = viewModel.conversations.count > 0
        return viewModel.conversations.count + 1 // index 0 是 application cell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationApplicationCell.reuseIdentifier, for: indexPath) as? ConversationApplicationCell else {
                return ConversationApplicationCell()
            }

            return cell
        }
        
        let conversationIndex = indexPath.row - 1

        guard conversationIndex < viewModel.conversations.count,
              let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.reuseIdentifier, for: indexPath) as? ConversationCell else {
            return ConversationCell()
        }

        let conversation = viewModel.conversations[conversationIndex] as ZIMKitConversation
        cell.model = conversation
        return cell
    }
}

extension ZIMKitConversationListVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate?.didTapFriendApplicationCell?(self)
            return
        }

        let model = viewModel.conversations[indexPath.row - 1]
        
        let defaultAction = {
            let messageListVC = ZIMKitMessagesListVC(conversationID: model.id, type: model.type, conversationName: model.name)
            messageListVC.delegate = self.messageDelegate
            self.navigationController?.pushViewController(messageListVC, animated: true)
            // clear unread messages
            self.viewModel.clearConversationUnreadMessageCount(model.id, type: model.type)
        }
        if delegate?.conversationList(_:didSelectWith:defaultAction:) == nil {
            defaultAction()
        } else {
            delegate?.conversationList?(self, didSelectWith: model, defaultAction: defaultAction)
            self.viewModel.clearConversationUnreadMessageCount(model.id, type: model.type)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
  
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            return nil
        }

        let conversationIndex = indexPath.row - 1
        guard conversationIndex < viewModel.conversations.count else {
            return nil
        }

        let conversation = viewModel.conversations[conversationIndex]
        let deleteAction = UIContextualAction(style: .normal, title: L10n("conversation_delete")) { _, _, _ in
            self.viewModel.deleteConversation(conversation) { error in
                if error.code != .ZIMErrorCodeSuccess {
                    HUDHelper.showErrorMessageIfNeeded(error.code.rawValue,
                                                       defaultMessage: error.message)
                } else {
                }
                //删除结果返回
                self.delegate?.shouldDeleteItem?(self, didSelectWith: conversation,
                                                withErrorCode: error.code.rawValue,
                                                withErrorMsg: error.message)
            }
            
        }
        deleteAction.backgroundColor = .zim_backgroundRed
      
        let pinnedAction = UIContextualAction(style: .normal, title: conversation.isPinned ? L10n("conversation_pinned_cancel") : L10n("conversation_pinned")) { _, _, _ in
            //          tableView.performBatchUpdates {
            self.viewModel.updateConversationPinnedState(conversation, isPinned: !conversation.isPinned) { error in
                if error.code != .ZIMErrorCodeSuccess {
                    HUDHelper.showErrorMessageIfNeeded(error.code.rawValue,
                                                       defaultMessage: error.message)
                }
            }
            conversation.isPinned = !conversation.isPinned
            self.viewModel.conversations[conversationIndex] = conversation
            if conversation.isPinned {
                let currentIndexPath = IndexPath(row: self.getsTheLocationIndexOfCurrentMessage(messageInfo: conversation), section: 0)
                tableView.moveRow(at: indexPath, to: currentIndexPath)
            } else {
                let firstIndexPath = IndexPath(row: 0, section: 0)
                tableView.moveRow(at: indexPath, to: firstIndexPath)
            }
        }
        pinnedAction.backgroundColor = conversation.isPinned ? .zim_backgroundLightGrey : .zim_backgroundBlue
        
        var actionArray: [UIContextualAction] = []
        // 使用可选链和空合并运算符来处理可能的 nil 值
        let hideSwipe = self.delegate?.shouldHideSwipePinnedItem?(self, didSelectWith: conversation) ?? false
        if !hideSwipe {
            actionArray.append(pinnedAction)
        }

        let hideDelete = self.delegate?.shouldHideSwipeDeleteItem!(self, didSelectWith: conversation) ?? false
        if !hideDelete{
            actionArray.append(deleteAction)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: actionArray)
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let distance = viewModel.conversations.count - 5 + 1 // application cell
        if row == distance {
            loadMoreConversations()
        }
    }
    //MARK: Customer Method
    func getsTheLocationIndexOfCurrentMessage( messageInfo: ZIMKitConversation) -> Int {
        var messageIndex = 0
        for (index, conversation) in self.viewModel.conversations.enumerated() {
            if conversation.orderKey < messageInfo.orderKey && conversation.isPinned == true {
                    messageIndex = index
                    break
                }
        }
        return messageIndex
    }
}

extension ZIMKitConversationListVC: ConversationNoDataViewDelegate {
    func onNoDataViewButtonClick() {
        getConversationList()
    }
}
