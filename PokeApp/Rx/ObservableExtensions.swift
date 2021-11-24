//
// Created by Анатолий Спитченко on 04.05.2021.
//

import Foundation
import RxSwift

extension Array {
    func merge<T>() -> Observable<T> where Array.Element == Observable<T> {
        Observable.merge(self)
    }
}

extension Observable {
    func mapNotNull<Result>(_ transform: @escaping (Element) throws -> Result?) -> Observable<Result> {
        map(transform).compactMap {
            $0
        }
    }
}
