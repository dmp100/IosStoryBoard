//
//  ListViewController.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/20/25.
//

import UIKit
import Supabase

class ListViewController: UIViewController {

    // MARK: - IBOutlets (1개 카드만 사용)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var datePickerContainer: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var diaryListStackView: UIStackView!

    // 1개의 일기 카드만 사용
    @IBOutlet weak var diaryCard1: UIView!  // 기존 이름 그대로 사용

    // 카드 내부 요소들 (기존 이름 그대로 사용)
    @IBOutlet weak var card1Label1: UILabel!  // 날짜용
    @IBOutlet weak var card1Label2: UILabel!  // 감사 1
    @IBOutlet weak var card1Label3: UILabel!  // 감사 2
    @IBOutlet weak var card1Label4: UILabel!  // 감사 3

    // "일기가 없습니다" 메시지용 라벨 (추가 필요)
    @IBOutlet weak var noDataLabel: UILabel!

    // MARK: - Properties
    private var diaryEntries: [DiaryEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyling()
        setupDatePicker()
        setupDiaryCard()
        setupNoDataLabel()
        loadDiaryEntries()

        // 초기 로드 시 오늘 날짜의 일기 표시
        showDiaryForDate(datePicker.date)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDiaryEntries() // 홈에서 새로 저장했을 때 업데이트
        showDiaryForDate(datePicker.date) // 현재 선택된 날짜의 일기 다시 표시
    }

    // MARK: - Setup Methods
    private func setupStyling() {
        // 전체 배경색 (HTML의 background: #f8fffe)
        view.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 254/255, alpha: 1.0)
        title = "목록"

        // Navigation Bar 스타일링
        setupNavigationBar()

        // Date Picker Container 스타일링
        setupDatePickerContainer()
    }

    private func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0),
                .font: UIFont.pretendardSemiBold(size: 17)
            ]
        }
    }

    private func setupDatePickerContainer() {
        // HTML의 .date-picker 스타일과 동일
        datePickerContainer.backgroundColor = .white
        datePickerContainer.layer.cornerRadius = 12
        datePickerContainer.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.1).cgColor
        datePickerContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        datePickerContainer.layer.shadowRadius = 8
        datePickerContainer.layer.shadowOpacity = 1.0
    }

    private func setupDatePicker() {
        // Date Picker 설정
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact

        // 한국어 설정
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.timeZone = TimeZone(identifier: "Asia/Seoul")

        // HTML의 .current-date 스타일 (초록색)
        datePicker.tintColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        datePicker.backgroundColor = .white

        // 현재 날짜로 설정
        datePicker.date = Date()

        // 날짜 변경 시 액션 연결
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        // 날짜 범위 설정 (1년 전부터 오늘까지)
        let calendar = Calendar.current
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()

        datePicker.minimumDate = oneYearAgo
        datePicker.maximumDate = Date() // 오늘까지만

        // Date Picker 중앙 정렬을 위한 제약조건 설정
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: datePickerContainer.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: datePickerContainer.centerYAnchor)
        ])
    }

    private func setupDiaryCard() {
        // 강화된 다이어리 카드 디자인
        diaryCard1.backgroundColor = .white
        diaryCard1.layer.cornerRadius = 20 // 더 둥근 모서리

        // 더 뚜렷한 그림자 효과
        diaryCard1.layer.shadowColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.25).cgColor
        diaryCard1.layer.shadowOffset = CGSize(width: 0, height: 4)
        diaryCard1.layer.shadowRadius = 16
        diaryCard1.layer.shadowOpacity = 1.0

        // 테두리 추가 (미세한 초록색 테두리)
        diaryCard1.layer.borderWidth = 1
        diaryCard1.layer.borderColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.1).cgColor

        // 날짜 라벨 설정 (HTML의 .diary-date 스타일)
        setupDateLabel(card1Label1)

        // 감사 라벨들 설정 (HTML의 .gratitude-preview 스타일)
        setupGratitudeLabel(card1Label2)
        setupGratitudeLabel(card1Label3)
        setupGratitudeLabel(card1Label4)
    }

    private func setupNoDataLabel() {
        guard let noDataLabel = noDataLabel else { return }

        // "일기가 없습니다" 메시지 스타일링
        noDataLabel.text = "📝\n\n선택한 날짜에 작성된\n감사일기가 없습니다.\n\n홈 탭에서 일기를 작성해보세요!"
        noDataLabel.font = UIFont.pretendardMedium(size: 16)
        noDataLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 0
        noDataLabel.isHidden = true // 초기에는 숨김
    }

    private func setupDateLabel(_ label: UILabel) {
        // 더 강조된 날짜 라벨 스타일
        label.font = UIFont.pretendardSemiBold(size: 16) // 크기 증가 + 볼드
        label.textColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0) // 초록색으로 변경
        label.backgroundColor = UIColor(red: 248/255, green: 255/255, blue: 254/255, alpha: 1.0) // 연한 초록 배경
        label.textAlignment = .center // 정중앙 정렬
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true

        // 제약조건 충돌 해결: translatesAutoresizingMaskIntoConstraints 설정
        label.translatesAutoresizingMaskIntoConstraints = false

        // 패딩 효과를 위한 높이 설정
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
    }

    private func setupGratitudeLabel(_ label: UILabel) {
        // 더 뚜렷한 감사 라벨 스타일
        label.backgroundColor = UIColor(red: 240/255, green: 255/255, blue: 244/255, alpha: 1.0) // #f0fff4
        label.layer.cornerRadius = 12 // 더 둥근 모서리
        label.layer.masksToBounds = true

        // 미세한 테두리 추가
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.15).cgColor

        // HTML의 .gratitude-text 스타일
        label.font = UIFont.pretendardRegular(size: 15)
        label.textColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1.0) // #1d1d1f
        label.numberOfLines = 0 // 여러 줄 허용
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left

        // 왼쪽 초록색 border 추가 (더 두껍게)
        addLeftBorderToLabel(label)

        // 내용 크기에 맞게 높이 조정
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        // 최소 높이 설정
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
    }

    private func addLeftBorderToLabel(_ label: UILabel) {
        // HTML의 border-left: 4px solid #34C759 효과
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0).cgColor
        borderLayer.name = "leftBorder"

        // 기존 border 제거
        label.layer.sublayers?.removeAll { $0.name == "leftBorder" }

        // 새 border 추가
        label.layer.addSublayer(borderLayer)

        // 레이아웃이 완료된 후 border 크기 조정
        DispatchQueue.main.async {
            borderLayer.frame = CGRect(x: 0, y: 0, width: 4, height: label.frame.height)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 레이아웃 변경 시 border 크기 재조정
        updateLeftBorders()
    }

    private func updateLeftBorders() {
        let gratitudeLabels = [card1Label2, card1Label3, card1Label4]

        for label in gratitudeLabels {
            guard let label = label else { continue }

            if let borderLayer = label.layer.sublayers?.first(where: { $0.name == "leftBorder" }) {
                borderLayer.frame = CGRect(x: 0, y: 0, width: 4, height: label.frame.height)
            }
        }
    }

    // MARK: - Date Picker Actions
    @objc private func dateChanged() {
        let selectedDate = datePicker.date
        print("선택된 날짜: \(selectedDate)")

        // 선택된 날짜의 일기 새로 불러오기
        loadDiaryEntries()
    }

    // MARK: - Supabase Data Loading
    private func fetchGratitudeEntries(for date: Date) async throws -> [DiaryEntry] {
        guard let userId = supabase.auth.currentUser?.id else {
            print("❌ 로그인된 사용자가 없음")
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "로그인이 필요합니다"])
        }

        print("🔍 사용자 ID: \(userId.uuidString)")
        print("🔍 조회할 날짜: \(date)")

        // 일단 모든 사용자 데이터를 가져와서 확인해보기
        let data: [GratitudeDiaryResponse] = try await supabase
            .from("gratitude_diaries")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false) // 최신순으로 정렬
            .execute()
            .value

        print("✅ 사용자의 전체 데이터 개수: \(data.count)")

        // ISO8601DateFormatter 사용 (더 정확한 파싱)
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // UTC 시간대로 Calendar와 DateFormatter 설정 (데이터베이스와 동일하게)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!

        // 날짜만 비교하기 위한 DateFormatter (UTC 기준)
        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.dateFormat = "yyyy-MM-dd"
        dateOnlyFormatter.timeZone = TimeZone(identifier: "UTC")

        let selectedDateString = dateOnlyFormatter.string(from: date)
        print("🔍 선택된 날짜 문자열 (UTC): \(selectedDateString)")

        var matchingItems: [GratitudeDiaryResponse] = []

        for item in data {
            if let createdDate = isoFormatter.date(from: item.created_at) {
                let createdDateString = dateOnlyFormatter.string(from: createdDate)

                if createdDateString == selectedDateString {
                    matchingItems.append(item)
                    print("✅ 날짜 일치: \(item.content) (시간: \(item.created_at))")
                }
            } else {
                print("❌ 날짜 파싱 실패: \(item.created_at)")
            }
        }

        if !matchingItems.isEmpty {
            // 최신 3개만 가져오기 (이미 order by created_at desc로 정렬되어 있음)
            let latest3Items = Array(matchingItems.prefix(3))
            let contentList = latest3Items.map { $0.content }

            let entry = DiaryEntry(date: date, gratitudeTexts: contentList)
            print("✅ DiaryEntry 생성됨: \(contentList.count)개 항목 (최신 3개)")
            print("📝 표시할 내용: \(contentList)")
            return [entry]
        }

        print("❌ 해당 날짜에 감사일기 내용이 없음")
        return []
    }

    // MARK: - Data Loading
    private func loadDiaryEntries() {
        Task {
            do {
                let entries = try await fetchGratitudeEntries(for: datePicker.date)
                DispatchQueue.main.async {
                    self.diaryEntries = entries
                    self.showDiaryForDate(self.datePicker.date)
                }
            } catch {
                print("데이터 불러오기 실패:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.diaryEntries = []
                    self.showDiaryForDate(self.datePicker.date)
                }
            }
        }
    }

    private func showDiaryForDate(_ selectedDate: Date) {
        // 선택된 날짜와 같은 날의 일기들 모두 찾기 (여러 개 있을 수 있음)
        let calendar = Calendar.current
        let selectedEntries = diaryEntries.filter { entry in
            calendar.isDate(entry.date, inSameDayAs: selectedDate)
        }

        if let firstEntry = selectedEntries.first {
            // 일기가 있는 경우 (첫 번째 일기만 표시, 나중에 여러 개 처리 로직 추가 가능)
            diaryCard1.isHidden = false
            noDataLabel?.isHidden = true

            // 날짜 설정 (HTML과 동일한 형식)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy.MM.dd EEEE"
            card1Label1.text = formatter.string(from: firstEntry.date)

            // 감사 내용 설정 (최대 3개까지만 표시)
            let gratitudeLabels = [card1Label2, card1Label3, card1Label4]

            // 최대 3개까지만 표시하도록 제한
            let maxDisplayCount = min(firstEntry.gratitudeTexts.count, gratitudeLabels.count)

            for index in 0..<maxDisplayCount {
                guard index < gratitudeLabels.count else { break }

                let text = firstEntry.gratitudeTexts[index]
                // 텍스트 앞에 공백 추가해서 왼쪽 여백 효과
                let paddedText = "  \(index + 1). \(text)" // 앞에 공백 2개 추가

                gratitudeLabels[index]?.text = paddedText
                gratitudeLabels[index]?.isHidden = false
            }

            // 사용하지 않는 라벨들 숨김
            for index in maxDisplayCount..<gratitudeLabels.count {
                gratitudeLabels[index]?.isHidden = true
            }

            // 여러 일기가 있는지 로그로 확인
            if selectedEntries.count > 1 {
                print("📝 \(formatter.string(from: selectedDate))에 \(selectedEntries.count)개의 일기가 있음 (첫 번째 표시)")
            } else {
                print("✅ \(formatter.string(from: selectedDate))의 일기 표시됨")
            }

            // 3개보다 많은 감사일기가 있으면 알림
            if firstEntry.gratitudeTexts.count > 3 {
                print("⚠️ 감사일기가 \(firstEntry.gratitudeTexts.count)개 있지만 3개만 표시됨")
            }
        } else {
            // 일기가 없는 경우
            diaryCard1.isHidden = true
            noDataLabel?.isHidden = false

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy.MM.dd"
            print("❌ \(formatter.string(from: selectedDate))에는 일기가 없음")
        }
    }

    private func shortenTextForOneLine(_ text: String) -> String {
        // 텍스트를 한 줄에 맞게 줄이기 (30자 정도로 제한)
        let maxLength = 30

        if text.count <= maxLength {
            return text
        } else {
            let shortened = String(text.prefix(maxLength))
            return shortened + "..."
        }
    }
}

