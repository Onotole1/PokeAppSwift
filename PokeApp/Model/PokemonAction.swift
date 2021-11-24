//
// Created by Анатолий Спитченко on 04.05.2021.
//

import Foundation

enum PokemonAction {
    indirect case user(user: User)
    indirect case app(app: App)
}

indirect enum User {
    case loadNextPage
    case refresh
    case loadDetails(pokemonName: PokemonName)
}

indirect enum App {
    case nextPage(pokemons: [Pokemon])
    case nextPageError
    case refreshError
    case detailsLoaded(pokemonName: PokemonName, details: PokemonDetails)
    case detailsLoadError(pokemonName: PokemonName)
}

extension App {
    func asAction() -> PokemonAction {
        PokemonAction.app(app: self)
    }
}

extension User {
    func asAction() -> PokemonAction {
        PokemonAction.user(user: self)
    }
}

extension PokemonAction {
    var refresh: Bool {
        switch self {
        case .user(user: let user):
            switch user {
            case .refresh:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    var loadNextPage: Bool {
        switch self {
        case .user(user: let user):
            switch user {
            case .loadNextPage:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    var loadDetails: PokemonName? {
        switch self {
        case .user(user: let user):
            switch user {
            case .loadDetails(pokemonName: let pokemonName):
                return pokemonName
            default:
                return nil
            }
        default:
            return nil
        }
    }
}
