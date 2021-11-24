//
// Created by Анатолий Спитченко on 04.05.2021.
//

import RxSwift

struct Middleware<S, A> {

    let closure: (Observable<S>, Observable<A>) -> Observable<A>

    init(closure: @escaping (Observable<S>, Observable<A>) -> Observable<A>) {
        self.closure = closure
    }

    func connect(states: Observable<S>, actions: Observable<A>) -> Observable<A> {
        closure(states, actions)
    }
}
