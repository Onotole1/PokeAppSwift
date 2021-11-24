//
//  PokemonCell.swift
//  PokeApp
//
//  Created by Анатолий Спитченко on 15.05.2021.
//

import UIKit

class RetryCell: UITableViewCell {

    class var identifier: String {
        String(describing: self)
    }
    class var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    private var retryClickListener: (() -> Void)?

    func setRetryClickListener(listener: @escaping () -> Void) {
        retryClickListener = listener
    }
    
    @IBAction func retryClicked(_ sender: Any) {
        retryClickListener?.self()
    }

    deinit {
        retryClickListener = nil
    }
}

