//
//  Note.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 6/4/22.
//

import Foundation
import RealmSwift

class Note: Object{
    @Persisted(primaryKey: true) var id: Int
    @Persisted var frontPage: String?
    @Persisted var backPage: String?
}


