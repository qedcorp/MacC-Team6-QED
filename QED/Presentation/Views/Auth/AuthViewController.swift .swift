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
    @Binding var authProvider: AuthProviderType
    private var pages = LoginPages.allCases
    private var currentIndex = 0 {
        didSet { setUpObjects() }
    }
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let scrollWidth: CGFloat
    let scrollHeight: CGFloat

    init(authProvider: Binding<AuthProviderType>) {
        scrollWidth = screenWidth * 0.66
        scrollHeight = screenHeight * 0.43
        self._authProvider = authProvider
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
        object.font = .systemFont(ofSize: 20)
        return object
    }()

    lazy var titleBoldLabel: UILabel = {
        let object = UILabel()
        object.font = .boldSystemFont(ofSize: 30)
        object.textColor = .white
        return object
    }()

    lazy var titleRegularLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 30)
        object.textColor = .white
        return object
    }()

    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleBoldLabel, titleRegularLabel])
        return stackView
    }()

    lazy var scrollView: UIScrollView = {
        let object = UIScrollView()
        object.contentSize = CGSize(width: Int(scrollWidth) * pages.count, height: Int(scrollHeight))
        object.delegate = self
        object.alwaysBounceVertical = false
        object.showsHorizontalScrollIndicator = false
        object.isPagingEnabled = true
        object.bounces = false
        object.layer.cornerRadius = 10
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
        stackView.spacing = 8
        return stackView
    }()

    lazy var loginGuideLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 15)
        object.textColor = .white
        object.text = "SNS 계정으로 간편 가입하기"
        return object
    }()

    lazy var appleButton: UIButton = {
        let object = UIButton()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAppleSignInView(_:)))
        object.backgroundColor = .white
        object.layer.cornerRadius = screenWidth * 0.075
        object.setImage(UIImage(named: "apple_login"), for: .normal)
        object.addGestureRecognizer(gesture)
        return object
    }()

    lazy var kakaoButton: UIButton = {
        let object = UIButton()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapKakaoSignInView(_:)))
        object.backgroundColor = UIColor.KakaoYellow
        object.layer.cornerRadius = screenWidth * 0.075
        object.setImage(UIImage(named: "kakao_login"), for: .normal)
        object.addGestureRecognizer(gesture)
        return object
    }()

    lazy var googleButton: UIButton = {
        let object = UIButton()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGoogleSignInView(_:)))
        object.backgroundColor = .white
        object.layer.cornerRadius = screenWidth * 0.075
        object.setImage(UIImage(named: "google_login"), for: .normal)
        object.addGestureRecognizer(gesture)
        return object
    }()

    lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appleButton, kakaoButton, googleButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()

    private func setUpUI() {
        view.backgroundColor = .black
        view.addSubview(stepLabel)
        view.addSubview(titleBoldLabel)
        view.addSubview(titleRegularLabel)
        view.addSubview(titleStackView)
        view.addSubview(loginInfoStackView)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(loginGuideLabel)
        view.addSubview(appleButton)
        view.addSubview(kakaoButton)
        view.addSubview(googleButton)
        view.addSubview(loginButtonStackView)

        loginInfoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(screenHeight * 0.14)
            $0.left.equalToSuperview().inset(66)
        }

        scrollView.snp.makeConstraints {
            $0.width.equalTo(scrollWidth)
            $0.height.equalTo(scrollHeight)
            $0.top.equalTo(loginInfoStackView.snp.bottom).offset(screenHeight * 0.03)
            $0.centerX.equalToSuperview()
        }

        view.layoutIfNeeded()

        for page in pages {
            let image = UIImage(named: page.image)
            let imageView = UIImageView(image: image)
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
                $0.height.equalTo(scrollView.snp.height)
                $0.leading.equalTo(scrollView.snp.leading)
                    .offset(scrollView.bounds.width * CGFloat(page.rawValue))
            }
        }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(screenHeight * 0.025)
            $0.centerX.equalToSuperview()
        }

        loginGuideLabel.snp.makeConstraints {
            $0.bottom.equalTo(loginButtonStackView.snp.top).offset(-screenHeight * 0.02)
            $0.centerX.equalToSuperview()
        }

        appleButton.snp.makeConstraints {
            $0.width.height.equalTo(screenWidth * 0.15)
        }

        kakaoButton.snp.makeConstraints {
            $0.width.height.equalTo(screenWidth * 0.15)
        }

        googleButton.snp.makeConstraints {
            $0.width.height.equalTo(screenWidth * 0.15)
        }

        loginButtonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-screenHeight * 0.1)
            $0.centerX.equalToSuperview()
        }

    }

    private func setUpObjects() {
        stepLabel.text = pages[currentIndex].headline
        titleBoldLabel.text = pages[currentIndex].boldTitle
        titleRegularLabel.text = pages[currentIndex].regularTitle
    }

    @objc
    func tapGoogleSignInView(_ sender: Any) {
        authProvider = .google
    }

    @objc
    func tapKakaoSignInView(_ sender: Any) {
        authProvider = .kakao
    }

    @objc
    func tapAppleSignInView(_ sender: Any) {
        authProvider = .apple
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
        case .pageZero: return "MockMain"
        case .pageFirst: return "splash"
        case .pageSecond: return "background"
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
