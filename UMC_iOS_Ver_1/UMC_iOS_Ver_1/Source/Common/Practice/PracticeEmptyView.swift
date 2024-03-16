//
//  PracticeEmptyView.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/07/03.
//

import UIKit
import SnapKit

class PracticeEmptyView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_script"))
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새로운 대본 연습을 시작해보세요"
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        
        label.text = "직접 대본을 만들고 실전처럼 연습해보세요."
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
}

extension PracticeEmptyView {
    private func setup() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        addSubview(subLabel)
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
