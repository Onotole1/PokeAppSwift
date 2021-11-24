//
//  SpritesDto.swift
//  PokeApp
//
//  Created by Анатолий Спитченко on 29.05.2021.
//

struct SpritesDto: Codable {
    var backDefault: String?
    var backFemale: String?
    var backShiny: String?
    var backShinyFemale: String?
    var frontDefault: String?
    var frontFemale: String?
    var frontShiny: String?
    var frontShinyFemale: String?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}

extension SpritesDto {
    func toImageUrl() -> String? {
        var image = frontDefault
        if image == nil {
            image = frontShiny
        }
        if image == nil {
            image = frontFemale
        }
        if image == nil {
            image = frontShinyFemale
        }
        if image == nil {
            image = backDefault
        }
        if image == nil {
            image = backShiny
        }
        if image == nil {
            image = backFemale
        }
        if image == nil {
            image = backShinyFemale
        }

        return image
    }
}
