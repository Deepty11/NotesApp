//
//  AppState.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 11/4/22.
//

import Foundation

class JSONManager{
    static let shared = JSONManager()
    
    let quizJson = """
            [{
                "question" : "What does iOS stand for?",
                "answer" : "iPhone Operating System"
            },
            {
                "question" : "What Is A LLVM ?",
                "answer" : "Contains Both Compiler (swiftc And Objective C)"
            },
            {
                "question" : "What IDE is used for iOS development?",
                "answer" : "Xcode"
            },
            {
                "question" : "To create mutable object __ is used",
                "answer" : "var"
            },
            {
                "question" : "What Is Bundle In IOS",
                "answer" : "It Is Folder With .app Extension"
            },
            {
                "question" : "Application Running In Foreground But Currently Not Receiving Any Events .what Is The Current State Of Application?",
                "answer" : "Inactive State"
            },
            {
                "question" : "Meaning of IOS is -",
                "answer" : "Internetworking Operating System"
            },
            {
                "question" : "The most recent version of macOS is based on -",
                "answer" : "UNIX"
            },
            {
                "question" : "What is used to return multiple value from function in Swift?",
                "answer" : "Tuple"
            },
            {
                "question" : "In which year iOS was first written ?",
                "answer" : "1986"
            }]
"""
    func parseJson() -> [QuizeJsonModel]{
        if let jsonData = quizJson.data(using: .utf8){
            return try! JSONDecoder().decode([QuizeJsonModel].self, from: jsonData)
        }
       return []
    }
    
}


