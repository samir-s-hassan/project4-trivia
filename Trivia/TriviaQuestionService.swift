//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Samir Hassan on 3/18/24.
//

import Foundation
import UIKit

class TriviaQuestionService{
    
    
    
    
    private static func parse(data: Data) -> [TriviaQuestion] {
        // transform the data we received into a dictionary [String: Any]
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let results = jsonDictionary["results"] as? [[String: Any]] else {
            // handle error or return empty array if unable to parse
            return []
        }
        
        var triviaQuestions = [TriviaQuestion]()
        
        // iterate through each result in the JSON array
        for result in results {
            // extract values for each property from the result dictionary
            guard let category = result["category"] as? String,
                  let question = result["question"] as? String,
                  let correctAnswer = result["correct_answer"] as? String,
                  let incorrectAnswers = result["incorrect_answers"] as? [String] else {
                // skip this result if any required property is missing
                continue
            }
            
            // create a TriviaQuestion instance and append it to the array
            let triviaQuestion = TriviaQuestion(category: category,
                                                 question: question,
                                                 correctAnswer: correctAnswer,
                                                 incorrectAnswers: incorrectAnswers)
            triviaQuestions.append(triviaQuestion)
        }
        
        return triviaQuestions
    }

}
