//
//  ViewController.swift
//  PokeApp
//
//  Created by Анатолий Спитченко on 28.04.2021.
//

import UIKit
import RxSwift
import RxRelay

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var progress: UIActivityIndicatorView!
    @IBOutlet private weak var retryButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private let bag = DisposeBag()
    var store: Store<PokemonState, PokemonAction>!
    private let items = BehaviorRelay<[PokemonViewModelItem]>(value: [])
    private var retryPokemonClickListener: ((PokemonName) -> Void)!
    private var retryPageClickListener: (() -> Void)!

    override init(nibName: String?, bundle: Bundle?)   {
        super.init(nibName: nibName, bundle: bundle)
        initListeners()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initListeners()
    }

    private func initListeners() {
        retryPokemonClickListener = { [weak self] in
            self?.store.accept(action: PokemonAction.user(user: User.loadDetails(pokemonName: $0)))
        }
        retryPageClickListener = { [weak self] in
            self?.store.accept(action: PokemonAction.user(user: User.loadNextPage))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(PokemonCell.nib, forCellReuseIdentifier: PokemonCell.identifier)
        tableView?.register(ProgressCell.nib, forCellReuseIdentifier: ProgressCell.identifier)
        tableView?.register(RetryCell.nib, forCellReuseIdentifier: RetryCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        store.accept(action: PokemonAction.user(user: User.loadNextPage))

        store.states.map {
                    $0.toViewModels()
                }
                .do { [weak self] viewModels in
                    self?.items.accept(viewModels)
                    // TODO diff utils
                    self?.tableView.reloadData()
                }
                .subscribe()
                .disposed(by: bag)

        store.states.observe(on: MainScheduler.instance)
                .do { [weak self] state in
                    self?.progress.isVisible = state.emptyProgress
                    self?.retryButton.isVisible = state.emptyError
                    self?.errorLabel.isVisible = state.emptyError
                }
                .subscribe()
                .disposed(by: bag)
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items.value[indexPath.row]
        switch item.type {
        case .pokemon:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell {
                cell.setViewModel(viewModel: item)
                cell.setRetryClickListener(listener: retryPokemonClickListener)
                cell.selectionStyle = .none
                return cell
            }
        case .error:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RetryCell.identifier, for: indexPath) as? RetryCell {
                cell.setRetryClickListener(listener: retryPageClickListener)
                cell.selectionStyle = .none
                return cell
            }
        case .progress:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProgressCell.identifier, for: indexPath)
            cell.selectionStyle = .none
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.value.count
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.isReachingEnd) {
            store.accept(action: PokemonAction.user(user: User.loadNextPage))
        }
    }
}
