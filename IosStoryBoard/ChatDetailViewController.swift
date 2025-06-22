
//
//  ChatDetailViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/22/25.
//

import UIKit

class ChatDetailViewController: UIViewController {

    // MARK: - IBOutlets (현재 스토리보드 구조에 맞춤)
    @IBOutlet weak var summaryLabel: UILabel!            // 상단 Label (감사일기 요약)
    @IBOutlet weak var additionalLabel: UILabel!         // 중간 Label (추가 정보)
    @IBOutlet weak var scrollView: UIScrollView!         // Scroll View
    @IBOutlet weak var stackView: UIStackView!           // Stack View
    @IBOutlet weak var inputContainer: UIView!           // Stack View 안의 View (입력 영역)
    @IBOutlet weak var chatTextField: UITextField!       // Round Style Text Field
    @IBOutlet weak var sendButton: UIButton!            // Button (→)

    // MARK: - 채팅 메시지 Label IBOutlets (2개만 사용)
    @IBOutlet weak var aiMessageLabel1: UILabel!         // AI 메시지용 Label
    @IBOutlet weak var userMessageLabel1: UILabel!       // 사용자 메시지용 Label

    // MARK: - Properties
    var selectedCharacter: Character?  // ✅ 이제 공통 Character 구조체 사용
    private var chatMessages: [ChatMessage] = []

    // ⚠️ ChatMessage 구조체 정의 제거 (Character.swift에 있음)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        loadGratitudeSummary()

        // 초기 Label 설정
        setupMessageLabels()

        // AI 첫 메시지 생성
        generateInitialAIMessage()

        // 키보드 노티피케이션 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarStyle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.scrollToBottom()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI Setup
extension ChatDetailViewController {

    private func setupUI() {
        view.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 254/255, alpha: 1.0)

        setupSummaryCard()
        setupChatArea()
        setupInputArea()
    }

    private func setupMessageLabels() {
        // AI 메시지 Label 설정 (완전 중앙 정렬)
        if let aiLabel = aiMessageLabel1 {
            aiLabel.isHidden = true
            aiLabel.numberOfLines = 0
            aiLabel.font = UIFont.pretendardMedium(size: 15) ?? UIFont.systemFont(ofSize: 15)
            aiLabel.layer.cornerRadius = 16
            aiLabel.layer.masksToBounds = true
            aiLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            aiLabel.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)
            aiLabel.textAlignment = .center

            // 패딩을 위한 inset 설정
            aiLabel.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0)

            // 예시 AI 메시지 추가
            aiLabel.text = "안녕하세요! 오늘 하루는 어떠셨나요? 😊"
            aiLabel.isHidden = false
        }

        // 사용자 메시지 Label 설정 (완전 중앙 정렬)
        if let userLabel = userMessageLabel1 {
            userLabel.isHidden = true
            userLabel.numberOfLines = 0
            userLabel.font = UIFont.pretendardMedium(size: 15) ?? UIFont.systemFont(ofSize: 15)
            userLabel.layer.cornerRadius = 16
            userLabel.layer.masksToBounds = true
            userLabel.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
            userLabel.textColor = .white
            userLabel.textAlignment = .center
        }
    }

    private func setupNavigationBar() {
        guard let character = selectedCharacter else {
            title = "대화 화면"
            return
        }

        title = "\(character.emoji) \(character.name)와 대화"
        setupNavigationBarStyle()
    }

    private func setupNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pretendardSemiBold(size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupSummaryCard() {
        guard summaryLabel != nil else { return }

        summaryLabel.backgroundColor = UIColor(red: 240/255, green: 255/255, blue: 244/255, alpha: 1.0)
        summaryLabel.layer.borderWidth = 2
        summaryLabel.layer.borderColor = UIColor(red: 230/255, green: 247/255, blue: 230/255, alpha: 1.0).cgColor
        summaryLabel.layer.cornerRadius = 12
        summaryLabel.font = UIFont.pretendardMedium(size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        summaryLabel.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)
        summaryLabel.numberOfLines = 0
        summaryLabel.textAlignment = .left
        summaryLabel.layer.masksToBounds = true
    }

    private func setupChatArea() {
        guard scrollView != nil, stackView != nil else { return }

        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 16
        scrollView.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.1).cgColor
        scrollView.layer.shadowOffset = CGSize(width: 0, height: 2)
        scrollView.layer.shadowRadius = 12
        scrollView.layer.shadowOpacity = 1.0

        // StackView 설정 - 중앙 정렬을 위해 alignment 변경
        stackView.axis = .vertical
        stackView.spacing = 12  // 간격을 조금 더 넓게
        stackView.alignment = .center  // 중앙 정렬로 변경
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
    }

    private func setupInputArea() {
        guard inputContainer != nil, chatTextField != nil, sendButton != nil else { return }

        inputContainer.backgroundColor = .white
        inputContainer.layer.cornerRadius = 12
        inputContainer.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.1).cgColor
        inputContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        inputContainer.layer.shadowRadius = 8
        inputContainer.layer.shadowOpacity = 1.0

        chatTextField.layer.borderWidth = 2
        chatTextField.layer.borderColor = UIColor(red: 230/255, green: 247/255, blue: 230/255, alpha: 1.0).cgColor
        chatTextField.layer.cornerRadius = 20
        chatTextField.font = UIFont.pretendardMedium(size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        chatTextField.placeholder = "메시지를 입력하세요..."
        chatTextField.delegate = self

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
        chatTextField.leftView = paddingView
        chatTextField.leftViewMode = .always

        sendButton.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        sendButton.layer.cornerRadius = 22
        sendButton.setTitle("→", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        sendButton.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.3).cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        sendButton.layer.shadowRadius = 4
        sendButton.layer.shadowOpacity = 1.0
    }
}

// MARK: - Data Loading
extension ChatDetailViewController {

    private func loadGratitudeSummary() {
        guard summaryLabel != nil, additionalLabel != nil else { return }

        let summaryTitle = "  📝 오늘의 감사일기\n\n"
        let sampleGratitude = """
          1. 아침에 따뜻한 햇살이 창문을 통해 들어와서 기분이 좋았다
          2. 동료가 맛있는 커피를 사주어서 감사했다
          3. 가족들과 함께 저녁식사를 할 수 있어서 행복했다
        """

        summaryLabel.text = summaryTitle + sampleGratitude

        additionalLabel.text = "캐릭터가 감사일기를 바탕으로 대화를 시작합니다"
        additionalLabel.font = UIFont.pretendardMedium(size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        additionalLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
        additionalLabel.textAlignment = .center
    }

    private func generateInitialAIMessage() {
        guard let character = selectedCharacter else {
            print("❌ selectedCharacter가 nil입니다")
            return
        }

        print("✅ AI 첫 메시지 생성 시작 - 캐릭터: \(character.name)")

        let initialMessage: String
        switch character.id {
        case "sakura":
            initialMessage = "안녕하세요! 🌸 오늘 작성하신 감사일기를 읽어보니 정말 따뜻한 하루를 보내셨네요. 특히 아침 햇살에 대한 감사가 인상적이었어요. 그때 어떤 기분이 드셨나요?"
        case "owl":
            initialMessage = "안녕하세요. 🦉 오늘의 감사일기를 분석해보니 인간관계와 자연에 대한 감사가 균형있게 표현되어 있습니다. 이러한 다양한 영역의 감사는 심리적 안정감을 높이는데 도움이 됩니다. 어떤 부분이 가장 의미있게 느껴지셨나요?"
        case "rabbit":
            initialMessage = "안녕하세요! 🐰 와~ 오늘 정말 멋진 하루를 보내셨네요! 햇살, 커피, 가족과의 시간까지! 이렇게 좋은 일들이 가득한 날이라니 정말 기분이 좋아집니다! 이 중에서 가장 기억에 남는 순간은 무엇인가요?"
        default:
            initialMessage = "안녕하세요! 오늘 작성하신 감사일기를 바탕으로 대화를 시작해보겠습니다."
        }

        print("✅ 생성된 메시지: \(initialMessage)")

        let aiMessage = ChatMessage(text: initialMessage, isFromUser: false, timestamp: Date())

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("✅ AI 메시지 추가 실행")
            self.addMessage(aiMessage)
        }
    }
}

// MARK: - Chat Functions (완전 중앙 정렬 버전)
extension ChatDetailViewController {

    private func addMessage(_ message: ChatMessage) {
        print("✅ 메시지 추가: \(message.text.prefix(30))... (사용자: \(message.isFromUser))")

        chatMessages.append(message)

        if message.isFromUser {
            // 사용자 메시지 처리
            if let userLabel = userMessageLabel1 {
                // 기존에 표시된 메시지가 있으면 복사본 생성
                if !userLabel.isHidden {
                    createCopyLabel(from: userLabel)
                }

                // 새 메시지 표시 (깔끔한 중앙 정렬)
                userLabel.text = message.text
                userLabel.textAlignment = .center
                userLabel.isHidden = false
            }
        } else {
            // AI 메시지 처리
            if let aiLabel = aiMessageLabel1 {
                // 기존에 표시된 메시지가 있으면 복사본 생성
                if !aiLabel.isHidden {
                    createCopyLabel(from: aiLabel)
                }

                // 새 메시지 표시 (깔끔한 중앙 정렬)
                aiLabel.text = message.text
                aiLabel.textAlignment = .center
                aiLabel.isHidden = false
            }
        }

        // 레이아웃 업데이트
        view.layoutIfNeeded()

        // 스크롤을 맨 아래로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom()
        }
    }

    private func createCopyLabel(from originalLabel: UILabel) {
        // 기존 Label의 복사본 생성
        let copyLabel = UILabel()
        copyLabel.text = originalLabel.text
        copyLabel.numberOfLines = originalLabel.numberOfLines
        copyLabel.font = originalLabel.font
        copyLabel.textColor = originalLabel.textColor
        copyLabel.backgroundColor = originalLabel.backgroundColor
        copyLabel.textAlignment = .center
        copyLabel.layer.cornerRadius = originalLabel.layer.cornerRadius
        copyLabel.layer.masksToBounds = originalLabel.layer.masksToBounds
        copyLabel.translatesAutoresizingMaskIntoConstraints = false

        // StackView에서 원본 Label의 위치 찾기
        if let index = stackView.arrangedSubviews.firstIndex(of: originalLabel) {
            // 원본 Label 위치에 복사본 삽입
            stackView.insertArrangedSubview(copyLabel, at: index)

            // 컨텐츠에 맞는 크기 설정
            copyLabel.setContentHuggingPriority(.required, for: .vertical)
            copyLabel.setContentCompressionResistancePriority(.required, for: .vertical)

            // 중앙 정렬을 위한 제약 조건 개선
            NSLayoutConstraint.activate([
                // 최소 높이 설정 (패딩 포함)
                copyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
                // 최대 너비를 80%로 제한하여 말풍선 느낌
                copyLabel.widthAnchor.constraint(lessThanOrEqualTo: stackView.widthAnchor, multiplier: 0.8),
                // 최소 너비 설정으로 너무 작아지지 않게
                copyLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
            ])

            // 텍스트 내부 패딩을 위한 inset 설정
            copyLabel.layer.masksToBounds = true
        }
    }

    private func scrollToBottom() {
        let contentHeight = scrollView.contentSize.height
        let boundsHeight = scrollView.bounds.height
        let contentInsetBottom = scrollView.contentInset.bottom

        if contentHeight + contentInsetBottom > boundsHeight {
            let bottomOffset = CGPoint(
                x: 0,
                y: contentHeight - boundsHeight + contentInsetBottom
            )
            scrollView.setContentOffset(bottomOffset, animated: true)
            print("✅ 스크롤 이동 완료 - offset: \(bottomOffset.y)")
        } else {
            print("ℹ️ 스크롤 불필요 (컨텐츠가 화면보다 작음)")
        }
    }

    @objc private func sendButtonTapped() {
        guard let messageText = chatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !messageText.isEmpty else { return }

        let userMessage = ChatMessage(text: messageText, isFromUser: true, timestamp: Date())
        addMessage(userMessage)

        chatTextField.text = ""

        generateAIResponse(to: messageText)
    }

    private func generateAIResponse(to userMessage: String) {
        guard let character = selectedCharacter else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let responses = [
                "네, 그런 마음이 드셨군요. \(character.emoji) 더 자세히 말씀해 주시겠어요?",
                "정말 소중한 경험이셨네요. 그때의 감정을 조금 더 표현해보세요.",
                "그 순간이 왜 특별하게 느껴졌을까요? \(character.emoji)",
                "좋은 이야기네요! 비슷한 경험이 또 있으신가요?"
            ]

            let randomResponse = responses.randomElement() ?? "네, 이해합니다."
            let aiMessage = ChatMessage(text: randomResponse, isFromUser: false, timestamp: Date())
            self.addMessage(aiMessage)
        }
    }
}

// MARK: - Keyboard Handling
extension ChatDetailViewController {

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height

            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentInset.bottom = keyboardHeight
                self.scrollView.scrollIndicatorInsets.bottom = keyboardHeight
                self.scrollToBottom()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.scrollIndicatorInsets.bottom = 0
        }
    }
}

// MARK: - UITextFieldDelegate
extension ChatDetailViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
}
