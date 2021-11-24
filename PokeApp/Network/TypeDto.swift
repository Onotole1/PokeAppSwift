//
// Created by Анатолий Спитченко on 29.05.2021.
//

struct TypeDto: Codable {
    var slot: Int
    var type: NestedTypeDto

    struct NestedTypeDto: Codable {
        var name: String
    }
}
