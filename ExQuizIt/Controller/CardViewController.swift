//
//  CardViewController.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 17/4/22.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var questionView: CardView!
    @IBOutlet weak var answerView: CardView!
    @IBOutlet weak var tapToSeeAnswerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var uncommonQuestionView: UIView!
    @IBOutlet weak var commonQuestionView: UIView!
    @IBOutlet weak var crossIconImageView: UIImageView!
    @IBOutlet weak var checkIconImageView: UIImageView!
    var pageIndex = 0
    var quiz: QuizModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionView.isHidden = false
        self.answerView.isHidden = true
        let tP1 = UITapGestureRecognizer(target: self, action: #selector(handleTapToSeeAnswerButtonTapped))
        let tP2 = UITapGestureRecognizer(target: self, action: #selector(handleUncommonQuizButtonTapped))
        let tP3 = UITapGestureRecognizer(target: self, action: #selector(handleCommonQuizButtonTapped))
        
        self.questionLabel.text = self.quiz?.question
        
        self.tapToSeeAnswerView.addGestureRecognizer(tP1)
        self.uncommonQuestionView.addGestureRecognizer(tP2)
        self.commonQuestionView.addGestureRecognizer(tP3)
    }
    
    @objc func handleTapToSeeAnswerButtonTapped(sender: UITapGestureRecognizer){
        self.answerLabel.text = self.quiz?.answer
        self.crossIconImageView.image = self.crossIconImageView.image?.withRenderingMode(.alwaysTemplate)
        self.crossIconImageView.tintColor = .red
        self.checkIconImageView.image = self.checkIconImageView.image?.withRenderingMode(.alwaysTemplate)
        self.checkIconImageView.tintColor = UIColor(named: "checkIcon Color")
        self.flipCard(from: self.questionView, to:  self.answerView)
    }
    
    
    @objc func handleUncommonQuizButtonTapped(sender: UITapGestureRecognizer){
        DatabaseManager.shared.updateLearningStatus(with: false, of: self.quiz ?? QuizModel())
        self.flipCard(from: self.answerView, to: self.questionView)
        
    }
    
    @objc func handleCommonQuizButtonTapped(sender: UITapGestureRecognizer){
        DatabaseManager.shared.updateLearningStatus(with: true, of: self.quiz ?? QuizModel())
        self.flipCard(from: self.answerView, to: self.questionView)
    }
    
    func flipCard(from source: UIView, to destination: UIView){
        UIView.transition(with: source,
                          duration: 0.25,
                          options: AppState.shared.transitionOption) {
            source.isHidden = true
            
        }
        
        UIView.transition(with: destination,
                          duration: 0.25,
                          options: AppState.shared.transitionOption) {
            
            destination.isHidden = false
        }
            
    }

}
