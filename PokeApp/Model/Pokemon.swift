//
//  Pokemon.swift
//  PokeApp
//
//  Created by Анатолий Спитченко on 30.04.2021.
//

struct Pokemon: Equatable {
    var name = PokemonName()
    var status = Status.empty

    enum Status: Equatable {
        case empty
        case progress
        case error
        case success(details: PokemonDetails)
    }
}
