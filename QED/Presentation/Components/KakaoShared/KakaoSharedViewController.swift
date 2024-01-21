//  swiftlint:disable all
//  KakaoSharedViewController.swift
//  QED
//
//  Created by changgyo seo on 1/19/24.
//

import SwiftUI
import SafariServices
import KakaoSDKTemplate
import KakaoSDKCommon
import KakaoSDKShare

class KakaoSharedViewController: UIViewController {
    
    var musicTitle: String
    var albumCoverURL: String?
    var pId: String
    
    init(musicTitle: String, albumCoverURL: String?, pId: String) {
        self.musicTitle = musicTitle
        self.albumCoverURL = albumCoverURL
        self.pId = pId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var safariViewController: SFSafariViewController? // to keep instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test()
    }
    
    func test() {
        let musicURLString = albumCoverURL ?? "https://i.ibb.co/JQDtm70/icon.jpg"
        let feedTemplateJsonStringData =
            """
            {
                "object_type": "feed",
                "content": {
                    "title": "\(musicTitle)",
                    "description": "FODI와 함께 동선을 연습해보세요~",
                    "image_url": "\(musicURLString)",
                    "link": {
                        "mobile_web_url" : "https://apps.apple.com/kr/app/%ED%8F%AC%EB%94%94-fodi-%EB%82%B4-%EC%86%90%EC%95%88%EC%9D%98-%ED%8F%AC%EB%A9%94%EC%9D%B4%EC%85%98-%EB%94%94%EB%A0%89%ED%84%B0/id6470155832",
                        "ios_execution_params": "pId=\(pId)"
                    }
                },
                "buttons": [
                        {
                            "title": "연습하러가기",
                            "link": {
                                "mobile_web_url" : "https://apps.apple.com/kr/app/%ED%8F%AC%EB%94%94-fodi-%EB%82%B4-%EC%86%90%EC%95%88%EC%9D%98-%ED%8F%AC%EB%A9%94%EC%9D%B4%EC%85%98-%EB%94%94%EB%A0%89%ED%84%B0/id6470155832",
                                "ios_execution_params": "pId=\(pId)"
                            }
                        }
                ]
            }
            """.data(using: .utf8)!
        
        guard let templatable = try? SdkJSONDecoder.custom.decode(FeedTemplate.self,
                                                                  from: feedTemplateJsonStringData) else {
            return
        }
        
        if ShareApi.isKakaoTalkSharingAvailable() {
            ShareApi.shared.shareDefault(templatable: templatable) {(sharingResult, error) in
                if let error = error {
                    print(error)
                } else {
                    if let sharingResult = sharingResult {
                        UIApplication.shared.open(sharingResult.url,
                                                  options: [:], completionHandler: nil)
                    }
                }
            }
        } else {
            if let url = ShareApi.shared.makeDefaultUrl(templatable: templatable) {
                self.safariViewController = SFSafariViewController(url: url)
                self.safariViewController?.modalTransitionStyle = .crossDissolve
                self.safariViewController?.modalPresentationStyle = .overCurrentContext
                self.present(self.safariViewController!, animated: true) {
                    print("웹 present success")
                }
            }
        }
    }
}
