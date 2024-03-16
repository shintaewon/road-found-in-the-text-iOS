//
//  WithdrawalViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/07/16.
//

import UIKit

class WithdrawalViewController: UIViewController {
    
    @IBOutlet var warningBackgroundView: UIView!
    @IBOutlet var warningImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        navigationItem.title = "탈퇴하기"
        
        warningBackgroundView.layer.cornerRadius = 6
        warningImageView.setImageColor(color: .systemRed)
    }
}
