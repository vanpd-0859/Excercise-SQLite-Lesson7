//
//  DefinitionCell.swift
//  DictionarySQLite
//
//  Created by Phan Dinh Van on 3/18/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit

class DefinitionCell: UITableViewCell {
    
    @IBOutlet weak var lblWordType: UILabel!
    @IBOutlet weak var lblDefinition: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        lblNumber.layer.cornerRadius = lblNumber.frame.size.width/2
        lblNumber.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
