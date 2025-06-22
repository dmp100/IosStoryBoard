//
//  ChatDetailViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/22/25.
//

import UIKit

class ChatDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var additionalLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var aiMessageLabel1: UILabel!
    @IBOutlet weak var userMessageLabel1: UILabel!

    // MARK: - Properties
    var selectedCharacter: Character?
    private var chatMessages: [ChatMessage] = []

    // OpenAI 설정
    private let apiKey = ""
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    private var conversationHistory: [[String: Any]] = []
    private var currentGratitudeDiary: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupMessageLabels()

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

        // 비동기 데이터 로딩
        Task {
            await loadGratitudeSummary()
            await generateInitialAIMessage()
        }
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

// MARK: - OpenAI API 연동 (직접 HTTP 요청)
extension ChatDetailViewController {

    private func getCharacterSystemPrompt() -> String {
            guard let character = selectedCharacter else {
                return "당신은 친근하고 따뜻한 AI 어시스턴트입니다."
            }

            switch character.id {
            case "sakura":
                return """
                당신은 사쿠라입니다. 따뜻하고 공감적인 감정 상담사로서 다음과 같이 행동합니다:
                
                성격과 말투:
                - 부드럽고 포근한 말투로 대화
                - 사용자의 감정에 깊이 공감하고 이해
                - 따뜻한 격려와 위로를 제공
                - 자연스럽고 친근한 표현 사용
                - 이모지를 적절히 사용 🌸
                
                대화 방식:
                - 반드시 감사일기 내용을 먼저 읽고 구체적으로 언급하며 인사
                - 감사일기의 각 항목에 대해 공감적 반응
                - 사용자의 감정을 세심하게 파악하고 반영
                - 따뜻한 질문으로 대화를 이어나가기
                """
            case "owl":
                return """
                당신은 올빼미 박사입니다. 논리적이고 현명한 심리 상담사로서 다음과 같이 행동합니다:
                
                성격과 말투:
                - 차분하고 현명한 말투로 대화
                - 분석적이면서도 따뜻한 접근
                - 심리학적 관점에서의 통찰 제공
                - 체계적이고 논리적인 조언
                - 이모지를 절제있게 사용 🦉
                
                대화 방식:
                - 반드시 감사일기 내용을 먼저 분석적으로 읽고 언급하며 인사
                - 감사일기에서 패턴이나 의미를 찾아 설명
                - 심리적 관점에서 감사의 효과나 의미 해석
                - 깊이 있는 질문으로 자기 성찰 유도
                """
            default:
                return "당신은 친근하고 따뜻한 AI 어시스턴트입니다."
            }
        }

        private func generateInitialAIMessage() async {
            let characterName = selectedCharacter?.name ?? "캐릭터"
            let systemPrompt = getCharacterSystemPrompt()

            let userPrompt = """
            안녕하세요! 저는 \(characterName)입니다.
            
            사용자가 오늘 작성한 감사일기입니다:
            \(currentGratitudeDiary)
            
            위의 감사일기 내용을 구체적으로 읽고 언급하면서, 당신의 캐릭터 성격에 맞는 따뜻한 첫 인사말을 해주세요. 
            감사일기의 각 항목에 대해 공감하며 대화를 시작해주세요.
            """

            // 대화 기록 초기화
            conversationHistory = [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ]

            await getChatResponse()
        }
    private func generateAIResponse(to userMessage: String) async {
        // 사용자 메시지를 대화 기록에 추가
        conversationHistory.append(["role": "user", "content": userMessage])

        await getChatResponse()
    }

    private func getChatResponse() async {
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": conversationHistory,
            "temperature": 0.8,
            "max_tokens": 500
        ]

        guard let url = URL(string: apiURL) else {
            await MainActor.run {
                showErrorMessage()
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

            let (data, _) = try await URLSession.shared.data(for: request)

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {

                print("✅ AI 응답: \(content)")

                // AI 응답을 대화 기록에 추가
                conversationHistory.append(["role": "assistant", "content": content])

                await MainActor.run {
                    let aiMessage = ChatMessage(text: content, isFromUser: false, timestamp: Date())
                    self.addMessage(aiMessage)
                }
            } else {
                print("❌ AI 응답 파싱 실패")
                await MainActor.run {
                    showErrorMessage()
                }
            }

        } catch {
            print("❌ AI 응답 생성 실패: \(error)")
            await MainActor.run {
                showErrorMessage()
            }
        }
    }

    // 헬퍼 함수
    private func showErrorMessage() {
        let errorMessage = "죄송해요, 잠시 문제가 있는 것 같아요. 다시 말씀해 주시겠어요?"
        let aiMessage = ChatMessage(text: errorMessage, isFromUser: false, timestamp: Date())
        addMessage(aiMessage)
    }
}

// MARK: - Data Loading
extension ChatDetailViewController {

    private func loadGratitudeSummary() async {
        // 임시로 샘플 데이터 사용 (Supabase 연동 시 교체)
        currentGratitudeDiary = """
        1. 아침에 따뜻한 햇살이 창문을 통해 들어와서 기분이 좋았다
        2. 동료가 맛있는 커피를 사주어서 감사했다
        3. 가족들과 함께 저녁식사를 할 수 있어서 행복했다
        """

        await MainActor.run {
            summaryLabel.text = "📝 오늘의 감사일기\n\n\(currentGratitudeDiary)"
            additionalLabel.text = "캐릭터가 감사일기를 바탕으로 대화를 시작합니다"
            additionalLabel.font = UIFont.pretendardMedium(size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
            additionalLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
            additionalLabel.textAlignment = .center
        }

        /* Supabase 연동 코드 (필요시 활성화)
        guard let userId = try? await SupabaseManager.shared.client.auth.user().id.uuidString else {
            print("❌ 사용자 정보를 가져올 수 없습니다")
            return
        }

        do {
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

            let formatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")

            let startDate = formatter.string(from: today)
            let endDate = formatter.string(from: tomorrow)

            // Supabase에서 오늘의 감사일기 조회
            let response: [GratitudeDiaryResponse] = try await SupabaseManager.shared.client
                .from("gratitude_diary")
                .select()
                .eq("user_id", value: userId)
                .gte("created_at", value: startDate)
                .lt("created_at", value: endDate)
                .order("created_at", ascending: false)
                .execute()
                .value

            print("✅ 감사일기 조회 완료: \(response.count)개")

            await MainActor.run {
                if response.isEmpty {
                    self.currentGratitudeDiary = "오늘은 아직 감사일기를 작성하지 않았습니다."
                    self.summaryLabel.text = "📝 오늘의 감사일기\n\n아직 작성된 감사일기가 없습니다.\n홈 탭에서 감사일기를 작성해보세요! 😊"
                } else {
                    var gratitudeText = ""
                    for (index, entry) in response.prefix(3).enumerated() {
                        gratitudeText += "\(index + 1). \(entry.content)\n"
                    }

                    self.currentGratitudeDiary = gratitudeText
                    self.summaryLabel.text = "📝 오늘의 감사일기\n\n\(gratitudeText)"
                }

                self.additionalLabel.text = "캐릭터가 감사일기를 바탕으로 대화를 시작합니다"
                self.additionalLabel.font = UIFont.pretendardMedium(size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
                self.additionalLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
                self.additionalLabel.textAlignment = .center
            }

        } catch {
            print("❌ 감사일기 조회 실패: \(error)")
            await MainActor.run {
                self.currentGratitudeDiary = "감사일기를 불러오는 중 오류가 발생했습니다."
                self.summaryLabel.text = "📝 오늘의 감사일기\n\n감사일기를 불러오는 중 오류가 발생했습니다."
            }
        }
        */
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
        // AI 메시지 Label 설정
        if let aiLabel = aiMessageLabel1 {
            aiLabel.isHidden = true
            aiLabel.numberOfLines = 0
            aiLabel.font = UIFont.pretendardMedium(size: 15) ?? UIFont.systemFont(ofSize: 15)
            aiLabel.layer.cornerRadius = 16
            aiLabel.layer.masksToBounds = true
            aiLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            aiLabel.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)
            aiLabel.textAlignment = .center
        }

        // 사용자 메시지 Label 설정
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

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
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

    private func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Chat Functions
extension ChatDetailViewController {

    private func addMessage(_ message: ChatMessage) {
        print("✅ 메시지 추가: \(message.text.prefix(30))... (사용자: \(message.isFromUser))")

        chatMessages.append(message)

        if message.isFromUser {
            if let userLabel = userMessageLabel1 {
                if !userLabel.isHidden {
                    createCopyLabel(from: userLabel)
                }
                userLabel.text = message.text
                userLabel.textAlignment = .center
                userLabel.isHidden = false
            }
        } else {
            if let aiLabel = aiMessageLabel1 {
                if !aiLabel.isHidden {
                    createCopyLabel(from: aiLabel)
                }
                aiLabel.text = message.text
                aiLabel.textAlignment = .center
                aiLabel.isHidden = false
            }
        }

        view.layoutIfNeeded()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom()
        }
    }

    private func createCopyLabel(from originalLabel: UILabel) {
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

        if let index = stackView.arrangedSubviews.firstIndex(of: originalLabel) {
            stackView.insertArrangedSubview(copyLabel, at: index)

            copyLabel.setContentHuggingPriority(.required, for: .vertical)
            copyLabel.setContentCompressionResistancePriority(.required, for: .vertical)

            NSLayoutConstraint.activate([
                copyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
                copyLabel.widthAnchor.constraint(lessThanOrEqualTo: stackView.widthAnchor, multiplier: 0.8),
                copyLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
            ])

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

        // OpenAI API로 응답 생성
        Task {
            await generateAIResponse(to: messageText)
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
