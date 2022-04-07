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
protocol CellInteractionDelegte{
    func textViewDidBeginEditing(cell: UITableViewCell)
    func textViewDidEndEditing()
    func textViewDidChanged()
}
class AddNoteViewController: UIViewController,
                                UITableViewDataSource,
                                UITableViewDelegate,
                                UIScrollViewDelegate,
                             CellInteractionDelegte{
    
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    let realm = try! Realm()
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
    }
    
    @objc func handleTableViewTapped(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func keyBoardWillShow(notification: Notification){
        if let keyBoardFrameInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyBoardFrameInfo.cgRectValue.height
            self.tableViewBottomConstraint.constant = keyboardHeight
//            print("(show)tableViewBottomConstraint: \(tableViewBottomConstraint.constant)")
//            print("(show)keyboard height: \(keyboardHeight)")
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification){
        if let keyBoardFrameInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyBoardFrameInfo.cgRectValue.height
            self.tableViewBottomConstraint.constant = 0
            //print("keyboard height: \(keyboardHeight)")
        }
    }
    
    func configureNavigationItem(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveButtonTapped))
    }
    
    @objc func handleSaveButtonTapped(){
        
        let alert = UIAlertController(title: nil,
                                      message: "Saved!",
                                      preferredStyle: .alert)
        self.present(alert,
                     animated: true) {
            self.dismiss(animated: true)
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
    
    func textViewDidEndEditing() {
        //
    }
    
    func textViewDidChanged() {
        //UI
    }
    

}
