//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit
import Foundation

extension String { //SAMIR - this function is important to help out with HTML decoding since we want to decode this HTML into string
    func decodeHTMLEntities() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error decoding HTML entities: \(error)")
            return self
        }
    }
}


class TriviaViewController: UIViewController {
    
    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        // TODO: FETCH TRIVIA QUESTIONS HERE
        fetchNewTriviaQuestions() // Samir - Fetch trivia questions when the view loads
    }
    
    //Samir - this function is so we have a function to do the API call so we can later get fresh set of questions
    private func fetchNewTriviaQuestions() {
        TriviaQuestionService.fetchTriviaQuestions(amount: 10) { [weak self] questions in
            self?.questions = questions
            DispatchQueue.main.async {
                self?.currQuestionIndex = 0
                self?.numCorrectQuestions = 0
                self?.updateQuestion(withQuestionIndex: 0)
            }
        }
    }
    
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        let question = questions[questionIndex]
        // decode HTML entities in question text and category
        let decodedQuestionText = question.question.decodeHTMLEntities()
        let decodedCategoryText = question.category.decodeHTMLEntities()
        questionLabel.text = decodedQuestionText
        categoryLabel.text = decodedCategoryText
        let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
        if answers.count > 0 {
            answerButton0.setTitle(answers[0].decodeHTMLEntities(), for: .normal)
            answerButton2.isHidden = true //SAMIR - this is the code to hide the 3rd and 4th answer choices for T/F questions
            answerButton3.isHidden = true //SAMIR - this is the code to hide the 3rd and 4th answer choices for T/F questions
        }
        if answers.count > 1 {
            answerButton1.setTitle(answers[1].decodeHTMLEntities(), for: .normal)
            answerButton1.isHidden = false
        }
        if answers.count > 2 {
            answerButton2.setTitle(answers[2].decodeHTMLEntities(), for: .normal)
            answerButton2.isHidden = false
        }
        if answers.count > 3 {
            answerButton3.setTitle(answers[3].decodeHTMLEntities(), for: .normal)
            answerButton3.isHidden = false
        }
    }
    
    private func updateToNextQuestion(answer: String) {
        if isCorrectAnswer(answer) {
            numCorrectQuestions += 1
            // show alert for correct answer
//            let alert = UIAlertController(title: "Correct!", message: "You got the answer right!\nScore: \(numCorrectQuestions)/\(questions.count)", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
        }
//        else if currQuestionIndex != 10 {
//            // show alert for incorrect answer
//            let wrongAlert = UIAlertController(title: "Incorrect!", message: "Sorry, that's not the correct answer.\nScore: \(numCorrectQuestions)/\(questions.count)", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
//            wrongAlert.addAction(okAction)
//            present(wrongAlert, animated: true, completion: nil)
//        }
        //SAMIR - FOR FUTURE add something such that the user will only get the next question once he presses the OK button. Currently, they get to the next question then press OK on the popup
        currQuestionIndex += 1
        guard currQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        updateQuestion(withQuestionIndex: currQuestionIndex)
    }
    
    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == questions[currQuestionIndex].correctAnswer
    }
    
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game over!",
                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            currQuestionIndex = 0
            numCorrectQuestions = 0
            updateQuestion(withQuestionIndex: currQuestionIndex)
            self.fetchNewTriviaQuestions()
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
}

