//
// Created by Анатолий Спитченко on 06.05.2021.
//

import Foundation
import RxSwift

protocol PokemonDataSource {

    func getNextPage(pageSize: Int, offset: Int) -> Single<[Pokemon]>
    func getDetails(name: PokemonName) -> Single<PokemonDetails>
}
