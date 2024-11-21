//
//  Question.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/21/24.
//

import Foundation

struct Question {
    let question: String
    let answerType: AnswerType
    let answerOptions: [String]
}

enum AnswerType: Equatable {
    case twoChoices
    case multiChoices
    case multiSelect(basicScore: Float, answerDisposition: AnswerDisposition = .neutral)
}

enum AnswerDisposition: Equatable {
    case negative
    case neutral
    case positive
}
