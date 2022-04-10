//
//  NotesListViewController.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 5/4/22.
//

import UIKit
import RealmSwift

class NotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var emptyNotesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var noteSources : [Note]!
    var notes: [Note]{
        return Array(realm.objects(Note.self))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressed))
        self.tableView.addGestureRecognizer(longPress)
        self.noteSources = notes
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.noteSources = notes
        self.tableView.isHidden = noteSources.isEmpty ? true : false
        self.emptyNotesLabel.isHidden = noteSources.isEmpty ? false : true
        self.tableView.reloadData()
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "Notes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonTapped))
    }
    // long press to delete a note by its id provided
    @objc func handleLongPressed(sender: UILongPressGestureRecognizer){
        if sender.state == .began{
            let touchPoint = sender.location(in: self.tableView)
            if var indexRow = tableView.indexPathForRow(at: touchPoint)?.row{
                let alert = UIAlertController(title: "Attention",
                                              message: "Do you want to delete the note?",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Confirm",
                                             style: .default) { action in
                    let note = self.realm.objects(Note.self).filter("id == %d", indexRow)[0]
                    let nextNotes = self.realm.objects(Note.self).filter("id > %d", indexRow)
                    do{
                        try self.realm.write {
                            self.realm.delete(note)
                            for note in nextNotes{
                                note.id = indexRow
                                indexRow += 1
                            }
                            self.realm.add(nextNotes)
                            
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                    self.displayAlert(title: nil, message: "Deleted Successfully")
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func displayAlert(title: String?, message: String?){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.dismiss(animated: true) {
                    self.noteSources  = self.notes
                    if self.noteSources.isEmpty{
                        self.tableView.isHidden = true
                        self.emptyNotesLabel.isHidden = false
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @objc func addButtonTapped(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController{
            vc.storeType = .createNewNote
            self.navigationController?.pushViewController(vc,
                                                          animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as? NotesTableViewCell{
            cell.pageTextView.text = noteSources[indexPath.row].frontPage
            cell.pageTextView.textContainer.lineBreakMode = .byTruncatingTail
            cell.selectionStyle = .none
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController{
            vc.previousNote = noteSources[indexPath.row]
            vc.storeType = .updateNote
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    

    

}
