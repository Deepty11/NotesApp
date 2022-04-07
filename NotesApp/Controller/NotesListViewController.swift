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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.isHidden = notes.isEmpty ? true : false
        self.emptyNotesLabel.isHidden = notes.isEmpty ? false : true
    }
    
    private func configureNavigationBar(){
        self.navigationItem.title = "Notes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonTapped))
    }
    
    @objc func handleLongPressed(sender: UILongPressGestureRecognizer){
        if sender.state == .began{
            let touchPoint = sender.location(in: self.tableView)
            let indexRow = tableView.indexPathForRow(at: touchPoint)?.row
        }
    }
    
    
    @objc func addButtonTapped(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController{
            self.navigationController?.pushViewController(vc,
                                                          animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as? NotesTableViewCell{
            cell.setRoundedBorderAndShadow()
            cell.pageLabel.text = notes[indexPath.row].frontPage
            return cell
            
        }
        return UITableViewCell()
    }
    

    

}
