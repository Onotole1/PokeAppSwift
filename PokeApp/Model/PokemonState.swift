//
// Created by Анатолий Спитченко on 04.05.2021.
//

import Foundation

struct PokemonState: Equatable {
    var pokemonById: [PokemonName: Pokemon] = [:]
    var pokemonList: [PokemonName] = []
    var status = Status.empty

    enum Status: Equatable {
        case empty
        case pages
        case emptyProgress
        case emptyError
        case all
        case nextPageError
        case nextPageProgress
        case refreshing
    }
}

extension PokemonState {

    var emptyError: Bool {
        status == Status.emptyError
    }

    var emptyProgress: Bool {
        status == Status.emptyProgress
    }
}