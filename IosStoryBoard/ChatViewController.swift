//
//  ChatViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/20/25.
//

import UIKit

class ChatViewController: UIViewController {

    // MARK: - IBOutlets (현재 스토리보드 구조에 맞춤)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    // 첫 번째 View - 전체 캐릭터 선택 컨테이너
    @IBOutlet weak var characterSelectorContainer: UIView!
    @IBOutlet weak var selectorTitleLabel: UILabel!

    // 캐릭터 컨테이너들 (UIView 유지)
    @IBOutlet weak var character1Container: UIView!
    @IBOutlet weak var character1NameLabel: UILabel!
    @IBOutlet weak var character1ImageView: UIImageView!
    @IBOutlet weak var character1DescLabel: UILabel!
    @IBOutlet weak var character1Button: UIButton!  // "대화" 버튼

    @IBOutlet weak var character2Container: UIView!
    @IBOutlet weak var character2NameLabel: UILabel!
    @IBOutlet weak var character2ImageView: UIImageView!
    @IBOutlet weak var character2DescLabel: UILabel!
    @IBOutlet weak var character2Button: UIButton!  // "대화" 버튼

    @IBOutlet weak var character3Container: UIView!
    @IBOutlet weak var character3NameLabel: UILabel!
    @IBOutlet weak var character3ImageView: UIImageView!
    @IBOutlet weak var character3DescLabel: UILabel!
    @IBOutlet weak var character3Button: UIButton!  // "대화" 버튼

    // 하단 팁 영역
    @IBOutlet weak var tipContainer: UIView!
    @IBOutlet weak var tipTitleLabel: UILabel!
    @IBOutlet weak var tipDescLabel: UILabel!

    // MARK: - Properties
    private var selectedCharacter: Character?
    private var chatMessages: [ChatMessage] = []

    // MARK: - Character Data
    private let characters: [Character] = [
        Character(
            id: "sakura",
            emoji: "🌸",
            name: "사쿠라",
            description: "따뜻하고 공감적인 성격으로 감정을 세심하게 읽어주는 친구",
            assistantID: "asst_sakura123"
        ),
        Character(
            id: "owl",
            emoji: "🦉",
            name: "올빼미 박사",
            description: "논리적이고 체계적인 사고로 깊이 있는 대화를 나누는 현명한 상담사",
            assistantID: "asst_owl456"
        ),
        Character(
            id: "rabbit",
            emoji: "🐰",
            name: "토끼",
            description: "활발하고 긍정적인 에너지로 즐거운 대화를 이끌어가는 발랄한 친구",
            assistantID: "asst_rabbit789"
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        setupStyling()
        setupCharacterData()
        setupGestureRecognizers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showCharacterSelection()
    }

    // MARK: - Button Actions
    @objc private func handleChatButtonTap(_ sender: UIButton) {
        // 버튼 태그로 캐릭터 식별
        guard sender.tag >= 0 && sender.tag < characters.count else { return }

        let selectedCharacter = characters[sender.tag]
        print("🎭 선택된 캐릭터: \(selectedCharacter.name) (Assistant ID: \(selectedCharacter.assistantID))")

        // 토끼(3번째) 캐릭터인지 확인
        if selectedCharacter.id == "rabbit" {
            // 버튼 탭 애니메이션
            animateButtonTap(sender)

            // 준비중 알림 표시
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showAlert(title: "🐰 토끼와의 대화", message: "준비중입니다!")
            }
            return
        }

        // 나머지 캐릭터들은 기존 로직대로
        animateButtonTap(sender)

        // 0.2초 후 화면 전환 (애니메이션 완료 후)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigateToChatDetail(with: selectedCharacter)
        }
    }

    private func animateButtonTap(_ button: UIButton) {
        // 버튼 탭 애니메이션 - 초록색 강조
        let originalColor = button.backgroundColor

        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            button.backgroundColor = UIColor(red: 48/255, green: 209/255, blue: 88/255, alpha: 1.0) // 더 밝은 초록
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = CGAffineTransform.identity
                button.backgroundColor = originalColor
            }
        }
    }

    private func navigateToChatDetail(with character: Character) {
        // 스토리보드에서 ChatDetailViewController 가져오기
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // ChatDetailViewController 인스턴스 생성
        if let chatDetailVC = storyboard.instantiateViewController(withIdentifier: "ChatDetailViewController") as? ChatDetailViewController {
            // 캐릭터 데이터 전달
            chatDetailVC.selectedCharacter = character

            // 네비게이션으로 화면 전환
            navigationController?.pushViewController(chatDetailVC, animated: true)
        } else {
            // ChatDetailViewController를 찾을 수 없는 경우 알림
            showAlert(title: "오류", message: "대화 화면을 불러올 수 없습니다.\n\n해결 방법:\n1. ChatDetailViewController.swift 파일 확인\n2. View Controller Scene 클래스 연결 확인\n3. Storyboard ID 'ChatDetailViewController' 설정 확인")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UI Setup
extension ChatViewController {

    private func setupInitialState() {
        view.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 254/255, alpha: 1.0)
        showCharacterSelection()
    }

    private func setupStyling() {
        setupCharacterSelectorStyling()
    }

    private func setupCharacterSelectorStyling() {
        // 캐릭터 선택 컨테이너
        characterSelectorContainer.backgroundColor = .white
        characterSelectorContainer.layer.cornerRadius = 20
        characterSelectorContainer.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.1).cgColor
        characterSelectorContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        characterSelectorContainer.layer.shadowRadius = 16
        characterSelectorContainer.layer.shadowOpacity = 1.0

        // 제목 라벨
        selectorTitleLabel.font = UIFont.pretendardBold(size: 20)
        selectorTitleLabel.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)
        selectorTitleLabel.text = "대화할 캐릭터를 선택하세요"
        selectorTitleLabel.textAlignment = .center

        // 캐릭터 컨테이너들 스타일링
        setupCharacterContainer(character1Container)
        setupCharacterContainer(character2Container)
        setupCharacterContainer(character3Container)

        // 대화 버튼들 스타일링
        setupChatButton(character1Button, character: characters[0])
        setupChatButton(character2Button, character: characters[1])
        setupChatButton(character3Button, character: characters[2])

        // 팁 카드 스타일링 - 더 눈에 띄게
        tipContainer.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 252/255, alpha: 1.0)
        tipContainer.layer.cornerRadius = 16
        tipContainer.layer.borderWidth = 1
        tipContainer.layer.borderColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.3).cgColor
        tipContainer.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.1).cgColor
        tipContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        tipContainer.layer.shadowRadius = 8
        tipContainer.layer.shadowOpacity = 1.0

        tipTitleLabel.font = UIFont.pretendardBold(size: 16)
        tipTitleLabel.textColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        tipTitleLabel.text = "💡 팁"

        tipDescLabel.font = UIFont.pretendardMedium(size: 14)
        tipDescLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        tipDescLabel.numberOfLines = 0
        tipDescLabel.text = "캐릭터를 선택하면 오늘 작성한 감사일기를 바탕으로 심리상담을 시작합니다.\n각 캐릭터마다 다른 스타일의 조언을 받을 수 있어요."
    }

    private func setupCharacterContainer(_ container: UIView) {
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor(red: 230/255, green: 247/255, blue: 230/255, alpha: 1.0).cgColor

        // 그림자 효과 추가
        container.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.15).cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        container.layer.shadowRadius = 12
        container.layer.shadowOpacity = 1.0
        container.layer.masksToBounds = false
    }

    private func setupChatButton(_ button: UIButton, character: Character) {
        // 버튼 기본 스타일
        button.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        button.setTitle("대화", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        button.layer.cornerRadius = 12

        // 그림자 효과
        button.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.3).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 1.0

        // 캐릭터 정보를 버튼 태그로 저장
        switch character.id {
        case "sakura":
            button.tag = 0
        case "owl":
            button.tag = 1
        case "rabbit":
            button.tag = 2
        default:
            button.tag = -1
        }

        // 버튼 액션 연결
        button.addTarget(self, action: #selector(handleChatButtonTap(_:)), for: .touchUpInside)

        // 탭 효과
        button.showsTouchWhenHighlighted = true
    }

    private func setupCharacterData() {
        // 첫 번째 캐릭터 (사쿠라) 🌸
        character1NameLabel.text = characters[0].name
        character1NameLabel.font = UIFont.pretendardBold(size: 18)
        character1NameLabel.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)

        // 이미지뷰 스타일링 및 이모지 추가
        addEmojiToImageView(character1ImageView, emoji: characters[0].emoji)

        character1DescLabel.text = characters[0].description
        character1DescLabel.font = UIFont.pretendardMedium(size: 14)
        character1DescLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        character1DescLabel.numberOfLines = 0
        character1DescLabel.lineBreakMode = .byWordWrapping

        // 두 번째 캐릭터 (올빼미) 🦉
        character2NameLabel.text = characters[1].name
        character2NameLabel.font = UIFont.pretendardBold(size: 18)
        character2NameLabel.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)

        addEmojiToImageView(character2ImageView, emoji: characters[1].emoji)

        character2DescLabel.text = characters[1].description
        character2DescLabel.font = UIFont.pretendardMedium(size: 14)
        character2DescLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        character2DescLabel.numberOfLines = 0
        character2DescLabel.lineBreakMode = .byWordWrapping

        // 세 번째 캐릭터 (토끼) 🐰
        character3NameLabel.text = characters[2].name
        character3NameLabel.font = UIFont.pretendardBold(size: 18)
        character3NameLabel.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0)

        addEmojiToImageView(character3ImageView, emoji: characters[2].emoji)

        character3DescLabel.text = characters[2].description
        character3DescLabel.font = UIFont.pretendardMedium(size: 14)
        character3DescLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        character3DescLabel.numberOfLines = 0
        character3DescLabel.lineBreakMode = .byWordWrapping
    }

    private func addEmojiToImageView(_ imageView: UIImageView, emoji: String) {
        // 이미지뷰에 이모지를 텍스트로 표시하는 방법
        imageView.backgroundColor = UIColor(red: 240/255, green: 255/255, blue: 244/255, alpha: 1.0)
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.3).cgColor
        imageView.contentMode = .center

        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        imageView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    private func setupGestureRecognizers() {
        // 대화 버튼 사용으로 제스처 설정 불필요
        // 버튼 액션은 setupChatButton에서 설정됨
    }
}

// MARK: - UI State Management
extension ChatViewController {

    private func showCharacterSelection() {
        // 캐릭터 선택 화면 표시 (현재 기본 상태)
        characterSelectorContainer.isHidden = false
        tipContainer.isHidden = false
    }
}
