//
//  NameCell.swift
//  Demonstration
//
//  Created by Neil on 26/01/17.
//  Copyright © 2017 Neil's Ultimate Lab. All rights reserved.
//

import UIKit

class NameCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellImageView.layer.cornerRadius = 5.0
        self.cellImageView.layer.masksToBounds = true
        self.cellImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.cellImageView.layer.borderWidth = 0.4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with name: String, contact: String, email: String) {
        self.nameLabel.text = name
        self.numberLabel.text = contact
        self.emailLabel.text = email
    }

}
