//
//  PokemonCell.swift
//  PokeApp
//
//  Created by Анатолий Спитченко on 15.05.2021.
//

import UIKit
import Kingfisher

class PokemonCell: UITableViewCell {

    class var identifier: String {
        String(describing: self)
    }
    class var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var retry: UIButton!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    
    private var name: PokemonName?
    private var retryClickListener: ((PokemonName) -> Void)?

    func setRetryClickListener(listener: @escaping (PokemonName) -> Void) {
        retryClickListener = listener
    }

    @IBAction func retryClicked(_ sender: Any) {
        guard let name = name else { return }
        retryClickListener?.self(name)
    }
    
    deinit {
        retryClickListener = nil
    }
}

extension PokemonCell: ViewModelSettable {
    func setViewModel(viewModel: PokemonViewModelItem) {
        guard let viewModel = viewModel as? PokemonViewModePokemonItem else {
            return
        }
        name = viewModel.name
        nameLabel.text = viewModel.name.value
        switch viewModel.status {
        case .empty:
            progress.isHidden = true
            retry.isHidden = true
        case .progress:
            progress.isHidden = false
            retry.isHidden = true
        case .error:
            progress.isHidden = true
            retry.isHidden = false
        case .success(details: let details):
            progress.isHidden = true
            retry.isHidden = true
            let url = URL(string: details.image ?? "")
            pokemonImage.kf.setImage(with: url)
        }
    }
}
