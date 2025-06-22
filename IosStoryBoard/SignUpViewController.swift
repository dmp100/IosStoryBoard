//
//  SignUpViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/22/25.
//

import UIKit
import Supabase

class SignUpViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton! // 뒤로가기 버튼 추가
    @IBOutlet weak var titleLabel: UILabel! // 타이틀 라벨 추가
    @IBOutlet weak var mainIcon: UIImageView! // 아이콘 추가

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpViewController viewDidLoad 호출됨")

        // IBOutlet 연결 상태 확인
        checkIBOutletConnections()
        setupUI()
        setupLayout()
    }

    private func checkIBOutletConnections() {
        print("=== IBOutlet 연결 상태 확인 ===")
        print("emailTextField: \(emailTextField != nil ? "✅ 연결됨" : "❌ 연결 안됨")")
        print("passwordTextField: \(passwordTextField != nil ? "✅ 연결됨" : "❌ 연결 안됨")")
        print("signUpButton: \(signUpButton != nil ? "✅ 연결됨" : "❌ 연결 안됨")")
        print("loadingIndicator: \(loadingIndicator != nil ? "✅ 연결됨" : "❌ 연결 안됨")")
        print("backButton: \(backButton != nil ? "✅ 연결됨" : "❌ 연결 안됨")")
        print("titleLabel: \(titleLabel != nil ? "✅ 연결됨" : "❌ 연결 안됨")")
        print("mainIcon: \(mainIcon != nil ? "✅ 연결됨" : "❌ 연결 안됨")")
        print("==============================")
    }

    // MARK: - UI Setup
    private func setupUI() {
        print("setupUI 호출됨")

        // 배경 설정
        view.backgroundColor = .systemBackground

        // 메인 아이콘 설정 (로그인과 동일)
        if let mainIcon = mainIcon {
            mainIcon.image = UIImage(named: "Logo.png")
            mainIcon.contentMode = .scaleAspectFit
            mainIcon.backgroundColor = .clear
            mainIcon.layer.cornerRadius = 20
            mainIcon.clipsToBounds = true
        }

        // 타이틀 설정
        if let titleLabel = titleLabel {
            titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            titleLabel.text = "회원가입"
            titleLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
            titleLabel.textAlignment = .center
        }

        // 이메일 텍스트 필드 설정 (로그인과 동일한 스타일)
        emailTextField.placeholder = "이메일을 입력하세요"
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .systemGray6
        emailTextField.layer.cornerRadius = 8
        emailTextField.clearButtonMode = .whileEditing

        // 비밀번호 텍스트 필드 설정 (로그인과 동일한 스타일)
        passwordTextField.placeholder = "비밀번호를 입력하세요 (6자 이상)"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.clearButtonMode = .whileEditing

        // 회원가입 버튼 설정 (로그인 버튼과 동일한 스타일)
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0) // 진초록색
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 8
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        // 뒤로가기 버튼 설정
        if let backButton = backButton {
            backButton.setTitle("로그인으로 돌아가기", for: .normal)
            backButton.setTitleColor(UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0), for: .normal) // 진초록색
            backButton.backgroundColor = .clear
            backButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }

        // 로딩 인디케이터 설정
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.stopAnimating()
        loadingIndicator.color = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)

        print("setupUI 완료")
    }

    private func setupLayout() {
        // Auto Layout 설정 (스토리보드에서 하지 않았다면)
        guard let mainIcon = mainIcon, let titleLabel = titleLabel, let backButton = backButton else {
            print("일부 UI 요소가 nil입니다. 스토리보드에서 제약 조건을 설정하거나 IBOutlet을 연결하세요.")
            return
        }

        // translatesAutoresizingMaskIntoConstraints 설정
        mainIcon.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 로고 - 상단에서 120px 떨어진 위치, 중앙 정렬
            mainIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            mainIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainIcon.widthAnchor.constraint(equalToConstant: 60),
            mainIcon.heightAnchor.constraint(equalToConstant: 60),

            // 타이틀 - 로고 아래 20px
            titleLabel.topAnchor.constraint(equalTo: mainIcon.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // 이메일 필드 - 타이틀 아래 50px
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 280),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            // 비밀번호 필드 - 이메일 필드 아래 16px
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 280),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            // 회원가입 버튼 - 비밀번호 필드 아래 24px
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 280),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),

            // 로딩 인디케이터 - 회원가입 버튼 중앙
            loadingIndicator.centerXAnchor.constraint(equalTo: signUpButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor),

            // 뒤로가기 버튼 - 회원가입 버튼 아래 16px
            backButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - IBActions
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("🔥 signUpButtonTapped 호출됨!")
        print("이메일: \(emailTextField.text ?? "nil")")
        print("비밀번호: \(passwordTextField.text ?? "nil")")

        signUpUser()
    }

    @objc private func backButtonTapped() {
        print("뒤로가기 버튼 탭됨")
        dismiss(animated: true)
    }

    // MARK: - Sign Up Logic
    private func signUpUser() {
        print("signUpUser 메서드 시작")

        // 입력값 검증
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("입력값 검증 실패")
            showAlert(title: "입력 오류", message: "이메일과 비밀번호를 모두 입력해주세요.")
            return
        }

        print("입력값 검증 성공 - 이메일: \(email)")

        // 간단한 이메일 형식 검사
        guard email.contains("@") && email.contains(".") else {
            print("이메일 형식 검증 실패")
            showAlert(title: "입력 오류", message: "올바른 이메일 형식을 입력해주세요.")
            return
        }

        // 비밀번호 길이 검사
        guard password.count >= 6 else {
            print("비밀번호 길이 검증 실패")
            showAlert(title: "입력 오류", message: "비밀번호는 6자 이상이어야 합니다.")
            return
        }

        print("모든 검증 통과, 임시 회원가입 처리")
        showLoading(true)

        // 임시로 2초 후 성공 처리 (실제 Supabase 호출 비활성화)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showLoading(false)
            self?.showAlert(title: "회원가입 완료", message: "회원가입이 완료되었습니다! (테스트 모드)") {
                // 임시로 이전 화면으로 돌아가기
                self?.dismiss(animated: true)
            }
        }

        // 실제 Supabase 회원가입 코드 (주석 처리)

        Task {
            do {
                let response = try await supabase.auth.signUp(
                    email: email,
                    password: password
                )

                print("Supabase 응답 성공: \(response)")

                await MainActor.run {
                    showLoading(false)
                    showAlert(title: "회원가입 완료", message: "회원가입이 완료되었습니다!") { [weak self] in
                        self?.dismiss(animated: true) // 로그인 화면으로 돌아감
                    }
                }

            } catch {
                print("Supabase 에러: \(error)")
                await MainActor.run {
                    showLoading(false)
                    showAlert(title: "회원가입 실패", message: "회원가입에 실패했습니다. 다시 시도해주세요.\n에러: \(error.localizedDescription)")
                }
            }
        }

    }

    // MARK: - Navigation
//    private func navigateToMainScreen() {
//        print("메인 화면으로 이동 시도")
//
//        // ChatViewController로 이동 (메인 화면)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
//
//            // 네비게이션 스택을 완전히 교체
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = windowScene.windows.first {
//                let navController = UINavigationController(rootViewController: chatVC)
//                window.rootViewController = navController
//                window.makeKeyAndVisible()
//            }
//        } else {
//            print("ChatViewController를 찾을 수 없습니다")
//        }
//    }

    // MARK: - Helper Methods
    private func showLoading(_ show: Bool) {
        print("로딩 상태 변경: \(show)")
        signUpButton.isEnabled = !show
        if show {
            loadingIndicator.startAnimating()
            signUpButton.setTitle("", for: .normal) // 로딩 중에는 텍스트 숨김
        } else {
            loadingIndicator.stopAnimating()
            signUpButton.setTitle("회원가입", for: .normal) // 로딩 완료 후 텍스트 복원
        }
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        print("알림 표시: \(title) - \(message)")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
