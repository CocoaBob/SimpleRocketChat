//
//  ChatControllerMessageCellProtocol.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 17/12/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit
import SafariServices
import MobilePlayer
import FLAnimatedImage
import SimpleImageViewer

extension ChatViewController: ChatMessageCellProtocol {

    func handleLongPressMessageCell(_ message: Message, view: UIView, recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            presentActionsFor(message, view: view)
        }
    }

    func handleUsernameTapMessageCell(_ message: Message, view: UIView, recognizer: UIGestureRecognizer) {
//        guard let username = message.user?.username else { return }
//        RocketChatManager.openDirectMessage(username: username)
    }

    func openURL(url: URL) {
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }

    func openURLFromCell(url: MessageURL) {
        guard let targetURL = url.targetURL else { return }
        guard let destinyURL = URL(string: targetURL) else { return }
        let controller = SFSafariViewController(url: destinyURL)
        present(controller, animated: true, completion: nil)
    }

    func openVideoFromCell(attachment: Attachment) {
        guard let videoURL = attachment.fullVideoURL() else { return }
        let controller = MobilePlayerViewController(contentURL: videoURL)
        controller.title = attachment.title
        controller.activityItems = [attachment.title, videoURL]
        present(controller, animated: true, completion: nil)
    }

    func openImageFromCell(attachment: Attachment, thumbnail: FLAnimatedImageView) {
        textView.resignFirstResponder()

        if thumbnail.animatedImage != nil || thumbnail.image != nil {
            let configuration = ImageViewerConfiguration { config in
                config.image = thumbnail.image
                config.animatedImage = thumbnail.animatedImage
                config.imageView = thumbnail
                config.allowSharing = true
            }
            present(ImageViewerController(configuration: configuration), animated: true)
        } else {
            openImage(attachment: attachment)
        }
    }

    func openFileFromCell(attachment: Attachment) {
        openDocument(attachment: attachment)
    }

    func viewDidCollapseChange(view: UIView) {
        guard let origin = collectionView?.convert(CGPoint.zero, from: view) else { return }
        guard let indexPath = collectionView?.indexPathForItem(at: origin) else { return }
        collectionView?.reloadItems(at: [indexPath])
    }

}
