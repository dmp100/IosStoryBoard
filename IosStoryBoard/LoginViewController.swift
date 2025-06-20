//
//  ViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 3/20/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var EnterID: UITextField!
    @IBOutlet weak var EnterPassword: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var SignUPBtn: UIButton!
    @IBOutlet weak var AppTitle: UILabel!
    @IBOutlet weak var MainIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }

    func setupUI() {
        // 배경 설정
        view.backgroundColor = .systemBackground

        // Icon 설정
        MainIcon.image = UIImage(named: "Logo.png")
        MainIcon.contentMode = .scaleAspectFit
        MainIcon.backgroundColor = .clear
        MainIcon.layer.cornerRadius = 20
        MainIcon.clipsToBounds = true

        // 앱 타이틀 설정
        AppTitle.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        AppTitle.text = "dAIry"
        AppTitle.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        AppTitle.textAlignment = .center

        // 이메일 필드 설정
        EnterID.placeholder = "이메일을 입력하세요"
        EnterID.borderStyle = .roundedRect
        EnterID.backgroundColor = .systemGray6
        EnterID.layer.cornerRadius = 8

        // 비밀번호 필드 설정
        EnterPassword.placeholder = "비밀번호를 입력하세요"
        EnterPassword.borderStyle = .roundedRect
        EnterPassword.backgroundColor = .systemGray6
        EnterPassword.isSecureTextEntry = true
        EnterPassword.layer.cornerRadius = 8

        // 로그인 버튼 설정
        LoginBtn.setTitle("로그인", for: .normal)
        LoginBtn.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0) // 진초록색
        LoginBtn.setTitleColor(.white, for: .normal)
        LoginBtn.layer.cornerRadius = 8
        LoginBtn.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)

        // 로그인 버튼 액션 추가
        LoginBtn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        // 회원가입 버튼 설정
        SignUPBtn.setTitle("회원가입", for: .normal)
        SignUPBtn.setTitleColor(UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0), for: .normal) // 진초록색
        SignUPBtn.backgroundColor = .clear
        SignUPBtn.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)

        // 회원가입 버튼 액션 추가
        SignUPBtn.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    func setupLayout() {
        // 모든 요소들의 translatesAutoresizingMaskIntoConstraints를 false로 설정
        MainIcon.translatesAutoresizingMaskIntoConstraints = false
        AppTitle.translatesAutoresizingMaskIntoConstraints = false
        EnterID.translatesAutoresizingMaskIntoConstraints = false
        EnterPassword.translatesAutoresizingMaskIntoConstraints = false
        LoginBtn.translatesAutoresizingMaskIntoConstraints = false
        SignUPBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 로고 - 상단에서 120px 떨어진 위치, 중앙 정렬
            MainIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            MainIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            MainIcon.widthAnchor.constraint(equalToConstant: 80),
            MainIcon.heightAnchor.constraint(equalToConstant: 80),

            // 타이틀 - 로고 아래 20px
            AppTitle.topAnchor.constraint(equalTo: MainIcon.bottomAnchor, constant: 20),
            AppTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // 이메일 필드 - 타이틀 아래 60px
            EnterID.topAnchor.constraint(equalTo: AppTitle.bottomAnchor, constant: 60),
            EnterID.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            EnterID.widthAnchor.constraint(equalToConstant: 280),
            EnterID.heightAnchor.constraint(equalToConstant: 44),

            // 비밀번호 필드 - 이메일 필드 아래 16px
            EnterPassword.topAnchor.constraint(equalTo: EnterID.bottomAnchor, constant: 16),
            EnterPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            EnterPassword.widthAnchor.constraint(equalToConstant: 280),
            EnterPassword.heightAnchor.constraint(equalToConstant: 44),

            // 로그인 버튼 - 비밀번호 필드 아래 24px
            LoginBtn.topAnchor.constraint(equalTo: EnterPassword.bottomAnchor, constant: 24),
            LoginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            LoginBtn.widthAnchor.constraint(equalToConstant: 280),
            LoginBtn.heightAnchor.constraint(equalToConstant: 48),

            // 회원가입 버튼 - 로그인 버튼 아래 16px
            SignUPBtn.topAnchor.constraint(equalTo: LoginBtn.bottomAnchor, constant: 16),
            SignUPBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Button Actions
    @objc private func loginButtonTapped() {
        print("로그인 버튼 탭됨")

        // 간단한 검증 (실제로는 서버 통신)
        guard let email = EnterID.text, !email.isEmpty,
              let password = EnterPassword.text, !password.isEmpty else {
            showAlert(message: "이메일과 비밀번호를 입력해주세요.")
            return
        }

        // 임시로 바로 메인 화면으로 이동
        navigateToMainScreen()
    }

    @objc private func signUpButtonTapped() {
        print("회원가입 버튼 탭됨")
        // 회원가입 화면으로 이동하는 로직 추가
    }

    // MARK: - Navigation
    private func navigateToMainScreen() {
        print("로그인 성공 - 메인 화면으로 이동")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }

    // MARK: - Helper Methods
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
