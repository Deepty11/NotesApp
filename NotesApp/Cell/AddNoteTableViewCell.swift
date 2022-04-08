//
//  AddNoteTableViewCell.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 6/4/22.
//

import UIKit

class AddNoteTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var pageTextView: UITextView!
    var pageName: PageName!
    var delegate: CellInteractionDelegte?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(){
        self.pageTextView.delegate = self
        self.pageTextView.text = pageName == .front ? "Front Page" : "Back Page"
        self.pageTextView.textColor = UIColor.gray
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.pageTextView.text == "" || self.pageTextView.text == nil{
            self.pageTextView.text = pageName == .front ? "Front Page" : "Back Page"
            self.pageTextView.resignFirstResponder()
            self.pageTextView.textColor = .gray
        } else{
            self.pageTextView.textColor = .black
        }
        delegate?.textViewDidChanged(cell: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.pageTextView.text == "Front Page" || self.pageTextView.text == "Back Page"{
            self.pageTextView.text = ""
        }
        self.pageTextView.textColor = .black
        delegate?.textViewDidBeginEditing(cell: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.pageTextView.text == "" || self.pageTextView.text == nil{
            self.pageTextView.text = pageName == .front ? "Front Page" : "Back Page"
            self.pageTextView.resignFirstResponder()
            self.pageTextView.textColor = .gray
        } else{
            self.pageTextView.textColor = .black
        }
    }
    

}
