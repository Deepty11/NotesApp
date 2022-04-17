//
//  NotesTableViewCell.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 6/4/22.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

    @IBOutlet weak var questionView: CardView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerView: CardView!
    @IBOutlet weak var crossIconImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var checkIconImageView: UIImageView!
    @IBOutlet weak var uncommonQuizView: UIView!
    @IBOutlet weak var commonQuizView: UIView!
    @IBOutlet weak var learningView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureIconColor()
        self.learningView.layer.borderWidth = 1
        self.learningView.layer.borderColor = UIColor.systemPink.cgColor
        self.learningView.layer.cornerRadius = 2
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureIconColor(){
        self.checkIconImageView.image = self.checkIconImageView.image?.withRenderingMode(.alwaysTemplate)
        self.checkIconImageView.tintColor = UIColor(named: "checkIcon Color")
        self.crossIconImageView.image = self.crossIconImageView.image?.withRenderingMode(.alwaysTemplate)
        self.crossIconImageView.tintColor = .red
    }

}
