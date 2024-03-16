//
//  ScriptPracticeRecordResultViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/01/16.
//

import UIKit

import Charts

class ScriptPracticeRecordResultViewController: UIViewController {
    
    // MARK: - Properteis
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var resultChart: RadarChartView!
    
    @IBOutlet var memoView: UIView!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var memoTextCountLabel: UILabel!
    
    @IBOutlet var doneButton: UIButton!
    
    var scriptId: Int?
    var result: ScriptRecordData?
    
    private let resultChartLabels = ["분석력", "논리력", "창의력", "전달력", "전문성"]
    private let memoTextViewPlaceholder = "내용을 입력해주세요."

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.delegate = self
        self.dismissKeyboardWhenTappedAround()
        
        style()
        configureResultChart()
    }
    
    func style() {
        self.navigationItem.title = "연습 기록"
        self.navigationItem.hidesBackButton = true
        
        titleLabel.text = "와우! \(result?.resultCount ?? 0)번째 연습이네요!"
        subtitleLabel.text = "\(result?.resultCount ?? 0)번째 연습 결과를 분석해보았어요."

                                                                                          
        memoView.layer.cornerRadius = 8
        memoView.layer.borderColor = UIColor(named: "Sub4")?.cgColor
        memoView.layer.borderWidth = 1
        
        doneButton.layer.cornerRadius = 8
        
        updateMemoTextCountLabel(length: 0)
    }
    
    func updateMemoTextCountLabel(length: Int) {
        
        let fullText = "\(length) / 60"

        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: String(length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
        memoTextCountLabel.attributedText = attributedString
    }
    
    func configureResultChart() {
        guard let result = result else {
            assert(false)
            return
        }
        
        let backgroundDataSet = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 5.0),
                RadarChartDataEntry(value: 5.0),
                RadarChartDataEntry(value: 5.0),
                RadarChartDataEntry(value: 5.0),
                RadarChartDataEntry(value: 5.0),
            ]
        )
        
        let dataSet = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: result.score1),
                RadarChartDataEntry(value: result.score2),
                RadarChartDataEntry(value: result.score3),
                RadarChartDataEntry(value: result.score4),
                RadarChartDataEntry(value: result.score5),
            ]
        )
        
        let data = RadarChartData()
        data.dataSets = [backgroundDataSet, dataSet]
        
        // Style
        resultChart.isUserInteractionEnabled = false
        resultChart.legend.enabled = false
        resultChart.webLineWidth = 0
        resultChart.innerWebColor = UIColor(named: "Sub3") ?? UIColor()
        
        backgroundDataSet.drawValuesEnabled = false
        backgroundDataSet.colors = [.clear]
        backgroundDataSet.fillColor = UIColor(named: "Sub4") ?? UIColor()
        backgroundDataSet.drawFilledEnabled = true
        
        dataSet.colors = [.systemBlue]
        dataSet.lineWidth = 2
        dataSet.drawValuesEnabled = false
        
        let xAxis = resultChart.xAxis
        xAxis.labelFont = .boldSystemFont(ofSize: 14)
        xAxis.labelTextColor = UIColor(named: "Sub1") ?? UIColor()
        xAxis.valueFormatter = IndexAxisValueFormatter(values: resultChartLabels)
        
        let yAxis = resultChart.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 4
        yAxis.drawLabelsEnabled = false
        
        
        resultChart.data = data
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if memoTextView.text.isExists && memoTextView.text != memoTextViewPlaceholder {
            guard let scriptId = scriptId else {
                assert(false)
                return
            }
            ScriptPracticeRecordResultDataManager().postScriptRecordMemo(scriptId: scriptId, memo: memoTextView.text, delegate: self)
        } else {
            pushNextViewController()
        }
    }
    
    func pushNextViewController() {
        let storyboard = UIStoryboard(name: "ScriptPracticeRecordEnd", bundle: nil)
        guard let nextViewController = storyboard.instantiateViewController(withIdentifier: "ScriptPracticeRecordEndViewController") as? ScriptPracticeRecordEndViewController else {
            assert(false)
            return
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

// MARK: - Networking
extension ScriptPracticeRecordResultViewController: ScriptRecordMemoDelegate {
    func didPostScriptRecordMemo() {
        pushNextViewController()
    }
}

// MARK: - UITextViewDelegate
extension ScriptPracticeRecordResultViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == memoTextViewPlaceholder {
            textView.text = nil
            textView.textColor = UIColor(named: "Sub1")
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoTextViewPlaceholder
            textView.textColor = UIColor(named: "Sub2")
            updateMemoTextCountLabel(length: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textLength = textView.text.count + text.count
        let isAtLimit = textLength <= 60
        
        return isAtLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateMemoTextCountLabel(length: textView.text.count)
    }
}
