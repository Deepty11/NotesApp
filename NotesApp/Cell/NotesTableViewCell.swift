//
//  NotesTableViewCell.swift
//  NotesApp
//
//  Created by Rehnuma on 6/4/22.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: CardView!
    @IBOutlet weak var pageTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
