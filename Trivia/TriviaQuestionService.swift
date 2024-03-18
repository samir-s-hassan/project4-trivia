//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Samir Hassan on 3/18/24.
//

import Foundation
import UIKit

import Foundation

class TriviaQuestionService {
    static func fetchTriviaQuestions(amount: Int, completion: (([TriviaQuestion]) -> Void)? = nil) {
        let url = URL(string: "https://opentdb.com/api.php?amount=\(amount)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            // Parse the JSON data into an array of TriviaQuestion objects
            let decoder = JSONDecoder()
            do {
                let triviaQuestionResponse = try decoder.decode(TriviaQuestionResponse.self, from: data)
                DispatchQueue.main.async {
                    completion?(triviaQuestionResponse.results)
                }
            } catch {
                assertionFailure("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
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
