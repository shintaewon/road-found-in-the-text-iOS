//
//  ScriptPracticeRecordRoadingViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/01/23.
//

import UIKit

import Lottie

protocol ScriptPracticeRecordLoadingProtocol {
    func didFinishLoading(result: ScriptRecordData)
}

class ScriptPracticeRecordRoadingViewController: UIViewController {
    
    @IBOutlet var animationView: LottieAnimationView!
    
    var delegate: ScriptPracticeRecordLoadingProtocol?
    
    var scriptId: Int?
    var elapsedTime: Int?
    var answer: [PracticeAnswer]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureAnimationView()
        
        guard let elapsedTime = elapsedTime, let answer = answer else {
            assert(false)
            return
        }
        
        let parameters = ScriptRecordDataManager().setPostScriptParameters(elapsedTime: elapsedTime, answer: answer)
        
        guard let scriptId = scriptId else {
            assert(false)
            return
        }
        ScriptRecordDataManager().postScriptRecord(scriptId: scriptId, parameters: parameters, delegate: self)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.dismiss(animated: false) {
//                self.delegate?.didFinishLoading()
//            }
//        }
    }
    
    func configureAnimationView() {
        let customAnimationView = LottieAnimationView(name: "Loading")
        
        customAnimationView.frame = animationView.bounds
        customAnimationView.contentMode = .scaleAspectFit
        
        customAnimationView.loopMode = .loop
        customAnimationView.play()
        animationView.addSubview(customAnimationView)
    }

}

extension ScriptPracticeRecordRoadingViewController: ScriptRecordPostDelegate {
    func didPostScriptRecord(result: ScriptRecordData) {
        self.dismiss(animated: false) {
            self.delegate?.didFinishLoading(result: result)
        }
    }
}
