//
// Created by Анатолий Спитченко on 06.05.2021.
//

import Foundation
import RxAlamofire
import RxSwift

class PokemonNetworkDataSource: PokemonDataSource {

    func getNextPage(pageSize: Int, offset: Int) -> Single<[Pokemon]> {
        RxAlamofire.requestDecodable(
                        .get,
                        pokemonsUrl,
                        parameters: ["limit": 30, "offset": offset]
                )
                .map { (response: HTTPURLResponse, pokemons: PokemonListResponseDto) in
                    pokemons.results.map { dto -> Pokemon in
                        Pokemon(name: PokemonName(value: dto.name))
                    }
                }.asSingle()
    }

    func getDetails(name: PokemonName) -> Single<PokemonDetails> {
        RxAlamofire.requestDecodable(
                        .get,
                        {
                            var url = pokemonsUrl
                            url.appendPathComponent(name.value)
                            return url
                        }()
                )
                .map { (response: HTTPURLResponse, pokemon: PokemonDetailsDto) in
                    pokemon.toDetails()
                }.asSingle()
    }
}
