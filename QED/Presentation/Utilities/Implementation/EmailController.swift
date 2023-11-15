//
//  EmailController.swift
//  QED
//
//  Created by chaekie on 11/15/23.
//

import Foundation
import MessageUI

class EmailController: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailController()
    private override init() { }

    func sendEmail(_ sendTo: String) {
        if !MFMailComposeViewController.canSendMail() {
           print("This device cannot send emails.")
           return
        }

        let bodyString = """
                            성함:
                            연락처:
                            기기 모델:
                            기기 버전: \(UIDevice.current.systemVersion)
                            앱 버전: \(UIApplication.appVersion ?? "")
                            -------------------

                            이곳에 내용을 작성해주세요.



                        """

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([sendTo])
        mailComposer.setSubject("[문의]")
        mailComposer.setMessageBody(bodyString, isHTML: false)
        EmailController.getRootViewController()?.present(mailComposer, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailController.getRootViewController()?.dismiss(animated: true, completion: nil)
    }

    static func getRootViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first?.rootViewController
        return window
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
