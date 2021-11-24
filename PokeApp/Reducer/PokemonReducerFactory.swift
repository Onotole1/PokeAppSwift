//
// Created by Анатолий Спитченко on 06.05.2021.
//

import Foundation

struct PokemonReducerFactory {

    static func makeReducer() -> (PokemonState, PokemonAction) -> PokemonState {
        { state, action in
            switch action {
            case .user(user: let user):
                switch user {
                case .loadNextPage:
                    var newState = state
                    if (newState.pokemonList.isEmpty) {
                        newState.status = PokemonState.Status.emptyProgress
                    } else {
                        newState.status = PokemonState.Status.nextPageProgress
                    }
                    return newState
                case .refresh:
                    var newState = state
                    newState.status = PokemonState.Status.refreshing
                    return newState
                case .loadDetails(pokemonName: let pokemonName):
                    var newState = state
                    var loaded = newState.pokemonById[pokemonName]!
                    loaded.status = Pokemon.Status.progress
                    newState.pokemonById[pokemonName] = loaded
                    return newState
                }
            case .app(app: let app):
                switch app {
                case .nextPage(pokemons: let pokemons):
                    var newState = state
                    newState.pokemonList = newState.pokemonList + pokemons.map { pokemon -> PokemonName in
                        pokemon.name
                    }
                    newState.pokemonById = newState.pokemonById.merging(pokemons.toDictionary { pokemon in
                        pokemon.name
                    }) { (pokemon: Pokemon, _) -> Pokemon in
                        pokemon
                    }
                    if (pokemons.count < pageSize) {
                        newState.status = PokemonState.Status.all
                    } else {
                        newState.status = PokemonState.Status.pages
                    }
                    return newState
                case .nextPageError:
                    var newState = state
                    if (newState.pokemonList.isEmpty) {
                        newState.status = PokemonState.Status.emptyError
                    } else {
                        newState.status = PokemonState.Status.nextPageError
                    }
                    return newState
                case .refreshError:
                    return state
                case .detailsLoadError(pokemonName: let pokemonName):
                    var newState = state
                    var loaded = newState.pokemonById[pokemonName]!
                    loaded.status = Pokemon.Status.error
                    newState.pokemonById[pokemonName] = loaded
                    return newState
                case .detailsLoaded(pokemonName: let pokemonName, details: let details):
                    var newState = state
                    var loaded = newState.pokemonById[pokemonName]!
                    loaded.status = Pokemon.Status.success(details: details)
                    newState.pokemonById[pokemonName] = loaded
                    return newState
                }
            }
        }
    }
}
