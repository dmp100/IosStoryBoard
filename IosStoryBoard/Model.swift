//
//  Model.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/22/25.
//
// MARK: - 데이터 모델


import Foundation

// MARK: - Supabase 모델
struct GratitudeDiaryEntry: Encodable {
    let user_id: String
    let content: String
}

struct GratitudeDiaryResponse: Decodable {
    let id: Int?
    let user_id: String
    let content: String
    let created_at: String
}

// MARK: - UI 표시용 모델
struct DiaryEntry: Codable {
    let date: Date
    let gratitudeTexts: [String]

    // 확장 가능한 속성들
    // let mood: String?
    // let weather: String?
}

// MARK: - 사용자 인증 모델
struct UserProfile {
    let id: String
    let email: String
    let displayName: String?
}

// MARK: - 설정 모델 (필요시 추가)
struct AppSettings: Codable {
    let notificationEnabled: Bool
    let dailyReminderTime: Date?
    let theme: String

    static let defaultSettings = AppSettings(
        notificationEnabled: true,
        dailyReminderTime: nil,
        theme: "default"
    )
}
