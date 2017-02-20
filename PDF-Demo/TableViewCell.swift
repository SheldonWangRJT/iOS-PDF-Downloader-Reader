//
//  TableViewCell.swift
//  PDF-Demo
//
//  Created by Xiaodan Wang on 2/14/17.
//  Copyright © 2017 Xiaodan Wang. All rights reserved.
//

import UIKit

protocol cellDelegate {
    func didClickDownloadButton(cell:UITableViewCell)
    func didClickViewButton(cell:UITableViewCell)
}


class TableViewCell: UITableViewCell {

    var delegate:cellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    
    
    @IBAction func downloadTapped(_ sender: Any) {
        print("downloadTapped")
        
        delegate?.didClickDownloadButton(cell: self)
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        print("viewTapped")
        
        delegate?.didClickViewButton(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewButton.isEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
