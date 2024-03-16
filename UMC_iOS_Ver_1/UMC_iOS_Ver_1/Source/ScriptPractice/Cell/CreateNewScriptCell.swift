//
//  CreateNewScriptCell.swift
//  UMC_iOS_Ver_1
//
//  Created by 신태원 on 2023/01/23.
//

import UIKit

protocol CellDelegate: AnyObject {
    func didTap(_ cell: UITableViewCell, name: String, content: String)
}

protocol TableViewCellDelegate: AnyObject {
    func updateTextViewHeight(_ cell: UITableViewCell,_ textView:UITextView)
}

class CreateNewScriptCell: UITableViewCell {

    weak var delegateForHeight: TableViewCellDelegate?
    
    weak var delegate: CellDelegate?
    
    @IBOutlet weak var pageNameTextField: UITextField!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var contentTxtView: UITextView!
    
    private let textViewPlaceHolder = "내용을 작성하세요."
    
    func setTextView() {
        contentTxtView.layer.cornerRadius = 6
        contentTxtView.delegate = self
        contentTxtView.isScrollEnabled = false
        contentTxtView.sizeToFit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setTextView()
    }
}

extension CreateNewScriptCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegateForHeight {
            delegate.updateTextViewHeight(self, textView)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTxtView.text == textViewPlaceHolder {
            contentTxtView.text = nil
            contentTxtView.textColor = .mainTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentTxtView.text = textViewPlaceHolder
            contentTxtView.textColor = .sub2
        }
    }
}

