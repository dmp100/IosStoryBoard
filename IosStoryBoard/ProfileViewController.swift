//
//  ProfileViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/20/25.
//

import UIKit
import Supabase

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
        Task {
            await updateStatistics() // 다른 탭에서 일기 작성 시 통계 업데이트
        }
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
}

// MARK: - Data Loading
extension ProfileViewController {

    private func loadUserData() {
        Task {
            await loadUserProfile()
        }
    }

    private func loadUserProfile() async {
        guard let user = supabase.auth.currentUser else {
            print("❌ 로그인된 사용자가 없음")
            return
        }

        // 사용자 이메일 표시
        let userEmail = user.email ?? "사용자"
        let displayName = userEmail.components(separatedBy: "@").first ?? userEmail

        await MainActor.run {
            profileLabel1.text = "🌱 \(displayName)"
        }

        // 사용자의 첫 감사일기 작성일 조회
        await loadUserStartDate(userId: user.id.uuidString)

        // 통계 업데이트
        await updateStatistics()
    }

    private func loadUserStartDate(userId: String) async {
        do {
            let response: [GratitudeDiaryResponse] = try await supabase
                .from("gratitude_diaries")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: true)
                .limit(1)
                .execute()
                .value

            if let firstEntry = response.first {
                let createdAt = firstEntry.created_at

                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

                if let firstDate = formatter.date(from: createdAt) {
                    let daysSince = Calendar.current.dateComponents([.day], from: firstDate, to: Date()).day ?? 0
                    let totalDays = max(1, daysSince + 1)

                    await MainActor.run {
                        profileLabel2.text = "감사일기와 함께한 지 \(totalDays)일"
                    }
                    print("✅ 첫 감사일기 작성일: \(firstDate), 경과일: \(totalDays)일")
                } else {
                    print("❌ 날짜 파싱 실패: \(createdAt)")
                }
            } else {
                await MainActor.run {
                    profileLabel2.text = "오늘부터 감사일기 시작!"
                }
                print("📝 첫 감사일기가 아직 없음")
            }
        } catch {
            print("❌ 사용자 시작일 조회 실패: \(error)")
            await MainActor.run {
                profileLabel2.text = "감사일기와 함께하는 여정"
            }
        }
    }

    private func updateStatistics() async {
        guard let user = supabase.auth.currentUser else { return }

        // 총 감사 개수와 연속 작성일을 동시에 계산
        async let totalCount = calculateTotalGratitudeCount(userId: user.id.uuidString)
        async let consecutiveDays = calculateConsecutiveDays(userId: user.id.uuidString)

        let (total, consecutive) = await (totalCount, consecutiveDays)

        await MainActor.run {
            statLabel3.text = "\(total)"
            statLabel4.text = "\(consecutive)"
        }
    }

    private func calculateTotalGratitudeCount(userId: String) async -> Int {
        do {
            let response: [GratitudeDiaryResponse] = try await supabase
                .from("gratitude_diaries")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value

            let count = response.count
            print("✅ 총 감사일기 개수: \(count)")
            return count
        } catch {
            print("❌ 총 감사일기 개수 조회 실패: \(error)")
            return 0
        }
    }

    private func calculateConsecutiveDays(userId: String) async -> Int {
        do {
            let response: [GratitudeDiaryResponse] = try await supabase
                .from("gratitude_diaries")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: false)
                .execute()
                .value

            guard !response.isEmpty else {
                print("📝 감사일기가 없어서 연속일 = 0")
                return 0
            }

            // 날짜별로 그룹화
            var uniqueDates: Set<String> = []

            for entry in response {
                let createdAt = entry.created_at
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

                guard let date = formatter.date(from: createdAt) else { continue }

                let utcCalendar = Calendar(identifier: .gregorian)
                let utcTimeZone = TimeZone(identifier: "UTC")!
                let dateFormatter = DateFormatter()
                dateFormatter.calendar = utcCalendar
                dateFormatter.timeZone = utcTimeZone
                dateFormatter.dateFormat = "yyyy-MM-dd"

                let dateString = dateFormatter.string(from: date)
                uniqueDates.insert(dateString)
            }

            // 날짜 배열로 변환하고 정렬
            let sortedDates = uniqueDates.sorted(by: >)

            if sortedDates.isEmpty {
                return 0
            }

            // 연속일 계산
            var consecutiveCount = 1
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            for i in 1..<sortedDates.count {
                guard let currentDate = dateFormatter.date(from: sortedDates[i-1]),
                      let nextDate = dateFormatter.date(from: sortedDates[i]) else { break }

                let daysBetween = calendar.dateComponents([.day], from: nextDate, to: currentDate).day ?? 0

                if daysBetween == 1 {
                    consecutiveCount += 1
                } else {
                    break
                }
            }

            print("✅ 연속 작성일: \(consecutiveCount)일")
            print("📝 작성한 날짜들: \(sortedDates.prefix(5))")
            return consecutiveCount

        } catch {
            print("❌ 연속 작성일 계산 실패: \(error)")
            return 0
        }
    }
}

// MARK: - Helper Methods
extension ProfileViewController {

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
