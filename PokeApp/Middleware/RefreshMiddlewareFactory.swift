//
// Created by Анатолий Спитченко on 05.05.2021.
//

import RxSwift

struct RefreshMiddlewareFactory {

    static func makeMiddleware(dataSource: PokemonDataSource) -> Middleware<PokemonState, PokemonAction> {
        Middleware { states, actions in
            actions.filter { action in
                action.refresh
            }.withLatestFrom(states) { action, state -> PokemonState in
                state
            }.flatMapLatest { state -> Observable<PokemonAction> in
                dataSource.getNextPage(pageSize: pageSize, offset: 0)
                        .map { pokemons -> PokemonAction in
                            App.nextPage(pokemons: pokemons).asAction()
                        }
                        .catchAndReturn(App.refreshError.asAction())
                        .asObservable()
            }
        }
    }
}
