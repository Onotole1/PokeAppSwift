//
// Created by Анатолий Спитченко on 30.05.2021.
//

struct PokemonViewModePokemonItem: PokemonViewModelItem {
    var type: PokemonTableItemType {
        PokemonTableItemType.pokemon
    }
    var name: PokemonName
    var status: Pokemon.Status

    init(name: PokemonName, status: Pokemon.Status) {
        self.name = name
        self.status = status
    }
}
