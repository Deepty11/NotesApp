//
//  NotesListViewController.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 5/4/22.
//

import UIKit
import RealmSwift

class QuizListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

   
    @IBOutlet weak var emptyQuizLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var quizSources : [Quiz]!
    var quizes: [Quiz]{
        return Array(realm.objects(Quiz.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressed))
        self.tableView.addGestureRecognizer(longPress)
        self.quizSources = quizes
        /// initializing answerFlipped false for each quiz
        for _ in quizSources{
            AppState.shared.answerViewDisplayed.append(false)
        }
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.quizSources = quizes
        self.tableView.isHidden = quizSources.isEmpty ? true : false
        self.emptyQuizLabel.isHidden = quizSources.isEmpty ? false : true
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for (id,_) in AppState.shared.answerViewDisplayed.enumerated(){
            AppState.shared.answerViewDisplayed[id] = false
        }
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
                    self.quizSources  = self.quizes
                    if self.quizSources.isEmpty{
                        self.tableView.isHidden = true
                        self.emptyQuizLabel.isHidden = false
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
        return quizSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if quizSources[indexPath.row].isKnown == false{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTableViewCell", for: indexPath) as? QuizTableViewCell{
                cell.questionLabel.text = quizSources[indexPath.row].question
                cell.answerLabel.text = quizSources[indexPath.row].answer
                let tp = UITapGestureRecognizer(target: self, action: #selector(handleCommonQuizViewTapped))
                let tp2 = UITapGestureRecognizer(target: self, action: #selector(handleUnCommonQuizViewTapped))
                cell.commonQuizView.addGestureRecognizer(tp)
                cell.uncommonQuizView.addGestureRecognizer(tp2)
                cell.questionView.isHidden = AppState.shared.answerViewDisplayed[indexPath.row] ? true : false
                cell.answerView.isHidden = AppState.shared.answerViewDisplayed[indexPath.row] ? false : true
//                if AppState.shared.answerViewDisplayed[indexPath.row] == false{
//                    cell.questionView.isHidden = false
//                    cell.answerView.isHidden = true
//                    cell.questionLabel.text = quizSources[indexPath.row].question
//                } else{
//                    cell.questionView.isHidden = true
//                    cell.answerView.isHidden = false
//                    cell.answerLabel.text = quizSources[indexPath.row].answer
//                    let tp = UITapGestureRecognizer(target: self, action: #selector(handleCommonQuizViewTapped))
//                    let tp2 = UITapGestureRecognizer(target: self, action: #selector(handleUnCommonQuizViewTapped))
//                    cell.commonQuizView.addGestureRecognizer(tp)
//                    cell.uncommonQuizView.addGestureRecognizer(tp2)
//
//                }
                cell.selectionStyle = .none
                return cell
                
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func handleCommonQuizViewTapped(sender: UITapGestureRecognizer){
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)){
            
        }
        
    }
    
    @objc func handleUnCommonQuizViewTapped(sender: UITapGestureRecognizer){
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)){
            tableView.beginUpdates()
            if let cell = tableView.cellForRow(at: indexPath) as? QuizTableViewCell{
                AppState.shared.answerViewDisplayed[indexPath.row] = false
                UIView.transition(with: cell.answerView,
                                  duration: 0.25,
                                  options: AppState.shared.transitionOption) {
                    cell.answerView.isHidden = true
                   
                }
                
                UIView.transition(with: cell.questionView,
                                  duration: 0.25,
                                  options: AppState.shared.transitionOption) {
                    
                    cell.questionView.isHidden = false
                }
            }
            tableView.endUpdates()
        }
    }
    
    //selecting on cell will flip the view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !AppState.shared.answerViewDisplayed[indexPath.row]{
            tableView.beginUpdates()
            if let cell =  tableView.cellForRow(at: indexPath) as? QuizTableViewCell{
                AppState.shared.answerViewDisplayed[indexPath.row] = true
                UIView.transition(with: cell.questionView,
                                  duration: 0.25,
                                  options: AppState.shared.transitionOption) {
                    cell.questionView.isHidden = true
                   
                }
                
                UIView.transition(with: cell.answerView,
                                  duration: 0.25,
                                  options: AppState.shared.transitionOption) {
                    
                    cell.answerView.isHidden = false
                    cell.configureIconColor()
                }
                
                
            }
            tableView.endUpdates()
        }
        
        
    }
  

}
