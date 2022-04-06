//
//  NotesTableViewCell.swift
//  NotesApp
//
//  Created by Rehnuma on 6/4/22.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var pageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setRoundedBorderAndShadow(){
        self.cellView.layer.cornerRadius = 5.0
        self.cellView.layer.shadowColor = UIColor.gray.cgColor
        self.cellView.layer.shadowRadius = 3.0
        self.cellView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.cellView.layer.shadowOpacity = 0.75
        
    }

}
