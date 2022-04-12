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
    
    func storeJSONParsedQuiz(with quizes: [QuizeJsonModel]){
        var quizEntries = [Quiz]()
        for quiz in quizes{
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
}
