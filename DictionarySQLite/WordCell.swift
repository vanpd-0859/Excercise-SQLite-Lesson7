//
//  WordCell.swift
//  DictionarySQLite
//
//  Created by Phan Dinh Van on 3/18/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit

class WordCell: UITableViewCell {

    @IBOutlet weak var lblWord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
