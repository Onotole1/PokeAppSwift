//
// Created by Анатолий Спитченко on 05.05.2021.
//

import Foundation
import RxSwift

struct NextPageMiddlewareFactory {

    static func makeMiddleware(dataSource: PokemonDataSource) -> Middleware<PokemonState, PokemonAction> {
        Middleware { states, actions in
            actions.filter { action in
                action.loadNextPage
            }.withLatestFrom(states) { action, state -> PokemonState in
                state
            }.filter { state in
                switch state.status {
                case .empty,
                     .pages,
                     .emptyError,
                     .nextPageError:
                    return true
                default:
                    return false
                }
            }.flatMapLatest { state -> Observable<PokemonAction> in
                dataSource.getNextPage(pageSize: pageSize, offset: state.pokemonList.count)
                        .asObservable()
                        .flatMap { pokemons -> Observable<PokemonAction> in
                            Observable.from([
                                App.nextPage(pokemons: pokemons).asAction()
                            ] + pokemons.map({ pokemon in
                                User.loadDetails(pokemonName: pokemon.name).asAction()
                            }))
                        }
                        .catchAndReturn(App.nextPageError.asAction())
                        .take(until: actions.filter { (action: PokemonAction) in
                            action.refresh
                        })
            }
        }
    }
}
