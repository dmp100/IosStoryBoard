////
////  SupabaseService.swift
////  IosStoryBoard
////
////  Created by 성규현 on 6/22/25.
////
//
//import Supabase
//import Foundation
//
//class SupabaseService {
//    static let shared = SupabaseService()
//
//    private let client = SupabaseClient(
//        supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
//        supabaseKey: "YOUR_SUPABASE_ANON_KEY"
//    )
//
//    private init() {}
//
//    // MARK: - Authentication
//
//    /// 회원가입
//    func signUp(name: String, email: String, password: String) async throws {
//        // 1. Supabase Auth로 계정 생성
//        let response = try await client.auth.signUp(
//            email: email,
//            password: password
//        )
//
//        guard let user = response.user else {
//            throw SupabaseError.signUpFailed
//        }
//
//        // 2. users 테이블에 사용자 정보 저장
//        let userData: [String: Any] = [
//            "id": user.id,
//            "name": name,
//            "email": email,
//            "created_at": ISO8601DateFormatter().string(from: Date())
//        ]
//
//        try await client.database
//            .from("users")
//            .insert(userData)
//            .execute()
//    }
//
//    /// 로그인
//    func signIn(email: String, password: String) async throws {
//        try await client.auth.signIn(
//            email: email,
//            password: password
//        )
//    }
//
//    /// 로그아웃
//    func signOut() async throws {
//        try await client.auth.signOut()
//    }
//
//    /// 현재 사용자 정보
//    func getCurrentUser() async throws -> User? {
//        let session = try await client.auth.session
//        return session.user
//    }
//
//    /// 현재 사용자 ID
//    func getCurrentUserId() async throws -> String {
//        let session = try await client.auth.session
//        return session.user.id.uuidString
//    }
//
//    // MARK: - 감사일기 관련
//
//    /// 감사일기 저장
//    func saveGratitudeEntry(_ content: String, date: Date = Date()) async throws {
//        let userId = try await getCurrentUserId()
//
//        let entry: [String: Any] = [
//            "user_id": userId,
//            "content": content,
//            "entry_date": DateFormatter.dateOnly.string(from: date)
//        ]
//
//        try await client.database
//            .from("gratitude_entries")
//            .upsert(entry)
//            .execute()
//    }
//
//    /// 오늘의 감사일기 가져오기
//    func getTodayGratitude() async throws -> String? {
//        let userId = try await getCurrentUserId()
//        let today = DateFormatter.dateOnly.string(from: Date())
//
//        let response = try await client.database
//            .from("gratitude_entries")
//            .select("content")
//            .eq("user_id", value: userId)
//            .eq("entry_date", value: today)
//            .single()
//            .execute()
//
//        let data = response.data
//        if let gratitude = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//           let content = gratitude["content"] as? String {
//            return content
//        }
//        return nil
//    }
//
//    /// 감사일기 목록 가져오기
//    func getGratitudeList(limit: Int = 50) async throws -> [GratitudeEntry] {
//        let userId = try await getCurrentUserId()
//
//        let response = try await client.database
//            .from("gratitude_entries")
//            .select("*")
//            .eq("user_id", value: userId)
//            .order("entry_date", ascending: false)
//            .limit(limit)
//            .execute()
//
//        let data = response.data
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//
//        return try decoder.decode([GratitudeEntry].self, from: data)
//    }
//
//    // MARK: - 사용자 통계
//
//    /// 사용자 통계 가져오기
//    func getUserStats() async throws -> UserStats {
//        let userId = try await getCurrentUserId()
//
//        // 총 감사일기 개수
//        let totalResponse = try await client.database
//            .from("gratitude_entries")
//            .select("id", head: true)
//            .eq("user_id", value: userId)
//            .execute()
//
//        let totalCount = totalResponse.count ?? 0
//
//        // 연속 작성일 계산
//        let consecutiveDays = try await calculateConsecutiveDays(userId: userId)
//
//        return UserStats(
//            totalGratitudeCount: totalCount,
//            consecutiveDays: consecutiveDays,
//            longestStreak: consecutiveDays
//        )
//    }
//
//    private func calculateConsecutiveDays(userId: String) async throws -> Int {
//        let response = try await client.database
//            .from("gratitude_entries")
//            .select("entry_date")
//            .eq("user_id", value: userId)
//            .order("entry_date", ascending: false)
//            .execute()
//
//        let data = response.data
//        guard let entries = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
//            return 0
//        }
//
//        var consecutiveDays = 0
//        let dateFormatter = DateFormatter.dateOnly
//        let today = Date()
//
//        for (index, entry) in entries.enumerated() {
//            guard let dateString = entry["entry_date"] as? String,
//                  let entryDate = dateFormatter.date(from: dateString) else {
//                continue
//            }
//
//            let daysDifference = Calendar.current.dateComponents([.day], from: entryDate, to: today).day ?? 0
//
//            if index == 0 {
//                // 첫 번째 항목 (가장 최근)
//                if daysDifference <= 1 { // 오늘 또는 어제
//                    consecutiveDays = 1
//                } else {
//                    break
//                }
//            } else {
//                // 이전 항목과 연속인지 확인
//                if let previousDateString = entries[index-1]["entry_date"] as? String,
//                   let previousDate = dateFormatter.date(from: previousDateString) {
//                    let daysBetween = Calendar.current.dateComponents([.day], from: entryDate, to: previousDate).day ?? 0
//
//                    if daysBetween == 1 {
//                        consecutiveDays += 1
//                    } else {
//                        break
//                    }
//                }
//            }
//        }
//
//        return consecutiveDays
//    }
//}
//
//// MARK: - Models
//struct GratitudeEntry: Codable {
//    let id: String
//    let userId: String
//    let content: String
//    let entryDate: String
//    let createdAt: Date
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userId = "user_id"
//        case content
//        case entryDate = "entry_date"
//        case createdAt = "created_at"
//    }
//}
//
//struct UserStats {
//    let totalGratitudeCount: Int
//    let consecutiveDays: Int
//    let longestStreak: Int
//}
//
//// MARK: - Extensions
//extension DateFormatter {
//    static let dateOnly: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
//}
//
//// MARK: - Errors
//enum SupabaseError: Error, LocalizedError {
//    case signUpFailed
//    case signInFailed
//    case noCurrentUser
//
//    var errorDescription: String? {
//        switch self {
//        case .signUpFailed:
//            return "회원가입에 실패했습니다."
//        case .signInFailed:
//            return "로그인에 실패했습니다."
//        case .noCurrentUser:
//            return "현재 로그인된 사용자가 없습니다."
//        }
//    }
//}
