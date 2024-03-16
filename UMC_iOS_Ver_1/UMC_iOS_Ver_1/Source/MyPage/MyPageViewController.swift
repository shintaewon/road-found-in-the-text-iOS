//
//  MyPageScrollViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/01/30.
//

import UIKit

import Kingfisher

enum Setting: Int {
    case proposal = 0
    case terms
    case privacy
    case logout
    case delete
}

class MyPageViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let menu = ["문의하기", "이용약관", "개인정보 처리방침", "로그아웃"]
    private var userInfo: MemberResponse?
    private var scriptCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        profileView.detailButton.addTarget(self, action: #selector(headerDetailButtonTapped), for: .touchUpInside)
        
        
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserData()
    }
    
    private func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationItem.title = "마이페이지"
        
        //        let notificationBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_bell"), style: .plain, target: self, action: #selector(notificationBarButtonItemTapped))
        //        let settingBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_settings"), style: .plain, target: self, action: #selector(settingBarButtonItemTapped))
        //        
        //        notificationBarButtonItem.tintColor = UIColor(named: "Main")
        //        settingBarButtonItem.tintColor = UIColor(named: "Main")
        //        
        //        self.navigationItem.rightBarButtonItems = [settingBarButtonItem, notificationBarButtonItem]
    }
    
    private func configureTableView() {
        let header = UINib(nibName: "MyPageProfileView", bundle: nil)
        tableView.register(header, forHeaderFooterViewReuseIdentifier: MyPageProfileView.identifier)
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
    }
}

// MARK: - Actions
extension MyPageViewController {
    @objc func profileDetailButtonTapped() {
        guard let nextViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "RankViewController") as? RankViewController else {
            assert(false)
            return
        }
        
        nextViewController.userRank = userInfo?.tier
        nextViewController.userScriptCount = scriptCount
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func profileEditButtonTapped() {
        guard let nextViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "ProfileEditViewController") as? ProfileEditViewController else {
            assert(false)
            return
        }
        
        nextViewController.nickname = userInfo?.nickName
        nextViewController.introduction = userInfo?.introduction
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

// MARK: - Networking

extension MyPageViewController {
    func getUserData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        MyPageService.getMemberInfo { response in
            self.userInfo = response
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ScriptService.getUserAllScript { response in
            self.scriptCount = response.count
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier) as? MyPageTableViewCell else {
            assert(false)
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        if indexPath.row != 4 {
            cell.titleLabel.text = menu[indexPath.row]
            cell.chevronImageView.isHidden = false
            cell.titleLabel.textColor = indexPath.row == 3 ? .systemBlue : .mainTextColor
        } else {
            cell.styleDeleteAccount()
        }
        
        cell.chevronImageView.isHidden = indexPath.row == 3 || indexPath.row == 4
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageProfileView.identifier) as? MyPageProfileView else {
            assert(false)
            return UIView()
        }
        
        if let userInfo = userInfo {
            header.nicknameLabel.text = userInfo.nickName
            header.bioLabel.text = userInfo.introduction
            header.rankImageView.image = UIImage(named: "Rank \(userInfo.tier)")
        }
        
        
        header.detailButton.addTarget(self, action: #selector(profileDetailButtonTapped), for: .touchUpInside)
        header.editButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 188
    }
}

// MARK: - UITableViewDelegate

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = Setting(rawValue: indexPath.row)
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        var nextViewController = UIViewController()
        
        switch menu {
        case .proposal:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "ProposalViewController")
        case .terms:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "TermsOfUseViewController")
        case .privacy:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController")
        case .logout:
            print("logout")
        case .delete:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "WithdrawalViewController")
        case .none:
            assert(false)
        }
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
