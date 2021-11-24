//
//  PokemonDetailsDto.swift
//  PokeApp
//
//  Created by Анатолий Спитченко on 30.04.2021.
//

struct PokemonDetailsDto: Codable {
    var name: String = ""
    var types: [TypeDto] = []
    var sprites: SpritesDto?
}

extension PokemonDetailsDto {
    func toDetails() -> PokemonDetails {
        PokemonDetails(
                types: types.map {
                    PokemonType(name: $0.type.name)
                },
                image: sprites?.toImageUrl()
        )
    }
}
