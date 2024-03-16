//
//  ScriptListTableViewCell.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/01/31.
//

import UIKit

class ScriptListTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var info: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 2
        
        contentView.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16))
    }
}
