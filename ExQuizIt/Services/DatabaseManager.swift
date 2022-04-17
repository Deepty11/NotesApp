//
//  DatabaseManager.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 12/4/22.
//

import Foundation
import RealmSwift

class DatabaseManager{
    static let shared = DatabaseManager()
    var realm = try! Realm()
    
    func storeJSONParsedQuiz(with quizzes: [QuizeJsonModel]){
        var quizEntries = [Quiz]()
        for quiz in quizzes{
            let quizModel = Quiz()
            quizModel.question = quiz.question
            quizModel.answer = quiz.answer
            quizModel.isKnown = false
            quizEntries.append(quizModel)
        }
        do{
            try realm.write{
                realm.add(quizEntries)
            }
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func updateLearningStatus(with status: Bool, of quiz: Quiz){
        let quizTobeUpdated = realm.objects(Quiz.self).filter("question == %@", quiz.question ?? "")[0]
        do{
            try realm.write{
                quizTobeUpdated.isKnown = status
                realm.add(quizTobeUpdated)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getAllQuiz()-> [Quiz]{
        return Array(realm.objects(Quiz.self))
    }
}
