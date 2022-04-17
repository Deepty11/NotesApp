//
//  AddNoteTableViewCell.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 6/4/22.
//

import UIKit

class AddQuizTableViewCell: UITableViewCell, UITextViewDelegate {

    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var quizTextView: UITextView!
    var inputType: InputType!
    var delegate: CellInteractionDelegte?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(){
        self.quizTextView.delegate = self
        if self.quizTextView.text == "" || self.quizTextView.text == nil{
            self.quizTextView.text = inputType == .question ? "Question" : "Answer"
            self.quizTextView.textColor = UIColor.gray
        } else{
            self.quizTextView.textColor = UIColor.black
        }
        
        self.cellView.layer.cornerRadius = 5.0
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.quizTextView.text == "" || self.quizTextView.text == nil{
            self.quizTextView.text = inputType == .question ? "Question" : "Answer"
            self.quizTextView.resignFirstResponder()
            self.quizTextView.textColor = .gray
        } else{
            self.quizTextView.textColor = .black
        }
        delegate?.textViewDidChanged(cell: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.quizTextView.text == "Question" || self.quizTextView.text == "Answer"{
            self.quizTextView.text = ""
        }
        self.quizTextView.textColor = .black
        delegate?.textViewDidBeginEditing(cell: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.quizTextView.text == "" || self.quizTextView.text == nil{
            self.quizTextView.text = inputType == .question ? "Question" : "Answer"
            self.quizTextView.resignFirstResponder()
            self.quizTextView.textColor = .gray
        } else{
            self.quizTextView.textColor = .black
        }
    }
    

}
