//
//  PokemonCell.swift
//  PokeApp
//
//  Created by Анатолий Спитченко on 15.05.2021.
//

import UIKit

class ProgressCell: UITableViewCell {

    class var identifier: String {
        String(describing: self)
    }
    class var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}

