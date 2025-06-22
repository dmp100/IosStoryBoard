//
//  ProfileViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/20/25.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - IBOutlets (현재 스토리보드 구조에 맞춤)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    // 상단 프로필 헤더 (첫 번째 View)
    @IBOutlet weak var profileHeaderContainer: UIView!
    @IBOutlet weak var profileLabel1: UILabel!  // 아바타/이름용
    @IBOutlet weak var profileLabel2: UILabel!  // 서브타이틀용

    // 하단 통계 그리드 (두 번째 View)
    @IBOutlet weak var statsContainer: UIView!
    @IBOutlet weak var statLabel1: UILabel!  // 총 감사 개수 라벨
    @IBOutlet weak var statLabel2: UILabel!  // 총 감사 숫자
    @IBOutlet weak var statLabel3: UILabel!  // 연속 작성일 라벨
    @IBOutlet weak var statLabel4: UILabel!  // 연속 작성일 숫자

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyling()
        loadUserData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics() // 다른 탭에서 일기 작성 시 통계 업데이트
    }
}

// MARK: - UI Setup
extension ProfileViewController {

    private func setupStyling() {
        view.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 254/255, alpha: 1.0)

        setupProfileHeader()
        setupStatsContainer()
    }

    private func setupProfileHeader() {
        // 프로필 헤더 컨테이너 스타일링 (상단 회색 View)
        profileHeaderContainer.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        profileHeaderContainer.layer.cornerRadius = 16

        // 그라데이션 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = profileHeaderContainer.bounds
        gradientLayer.colors = [
            UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0).cgColor,
            UIColor(red: 48/255, green: 209/255, blue: 88/255, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = 16
        profileHeaderContainer.layer.insertSublayer(gradientLayer, at: 0)

        // 첫 번째 라벨 - 아바타 + 아이디 (🌱 사용자ID)
        profileLabel1.font = UIFont.pretendardBold(size: 24)
        profileLabel1.textColor = .white
        profileLabel1.textAlignment = .center

        // 두 번째 라벨 - 사용 기간
        profileLabel2.font = UIFont.pretendardMedium(size: 16)
        profileLabel2.textColor = UIColor(white: 1.0, alpha: 0.9)
        profileLabel2.textAlignment = .center

    }

    private func setupStatsContainer() {
        // 통계 컨테이너 스타일링 (하단 회색 View)
        statsContainer.backgroundColor = .white
        statsContainer.layer.cornerRadius = 16
        statsContainer.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.1).cgColor
        statsContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        statsContainer.layer.shadowRadius = 12
        statsContainer.layer.shadowOpacity = 1.0

        // 왼쪽 위 - 총 감사 라벨
        statLabel1.font = UIFont.pretendardMedium(size: 14)
        statLabel1.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
        statLabel1.textAlignment = .center
        statLabel1.text = "총 감사 개수"

        // 오른쪽 위 - 연속 작성일 라벨
        statLabel2.font = UIFont.pretendardMedium(size: 14)
        statLabel2.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
        statLabel2.textAlignment = .center
        statLabel2.text = "연속 작성일"

        // 왼쪽 아래 - 총 감사 숫자
        statLabel3.font = UIFont.pretendardBold(size: 28)
        statLabel3.textColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        statLabel3.textAlignment = .center

        // 오른쪽 아래 - 연속 작성일 숫자
        statLabel4.font = UIFont.pretendardBold(size: 28)
        statLabel4.textColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        statLabel4.textAlignment = .center
    }

    private func setupMenuContainer() {
        // 설정 메뉴 없음 - 이 함수 제거됨
    }

    private func setupConstraints() {
        // 필요시 추가 제약조건 설정
        profileHeaderContainer.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Data Loading
extension ProfileViewController {

    private func loadUserData() {
        // 사용자 아이디 로드 (실제로는 UserDefaults나 저장된 데이터에서 가져옴)
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "사용자"
        profileLabel1.text = "🌱 \(userID)"

        // 사용 기간 계산 (앱 설치일 기준)
        let daysSinceInstall = calculateDaysSinceInstall()
        profileLabel2.text = "감사일기와 함께한 지 \(daysSinceInstall)일"

        // 통계 업데이트
        updateStatistics()
    }

    private func updateStatistics() {
        // 총 감사 개수 계산 (실제로는 저장된 데이터에서 계산)
        let totalGratitudeCount = calculateTotalGratitudeCount()
        statLabel3.text = "\(totalGratitudeCount)"

        // 연속 작성일 계산
        let consecutiveDays = calculateConsecutiveDays()
        statLabel4.text = "\(consecutiveDays)"
    }

    private func calculateDaysSinceInstall() -> Int {
        // 앱 최초 실행일을 저장하고 계산
        let firstLaunchKey = "firstLaunchDate"

        if let firstLaunchDate = UserDefaults.standard.object(forKey: firstLaunchKey) as? Date {
            let calendar = Calendar.current
            let days = calendar.dateComponents([.day], from: firstLaunchDate, to: Date()).day ?? 0
            return max(1, days) // 최소 1일
        } else {
            // 첫 실행인 경우 현재 날짜 저장
            UserDefaults.standard.set(Date(), forKey: firstLaunchKey)
            return 1
        }
    }

    private func calculateTotalGratitudeCount() -> Int {
        // 실제로는 저장된 모든 감사일기의 개수를 계산
        // 현재는 샘플 데이터로 임시 계산

        // 예시: HomeViewController에서 저장한 감사일기 개수 계산
        // UserDefaults나 CoreData에서 실제 데이터를 가져와야 함

        // 임시로 날짜별 샘플 데이터 기반 계산
        return 45 // 15일 × 3개씩 = 45개 (임시값)
    }

    private func calculateConsecutiveDays() -> Int {
        // 실제로는 연속으로 일기를 작성한 날짜를 계산
        // 현재는 샘플값 반환
        return 15 // 임시값
    }
}

// MARK: - Button Actions
extension ProfileViewController {

    // 현재 설정 버튼이 없으므로 이 섹션은 비워둠
    // 향후 필요시 버튼 액션 추가 가능
}

// MARK: - Helper Methods
extension ProfileViewController {

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
