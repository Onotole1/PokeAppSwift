//
// Created by Анатолий Спитченко on 30.05.2021.
//

extension PokemonState {
    func toViewModels() -> [PokemonViewModelItem] {
        var pokemons = pokemonList.map { name -> PokemonViewModelItem in
            PokemonViewModePokemonItem(name: name, status: pokemonById[name]!.status)
        }
        switch status {
        case Status.nextPageProgress:
            pokemons.append(PokemonViewModelProgressItem())
        case Status.nextPageError:
            pokemons.append(PokemonViewModelErrorItem())
        default: break
        }
        return pokemons
    }
}
