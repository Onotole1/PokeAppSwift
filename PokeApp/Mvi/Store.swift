//
// Created by Анатолий Спитченко on 04.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

class Store<S: Equatable, A> {

    private let actions: PublishRelay<A> = PublishRelay()
    private let _states: BehaviorRelay<S>
    private let disposables = DisposeBag()
    var states: Observable<S> {
        _states.asObservable()
    }
    var currentState: S {
        _states.value
    }

    init(middlewares: [Middleware<S, A>], defaultValue: S, reducer: @escaping (S, A) -> S) {
        _states = BehaviorRelay(value: defaultValue)

        middlewares.map { middleware in
                    middleware.connect(states: _states.asObservable(), actions: actions.asObservable())
                }.merge()
                .subscribe(onNext: { [weak actions] in
                    actions?.accept($0)
                }).disposed(by: disposables)

        actions.map { [weak _states] action in
                    reducer(_states?.value ?? defaultValue, action)
                }.distinctUntilChanged()
                .subscribe(onNext: { [weak _states] in
                    _states?.accept($0)
                })
                .disposed(by: disposables)
    }

    func accept(action: A) {
        actions.accept(action)
    }
}
