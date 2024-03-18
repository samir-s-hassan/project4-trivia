//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestionResponse: Decodable {
    let results: [TriviaQuestion]

    private enum CodingKeys: String, CodingKey {
        case results = "results" // = "results" not neccesary but did just to show
    }
}

struct TriviaQuestion: Decodable {
  let category: String
  let question: String
  let correctAnswer: String
  let incorrectAnswers: [String]

    private enum CodingKeys: String, CodingKey {
        case category //if the case name exactly matches the JSON key, then we don't need to specify the raw value
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }

}

