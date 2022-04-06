//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 5/4/22.
//

import UIKit
import RealmSwift

class AddNoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.configureNavigationItem()
        
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
                cell.pageTextView.textColor = UIColor.gray
                cell.pageTextView.text = "Front Page"
                return cell
            }
        }
        // back page
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddNoteTableViewCell", for: indexPath) as? AddNoteTableViewCell{
            cell.pageTextView.textColor = UIColor.gray
            cell.pageTextView.text = "Back Page"
            return cell
        }
        return UITableViewCell()
    }



}
