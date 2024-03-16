//
//  MyPageProfileView.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/01/30.
//

import UIKit

class MyPageProfileView: UITableViewHeaderFooterView {
    
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var myScriptLabel: UILabel!
    @IBOutlet var rankImageView: UIImageView!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    static let identifier = "ProfileView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        detailButton.imageView?.setImageColor(color: UIColor(named: "Sub2") ?? UIColor())
        
        editButton.layer.borderColor = UIColor.sub3.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 4
    }
}
