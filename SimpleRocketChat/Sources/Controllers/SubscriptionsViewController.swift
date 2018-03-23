//
//  SubscriptionsViewController.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 7/21/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import RealmSwift

// swiftlint:disable file_length
final class SubscriptionsViewController: UIViewController {
    
    // Class methods
    static var shared: SubscriptionsViewController? {
        return UIStoryboard(name: "Subscriptions", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionsViewController") as? SubscriptionsViewController
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint! {
        didSet {
            // Remove the bottom constraint if we don't support multi server
            if !AppManager.supportsMultiServer {
                tableViewBottomConstraint.constant = 0
            }
        }
    }

    @IBOutlet weak var activityViewSearching: UIActivityIndicatorView!

    let defaultButtonCancelSearchWidth = CGFloat(65)
    @IBOutlet weak var buttonCancelSearch: UIButton! {
        didSet {
            buttonCancelSearch.setTitle(localized("global.cancel"), for: .normal)
        }
    }
    @IBOutlet weak var buttonCancelSearchWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var textFieldSearch: UITextField! {
        didSet {
            textFieldSearch.placeholder = localized("subscriptions.search")

            if let placeholder = textFieldSearch.placeholder {
                let color = UIColor(rgb: 0x9ea2a4, alphaVal: 1)
                textFieldSearch.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
            }
        }
    }

    @IBOutlet weak var viewTextField: UIView! {
        didSet {
            viewTextField.layer.cornerRadius = 4
            viewTextField.layer.masksToBounds = true
        }
    }

    weak var avatarView: AvatarView?
    @IBOutlet weak var avatarViewContainer: UIView! {
        didSet {
            avatarViewContainer.layer.masksToBounds = true
            avatarViewContainer.layer.cornerRadius = 5

            if let avatarView = AvatarView.instantiateFromNib() {
                avatarView.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: avatarViewContainer.frame.width,
                    height: avatarViewContainer.frame.height
                )

                avatarViewContainer.addSubview(avatarView)
                self.avatarView = avatarView
            }
        }
    }

    @IBOutlet weak var labelServer: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var buttonAddChannel: UIButton! {
        didSet {
            if let image = UIImage(named: "Add") {
                buttonAddChannel.tintColor = .RCLightBlue()
                buttonAddChannel.setImage(image, for: .normal)
            }
        }
    }
    @IBOutlet weak var imageViewArrowDown: UIImageView! {
        didSet {
            imageViewArrowDown.image = imageViewArrowDown.image?.withRenderingMode(.alwaysTemplate)
            imageViewArrowDown.tintColor = .RCLightBlue()
        }
    }

    var assigned = false
    var isSearchingLocally = false
    var isSearchingRemotely = false
    var searchResult: [Subscription]?
    var subscriptions: Results<Subscription>?
    var currentUserToken: NotificationToken?

    var searchText: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeModelChanges()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension SubscriptionsViewController {

    func subscribeModelChanges() {
        guard !assigned else { return }
        guard let auth = AuthManager.isAuthenticated() else { return }
//        guard let realm = Realm.shared else { return }

        assigned = true

        subscriptions = auth.subscriptions.sorted(byKeyPath: "lastSeen", ascending: false)
    }

    func subscription(for indexPath: IndexPath) -> Subscription? {
        return subscriptions?[indexPath.row]
    }
}

extension SubscriptionsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionCell.identifier) as? SubscriptionCell else {
            return UITableViewCell()
        }

        if let subscription = subscription(for: indexPath) {
            cell.subscription = subscription
        }

        return cell
    }
}

extension SubscriptionsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let subscription = subscription(for: indexPath) else { return }

        if let chatVC = ChatViewController.shared {
            chatVC.subscription = subscription
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SubscriptionCell else { return }
        guard let subscription = cell.subscription else { return }
        guard let selectedSubscription = ChatViewController.shared?.subscription else { return }

        if subscription.identifier == selectedSubscription.identifier {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}
