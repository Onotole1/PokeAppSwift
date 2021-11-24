//
// Created by Анатолий Спитченко on 29.05.2021.
//

import RxSwift

class GetPokemonDetailsMiddlewareFactory {

    static func makeMiddleware(dataSource: PokemonDataSource) -> Middleware<PokemonState, PokemonAction> {
        Middleware { states, actions in
            actions.mapNotNull { (action: PokemonAction) -> PokemonName? in
                action.loadDetails
            }.withLatestFrom(states) { name, state -> (PokemonName, PokemonState) in
                (name, state)
            }.flatMap { (name: PokemonName, state: PokemonState) -> Observable<PokemonAction> in
                dataSource.getDetails(name: name).map { details -> PokemonAction in
                            PokemonAction.app(app: App.detailsLoaded(pokemonName: name, details: details))
                        }
                        .catchAndReturn(.app(app: App.detailsLoadError(pokemonName: name)))
                        .asObservable()
                        .take(until: actions.filter { (action: PokemonAction) in
                            action.refresh
                        })
            }
        }
    }
}
