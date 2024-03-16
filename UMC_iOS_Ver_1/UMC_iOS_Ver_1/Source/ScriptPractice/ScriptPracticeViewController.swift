//
//  ScriptPracticeViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by 신태원 on 2023/01/07.
//

import UIKit
import SnapKit

class ScriptPracticeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var headerLabel = UILabel()
    private let emptyView = PracticeEmptyView()
    private let bottomButton = BottomButton(title: "새로운 대본 만들기", isBold: false, isBlack: true)
    
    var count = 0
    
    var userScript: MemberScript?
    private var scriptData = [Script]()
    
    @objc func didTapButton(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewScriptViewController") as? CreateNewScriptViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyPageDataManager().fetchMemberScriptData(id: 1, delegate: self)
        
        setTableViewStatus()
    }
    
    func setup() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        header.backgroundColor = .clear
        
        headerLabel = UILabel()
        headerLabel.text = "내 대본 \(scriptData.count)"
        headerLabel.font = .systemFont(ofSize: 14)
        headerLabel.textColor = .subTextColor
        
        header.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        tableView.tableHeaderView = header
        
        print("테이블뷰")
        
        view.addSubview(emptyView)
        
        emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(282)
            make.centerX.equalToSuperview()
        }
        
        bottomButton.addTarget(self, #selector(didTapButton))
        
        view.addSubview(bottomButton)
        
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 130 + 8
    }
    
    func setTableViewStatus() {
        headerLabel.text = "내 대본 \(scriptData.count)"
        
        if scriptData.isEmpty {
            emptyView.isHidden = false
        }
        else {
            emptyView.isHidden = true
            //            tableView.reloadData()
        }
    }
}

// MARK: - Networking
extension ScriptPracticeViewController: MyPageStorageDelegate, ScriptEditDelegate {
    func didFetchMemberScriptData(memberScript: MemberScript) {
        self.userScript = memberScript
        scriptData = [Script]()
        memberScript.scripts.forEach { script in
            ScriptEditDataManager().fetchScriptById(id: script.scriptId, delegate: self)
        }
    }
    
    func didFetchScriptById(result: Script) {
        self.scriptData.append(result)
        setTableViewStatus()
        tableView.reloadData()
    }
    
}

// MARK: - UITableView

extension ScriptPracticeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scriptData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScriptListTableViewCell", for: indexPath) as? ScriptListTableViewCell else{
            
            return UITableViewCell()
            
        }
        
        let script = scriptData[indexPath.row]
        
        cell.title.text = script.title
        cell.content.text = script.contents
        
        let scriptDate = Date().timeAgo(script.createdDate) + " 전"
        
        cell.info.text = String(script.paragraphList.count) + " 페이지 · " + scriptDate
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ScriptEdit", bundle: nil)
        guard let nextViewController = storyboard.instantiateViewController(withIdentifier: "ScriptEditTabmanViewController") as? ScriptEditTabmanViewController else {
            assert(false, "Can't load next vc")
            return
        }
        nextViewController.script = scriptData[indexPath.row]
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
