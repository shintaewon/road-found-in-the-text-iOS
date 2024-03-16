//
//  ScriptEditTabmanViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/01/10.
//

import UIKit

import Tabman
import Pageboy

class ScriptEditTabmanViewController: TabmanViewController {
    
    var scriptTitle = ""
    var script: Script?
    
    private var viewControllers = [UIViewController]()
    private let barButtonTitle = ["편집", "연습", "기록"]
    var pageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers()

        self.dataSource = self
        self.isScrollEnabled = false

        let bar = TMBarView<TMHorizontalBarLayout, ImageLabelBarButton, TMLineBarIndicator>()
        
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .none
        bar.backgroundColor = .white
        
        // 버튼 정렬 및 간격
        bar.layout.alignment = .centerDistributed
        bar.layout.interButtonSpacing = 80
        
        // 하단 인디케이터 바 설정
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.tintColor = .black
        
        addBar(bar, dataSource: self, at: .top)
        
        // TODO: id 이전 화면에서 받아오는 걸로 수정해야 함!!!!
        guard let script = script else {
            assert(false)
            return
        }
        self.navigationItem.title = script.title
        
        if let vc = viewControllers[1] as? ScriptPracticeSetViewController {
            vc.script = script
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationItem()
        reloadData()
    }
    
    func configureNavigationItem() {
        self.navigationItem.title = script?.title ?? ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_more"), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
    }
    
    @objc func rightBarButtonItemTapped() {
        print("더보기")
    }
    
    func setViewControllers() {
        guard let scriptEditViewController = storyboard?.instantiateViewController(withIdentifier: "ScriptEditViewController") as? ScriptEditViewController else {
            assert(false)
            return
        }
        
        scriptEditViewController.script = script
        
        viewControllers.append(scriptEditViewController)
        
        var storyboard = UIStoryboard(name: "ScriptPracticeSet", bundle: nil)
        guard let practiceSetViewController = storyboard.instantiateViewController(withIdentifier: "ScriptPracticeSetViewController") as? ScriptPracticeSetViewController else {
            assert(false, "Can't load set vc")
            return
        }
        
        practiceSetViewController.script = script
        
        viewControllers.append(practiceSetViewController)
        
        storyboard = UIStoryboard(name: "ScriptRecord", bundle: nil)
        
        guard let recordViewController = storyboard.instantiateViewController(withIdentifier: "ScriptRecordViewController") as? ScriptRecordViewController else {
            assert(false, "Can't load record vc")
            return
        }
        
        recordViewController.scriptId = script?.scriptId
        
        viewControllers.append(recordViewController)
    }
    
    override func bar(_ bar: TMBar, didRequestScrollTo index: PageboyViewController.PageIndex) {
        super.bar(bar, didRequestScrollTo: index)
        
        self.navigationItem.rightBarButtonItem?.isHidden = index == 1 ? true : false
    }

}

// MARK: - Tabman
extension ScriptEditTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return 3
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: self.pageIndex)
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var image: UIImage
        if index == 0 {
            image = UIImage(named: "ic_edit")!
        } else if index == 1 {
            image = UIImage(named: "ic_script")!
        } else {
            image = UIImage(named: "ic_bar chart")!
        }
        return TMBarItem(title: barButtonTitle[index], image: image)
    }
}
