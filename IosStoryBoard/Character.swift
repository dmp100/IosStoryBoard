//
//  Character.swift
//  IosStoryBoard
//
//  Created by 성규현 on 6/22/25.
//

import Foundation

// 공통으로 사용할 Character 구조체
struct Character {
    let id: String
    let emoji: String
    let name: String
    let description: String
    let assistantID: String
}

// 채팅 메시지 구조체도 여기에 포함
struct ChatMessage {
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}
