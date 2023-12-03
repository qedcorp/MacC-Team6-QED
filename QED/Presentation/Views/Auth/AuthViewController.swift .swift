//
//  AuthViewController.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import AuthenticationServices
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import SnapKit
import SwiftUI

class AuthViewController: UIViewController, AuthUIProtocol {
    let loginViewModel = LoginViewModel.shared
    private var pages = LoginPages.allCases
    private var currentIndex = 0 {
        didSet { setUpObjects() }
    }
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let sizeFactor: CGFloat
    let scrollWidth: CGFloat
    let scrollHeight: CGFloat

    init() {
        sizeFactor = screenHeight / 844
        scrollWidth = screenWidth * 0.5
        scrollHeight = scrollWidth * 2.17
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObjects()
        setUpUI()
    }

    lazy var stepLabel: UILabel = {
        let object = UILabel()
        object.textColor = .white
        object.font = UIFont(name: "Pretendard-Regular", size: 20 * sizeFactor)
        return object
    }()

    lazy var titleBoldLabel: UILabel = {
        let object = UILabel()
        object.font = UIFont(name: "Pretendard-Bold", size: 30 * sizeFactor)
        object.textColor = .white
        return object
    }()

    lazy var titleRegularLabel: UILabel = {
        let object = UILabel()
        object.font = UIFont(name: "Pretendard-Regular", size: 30 * sizeFactor)
        object.textColor = .white
        return object
    }()

    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleBoldLabel, titleRegularLabel])
        return stackView
    }()

    lazy var loginBackgroundView: UIImageView = {
        let object = UIImageView()
        object.image = UIImage(named: "loginBackground")
        return object
    }()

    lazy var scrollView: UIScrollView = {
        let object = UIScrollView()
        object.contentSize = CGSize(width: scrollWidth * CGFloat(pages.count), height: scrollHeight)
        object.delegate = self
        object.alwaysBounceVertical = false
        object.showsHorizontalScrollIndicator = false
        object.isPagingEnabled = true
        object.bounces = false
        object.layer.cornerRadius = 28 * sizeFactor
        return object
    }()

    lazy var pageControl: UIPageControl = {
        let object = UIPageControl()
        object.numberOfPages = pages.count
        object.currentPage = currentIndex
        object.pageIndicatorTintColor = .monoNormal1
        object.currentPageIndicatorTintColor = .monoNormal3
        object.isUserInteractionEnabled = false
        return object
    }()

    lazy var loginInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stepLabel, titleStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8 * sizeFactor
        return stackView
    }()

    lazy var loginGuideLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 15 * sizeFactor)
        object.textColor = .white
        object.text = "SNS 계정으로 간편 가입하기"
        return object
    }()

    lazy var appleButton: UIButton = {
        let object = UIButton()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAppleSignInView(_:)))
        object.backgroundColor = .white
        object.layer.cornerRadius = screenWidth * 0.075 * sizeFactor
        object.setImage(UIImage(named: "apple_login"), for: .normal)
        object.addGestureRecognizer(gesture)
        return object
    }()

    lazy var kakaoButton: UIButton = {
        let object = UIButton()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapKakaoSignInView(_:)))
        object.backgroundColor = UIColor.KakaoYellow
        object.layer.cornerRadius = screenWidth * 0.075 * sizeFactor
        object.setImage(UIImage(named: "kakao_login"), for: .normal)
        object.addGestureRecognizer(gesture)
        return object
    }()

    lazy var googleButton: UIButton = {
        let object = UIButton()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGoogleSignInView(_:)))
        object.backgroundColor = .white
        object.layer.cornerRadius = screenWidth * 0.075 * sizeFactor
        object.setImage(UIImage(named: "google_login"), for: .normal)
        object.addGestureRecognizer(gesture)
        return object
    }()

    lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appleButton, kakaoButton, googleButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20 * sizeFactor
        return stackView
    }()

    private func setUpUI() {
        view.backgroundColor = .black
        [loginInfoStackView, loginBackgroundView, scrollView, pageControl, loginGuideLabel, loginButtonStackView].forEach {
            view.addSubview($0)
        }

        loginBackgroundView.snp.makeConstraints {
            $0.width.equalTo(scrollWidth * 1.06)
            $0.height.equalTo(scrollHeight * 1.03)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.width.equalTo(scrollWidth)
            $0.height.equalTo(scrollHeight)
            $0.centerX.equalTo(loginBackgroundView.snp.centerX)
            $0.centerY.equalTo(loginBackgroundView.snp.centerY)
        }

        loginInfoStackView.snp.makeConstraints {
            $0.bottom.equalTo(loginBackgroundView.snp.top).offset(-screenHeight * 0.04)
            $0.left.equalToSuperview().inset(66)
        }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(loginBackgroundView.snp.bottom).offset(screenHeight * 0.015 * sizeFactor)
            $0.centerX.equalToSuperview()
        }

        loginGuideLabel.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(screenHeight * 0.03 * sizeFactor)
            $0.centerX.equalToSuperview()
        }

        appleButton.snp.makeConstraints {
            $0.width.height.equalTo(screenWidth * 0.15 * sizeFactor)
        }

        kakaoButton.snp.makeConstraints {
            $0.width.height.equalTo(screenWidth * 0.15 * sizeFactor)
        }

        googleButton.snp.makeConstraints {
            $0.width.height.equalTo(screenWidth * 0.15 * sizeFactor)
        }

        loginButtonStackView.snp.makeConstraints {
            $0.top.equalTo(loginGuideLabel.snp.bottom).offset(screenHeight * 0.01 * sizeFactor)
            $0.centerX.equalToSuperview()
        }

        setUpScrollViewItems()
    }

    private func setUpScrollViewItems() {
        view.layoutIfNeeded()
        for page in pages {
            let image = UIImage.gifImageWithName(page.image)
            let imageView = UIImageView(image: image)
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.equalTo(scrollWidth)
                $0.height.equalTo(scrollHeight)
                $0.leading.equalTo(scrollView.snp.leading)
                    .offset(scrollView.bounds.width * CGFloat(page.rawValue))
            }
        }
    }

    private func setUpObjects() {
        stepLabel.text = pages[currentIndex].headline
        titleBoldLabel.text = pages[currentIndex].boldTitle
        titleRegularLabel.text = pages[currentIndex].regularTitle
    }

    @objc
    func tapGoogleSignInView(_ sender: Any) {
        loginViewModel.authProvider = .google
    }

    @objc
    func tapKakaoSignInView(_ sender: Any) {
        loginViewModel.authProvider = .kakao
    }

    @objc
    func tapAppleSignInView(_ sender: Any) {
        loginViewModel.authProvider = .apple
    }
}

enum LoginPages: Int, CaseIterable {
    case pageZero = 0
    case pageFirst = 1
    case pageSecond = 2

    var headline: String {
        switch self {
        case .pageZero: return "Step1"
        case .pageFirst: return "Step2"
        case .pageSecond: return "Fin"
        }
    }

    var boldTitle: String {
        switch self {
        case .pageZero: return "대형"
        case .pageFirst: return "인물"
        case .pageSecond: return "디렉팅"
        }
    }

    var regularTitle: String {
        switch self {
        case .pageZero: return "을 선택하고"
        case .pageFirst: return "을 지정하면"
        case .pageSecond: return " 준비 완료!"
        }
    }

    var image: String {
        switch self {
        case .pageZero: return "login1"
        case .pageFirst: return "login2"
        case .pageSecond: return "login3"
        }
    }
}

extension AuthViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageNumber)
        currentIndex = Int(pageNumber)

    }
}
