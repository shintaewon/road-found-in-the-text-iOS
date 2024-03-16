//
//  Observable.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/17.
//

import Foundation
import RxSwift

extension PrimitiveSequence {
    func asEmpty<T>() -> Observable<T> {
        return self.asObservable().flatMap { _ in Observable<T>.empty()}
    }
}
