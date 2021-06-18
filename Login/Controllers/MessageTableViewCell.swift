//
//  MessageTableViewCell.swift
//  Login
//
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var nombreTextLabel: UILabel!
    @IBOutlet weak var mensajeTextLabel: UILabel!
    @IBOutlet weak var usuarioImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Volver redondo el ImageView
        self.usuarioImageView.layer.masksToBounds = true
        self.usuarioImageView.layer.cornerRadius = self.usuarioImageView.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
