//
//  NotesTableViewCell.swift
//  NotesApp
//
//  Created by Rehnuma on 6/4/22.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var questionView: CardView!
    @IBOutlet weak var pageTextView: UITextView!
    @IBOutlet weak var AnswerView: CardView!
    @IBOutlet weak var uncommonAnswerView: UIView!
    @IBOutlet weak var commonAnswerView: UIView!
    @IBOutlet weak var crossIconImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var checkIconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
