//
//  MainCell.swift
//  Demonstration
//
//  Created by Neil on 26/01/17.
//  Copyright © 2017 Neil's Ultimate Lab. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView.layer.cornerRadius = 5.0
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.borderColor = UIColor.lightGray.cgColor
        cellImageView.layer.borderWidth = 0.4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(image: String, title: String, indexPath: IndexPath) {
        self.titleLabel.text = title
        WebserviceManager().getImage(from: image, for: indexPath) { (image) in
            self.cellImageView.image = image
        }
    }

}
