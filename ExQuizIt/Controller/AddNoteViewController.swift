//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 5/4/22.
//

import UIKit
import RealmSwift

enum PageName{
    case front
    case back
}

enum StoreType{
    case updateNote
    case createNewNote
}
protocol CellInteractionDelegte{
    func textViewDidBeginEditing(cell: UITableViewCell)
    func textViewDidEndEditing(cell: UITableViewCell)
    func textViewDidChanged(cell: UITableViewCell)
}
class AddNoteViewController: UIViewController,
                                UITableViewDataSource,
                                UITableViewDelegate,
                                UIScrollViewDelegate,
                             CellInteractionDelegte{
    
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    let realm = try! Realm()
    var frontPageContent = String()
    var backPageContent = String()
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
        self.configureNavigationItem()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        if let previousNote = previousNote {
            self.frontPageContent = previousNote.frontPage ?? ""
            self.backPageContent = previousNote.backPage ?? ""
        }
    
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
    
    func configureNavigationItem(){
        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Save Icon"),
//                                                                 landscapeImagePhone: UIImage(named: "Save Icon"),
//                                                                 style: .plain,
//                                                                 target: self,
//                                                                 action: #selector(handleSaveButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                 target: self,
                                                                 action: #selector(handleSaveButtonTapped))
    }
    
    @objc func handleSaveButtonTapped(){
        switch storeType {
        case .updateNote:
            let noteToBeUpdated = realm.objects(Note.self).filter("id == %d", (previousNote?.id ?? -1) as Int)[0]
            self.saveNoteToRealm(note: noteToBeUpdated, id: previousNote?.id ?? -1)
        case .createNewNote:
            let note = Note()
            self.saveNoteToRealm(note: note, id: realm.objects(Note.self).count)
        default:
            return
        }
        
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
                note.frontPage = self.frontPageContent
                note.backPage = self.backPageContent
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddNoteTableViewCell", for: indexPath) as? AddNoteTableViewCell{
                cell.pageName = .front
                cell.pageTextView.text = self.previousNote?.frontPage
                cell.configureCell()
                cell.delegate = self
                cell.selectionStyle = .none
                cell.addGestureRecognizer(tapG)
                return cell
            }
        }
        // back page
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddNoteTableViewCell", for: indexPath) as? AddNoteTableViewCell{
            cell.pageName = .back
            cell.pageTextView.text = self.previousNote?.backPage
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
            if let cell = tableView.cellForRow(at: indexPath) as? AddNoteTableViewCell{
                let text = cell.pageTextView.text
                if indexPath.row == 0{
                    self.frontPageContent = text ?? ""
                } else{
                    self.backPageContent = text ??  ""
                }
            }
        }
    }
    

}
