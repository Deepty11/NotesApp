//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 5/4/22.
//

import UIKit
import RealmSwift

enum InputType{
    case question
    case answer
}

enum StoreType{
    case update
    case create
}
protocol CellInteractionDelegte{
    func textViewDidBeginEditing(cell: UITableViewCell)
    func textViewDidEndEditing(cell: UITableViewCell)
    func textViewDidChanged(cell: UITableViewCell)
}
class AddQuizViewController: UIViewController,
                                UITableViewDataSource,
                                UITableViewDelegate,
                                UIScrollViewDelegate,
                             CellInteractionDelegte{
    
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    let realm = try! Realm()
    var questionText = String()
    var answerText = String()
    var previousNote: Note? = nil
    var storeType: StoreType!
    var tapG : UITapGestureRecognizer{
        return UITapGestureRecognizer(target: self,
                                      action: #selector(handleTableViewTapped))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.configureNavigationBar()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        if let previousNote = previousNote {
            self.questionText = previousNote.frontPage ?? ""
            self.answerText = previousNote.backPage ?? ""
        }
    
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "Add Quiz"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                 target: self,
                                                                 action: #selector(handleSaveButtonTapped))
    }
    
    @objc func handleTableViewTapped(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func keyBoardWillShow(notification: Notification){
        if let keyBoardFrameInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyBoardFrameInfo.cgRectValue.height
            self.tableViewBottomConstraint.constant = keyboardHeight
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification){
        if let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            self.tableViewBottomConstraint.constant = 0
        }
    }
    
    
    @objc func handleSaveButtonTapped(){
        if self.questionText == "" || self.answerText == ""{
            let alert  =  UIAlertController(title: "Attention",
                                            message: "Unable to save if any field is empty",
                                            preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        DatabaseManager.shared.saveQuizToDatabase(question: self.questionText, answer: self.answerText)
        AppState.shared.answerViewDisplayed.append(false)
//        switch storeType {
//        case .update:
////            let noteToBeUpdated = realm.objects(Note.self).filter("id == %d", (previousNote?.id ?? -1) as Int)[0]
////            self.saveNoteToRealm(note: noteToBeUpdated, id: previousNote?.id ?? -1)
//        case .create:
//            DatabaseManager.shared.saveQuizToDatabase(question: self.questionText, answer: self.answerText)
//        default:
//            return
//        }
        
        let alert = UIAlertController(title: nil,
                                      message: "Saved!",
                                      preferredStyle: .alert)
        self.present(alert,
                     animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dismiss(animated: true) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
       
    }
    
    func saveNoteToRealm(note: Note, id: Int){
        do{
            try realm.write {
                note.id = id
                note.frontPage = self.questionText
                note.backPage = self.answerText
                realm.add(note)
            }
           
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{ // for front page
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddQuizTableViewCell", for: indexPath) as? AddQuizTableViewCell{
                cell.inputType = .question
                cell.quizTextView.text = self.previousNote?.frontPage
                cell.configureCell()
                cell.delegate = self
                cell.selectionStyle = .none
                cell.addGestureRecognizer(tapG)
                return cell
            }
        }
        // back page
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddQuizTableViewCell", for: indexPath) as? AddQuizTableViewCell{
            cell.inputType = .answer
            cell.quizTextView.text = self.previousNote?.backPage
            cell.configureCell()
            cell.delegate = self
            cell.selectionStyle = .none
            cell.addGestureRecognizer(tapG)
            return cell
        }
        return UITableViewCell()
    }

 //MARK: - CellInteractionDelegte methods
    func textViewDidBeginEditing(cell: UITableViewCell) {
        if let row = tableView.indexPath(for: cell){
            self.tableView.scrollToRow(at: row,
                                       at: .top,
                                       animated: true)
        }
       
    }
    
    func textViewDidEndEditing(cell: UITableViewCell) {

    }
    
    func textViewDidChanged(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            if let cell = tableView.cellForRow(at: indexPath) as? AddQuizTableViewCell{
                let text = cell.quizTextView.text
                if indexPath.row == 0{
                    self.questionText = text ?? ""
                } else{
                    self.answerText = text ??  ""
                }
            }
        }
    }
    

}
