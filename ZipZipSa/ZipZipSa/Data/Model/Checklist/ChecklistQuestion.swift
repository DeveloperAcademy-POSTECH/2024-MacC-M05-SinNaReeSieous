//
//  Question.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/21/24.
//

import Foundation

struct Question: Hashable {
    let question: String
    let answerType: AnswerType
    let answerOptions: [String]
}

enum AnswerType: Equatable, Hashable {
    case twoChoices
    case multiChoices
    case multiSelect(basicScore: Float, answerDisposition: AnswerDisposition = .neutral)
}

enum AnswerDisposition: Equatable {
    case negative
    case neutral
    case positive
}
