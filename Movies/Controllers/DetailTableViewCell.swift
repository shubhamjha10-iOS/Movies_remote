//
//  DetailTableViewCell.swift
//  Movies
//
//  Created by Shubham Kumar on 27/08/24.
//

import UIKit

class DetailTableViewCell: UITableViewCell, CoordinatedViewController {
    
    
   weak var coordinator: Coordinator?
    
    
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

 
}
