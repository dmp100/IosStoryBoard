//
//  HomeViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/20/25.
//
import Supabase
import UIKit

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var welcomeContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gratitudeContainer: UIView!
    @IBOutlet weak var gratitudeTitle: UILabel!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyling()
        setupTextViewDelegates()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }

    // MARK: - Setup Methods
    private func setupStyling() {
        // 전체 배경색
        view.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 254/255, alpha: 1.0)
        title = "홈"

        // Navigation Bar 스타일링
        setupNavigationBar()

        // Welcome Container 스타일링
        setupWelcomeContainer()

        // Gratitude Container 스타일링
        setupGratitudeContainer()

        // TextViews 스타일링
        setupTextViews()

        // Save Button 스타일링
        setupSaveButton()
    }

    private func setupNavigationBar() {
        // Navigation Bar 색상 설정
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0),
                .font: UIFont.pretendardSemiBold(size: 17)
            ]
        }
    }

    private func setupWelcomeContainer() {
        // Welcome Container 기본 스타일
        welcomeContainer.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        welcomeContainer.layer.cornerRadius = 16
        welcomeContainer.clipsToBounds = true

        // Title Label
        titleLabel.text = "오늘도 감사한 하루"
        titleLabel.font = UIFont.pretendardBold(size: 24)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0

        // Date Label
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        dateLabel.text = formatter.string(from: Date())
        dateLabel.font = UIFont.pretendardMedium(size: 16)
        dateLabel.textColor = .white
        dateLabel.alpha = 0.9
    }

    private func setupGradient() {
        // 그라데이션 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0).cgColor,
            UIColor(red: 48/255, green: 209/255, blue: 88/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = welcomeContainer.bounds
        gradientLayer.cornerRadius = 16

        // 기존 그라데이션 레이어 제거 후 새로 추가
        welcomeContainer.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        welcomeContainer.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupGratitudeContainer() {
        // Gratitude Container 스타일
        gratitudeContainer.backgroundColor = .white
        gratitudeContainer.layer.cornerRadius = 16
        gratitudeContainer.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.1).cgColor
        gratitudeContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        gratitudeContainer.layer.shadowRadius = 12
        gratitudeContainer.layer.shadowOpacity = 1.0

        // Gratitude Title
        gratitudeTitle.text = "오늘의 감사 3가지"
        gratitudeTitle.font = UIFont.pretendardSemiBold(size: 18)
        gratitudeTitle.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)
    }

    private func setupTextViews() {
        let placeholders = [
            "첫 번째로 감사한 일",
            "두 번째로 감사한 일",
            "세 번째로 감사한 일"
        ]

        let textViews = [textView1, textView2, textView3]

        for (index, textView) in textViews.enumerated() {
            guard let textView = textView else { continue }

            // 기본 스타일
            textView.backgroundColor = UIColor(red: 240/255, green: 255/255, blue: 244/255, alpha: 1.0)
            textView.layer.cornerRadius = 12
            textView.layer.borderWidth = 2
            textView.layer.borderColor = UIColor(red: 230/255, green: 247/255, blue: 230/255, alpha: 1.0).cgColor
            textView.font = UIFont.pretendardRegular(size: 16)
            textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

            // Placeholder 설정
            textView.text = placeholders[index]
            textView.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
            textView.tag = index + 1

            // 키보드 설정
            textView.autocapitalizationType = .sentences
            textView.autocorrectionType = .yes
            textView.returnKeyType = .default
        }
    }

    private func setupSaveButton() {
        // LoginViewController와 동일한 스타일 적용
        saveButton.setTitle("감사일기 저장하기", for: .normal)
        saveButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0) // 진초록색 (LoginBtn과 동일)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.pretendardSemiBold(size: 17)
        saveButton.layer.cornerRadius = 8 // LoginBtn과 동일한 8px
        saveButton.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0) // 눌렀을 때 밝은 초록색

        // 버튼 액션 연결
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    private func setupTextViewDelegates() {
        textView1.delegate = self
        textView2.delegate = self
        textView3.delegate = self
    }

    // MARK: - Actions
    @objc private func saveButtonTapped() {
        print("감사일기 저장 버튼 탭됨")

        var gratitudeEntries: [GratitudeDiaryEntry] = []
        let textViews = [textView1, textView2, textView3]

        for textView in textViews {
            guard let textView = textView else { continue }
            if !textView.text.isEmpty && !textView.text.contains("적어보세요") {
                guard let userUUID = supabase.auth.currentUser?.id else {
                    showAlert(message: "로그인이 필요합니다.")
                    return
                }
                let userIdString = userUUID.uuidString
                let entry = GratitudeDiaryEntry(user_id: userIdString, content: textView.text)
                gratitudeEntries.append(entry)
            }
        }

        if gratitudeEntries.isEmpty {
            showAlert(message: "감사한 일을 하나 이상 적어주세요.")
            return
        }

        Task {
            do {
                let _ = try await supabase
                    .from("gratitude_diaries")
                    .insert(gratitudeEntries)
                    .execute()


                showAlert(message: "감사일기가 저장되었습니다! 🌱")
                clearTextViews()
            } catch {
                print("저장 오류:", error.localizedDescription)
                showAlert(message: "감사일기 저장 중 오류가 발생했습니다.")
            }
        }
    }


    private func clearTextViews() {
        let placeholders = [
            "첫 번째로 감사한 일을 적어보세요...",
            "두 번째로 감사한 일을 적어보세요...",
            "세 번째로 감사한 일을 적어보세요..."
        ]

        let textViews = [textView1, textView2, textView3]

        for (index, textView) in textViews.enumerated() {
            guard let textView = textView else { continue }
            textView.text = placeholders[index]
            textView.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
        }
    }

    private func showAlert(message: String) {
        // LoginViewController와 동일한 showAlert 방식
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension HomeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Placeholder 텍스트인 경우 지우기
        if textView.textColor == UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0) {
            textView.text = ""
            textView.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // 텍스트가 비어있으면 placeholder 복원
        if textView.text.isEmpty {
            let placeholders = [
                "첫 번째로 감사한 일을 적어보세요...",
                "두 번째로 감사한 일을 적어보세요...",
                "세 번째로 감사한 일을 적어보세요..."
            ]

            textView.text = placeholders[textView.tag - 1]
            textView.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 글자 수 제한 (선택사항)
        let maxLength = 50
        let currentText = textView.text ?? ""
        let newLength = currentText.count + text.count - range.length
        return newLength <= maxLength
    }
}
