//
//  ViewController.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Combine
import SnapKit
import UIKit

enum DataSource {
    case empty
    case characters([RAMCharacter])
    case locations([RAMLocation])
}

class ViewController: UIViewController {

    private let tableView = UITableView()
    private let optionStackView = UIStackView()
    private let charactersButton = UIButton()
    private let aliveCharactersButton = UIButton()
    private let locationsButton = UIButton()

//    private var characters = [RAMCharacter]()
    private var dataSource: DataSource = .empty

    private var interactor = Interactor()
    private var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        optionStackView.axis = .horizontal
        optionStackView.distribution = .fillEqually

        view.addSubview(tableView)
        view.addSubview(optionStackView)
        view.backgroundColor = .systemBlue
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        optionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(64)
        }

        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(optionStackView.snp.bottom)
        }

        [charactersButton, aliveCharactersButton, locationsButton].forEach { button in
            button.snp.makeConstraints { make in make.height.equalTo(64) }
            optionStackView.addArrangedSubview(button)
        }

        charactersButton.setTitle("Characters", for: .normal)
        charactersButton.addTarget(self, action: #selector(charactersButtonTapped), for: .touchUpInside)
        aliveCharactersButton.setTitle("Only Alive", for: .normal)
        aliveCharactersButton.addTarget(self, action: #selector(aliveCharactersButtonTapped), for: .touchUpInside)
        locationsButton.setTitle("Locations", for: .normal)
        locationsButton.addTarget(self, action: #selector(locationsButtonTapped), for: .touchUpInside)

        interactor
            .$currentState
            .receive(on: DispatchQueue.main)
            .sink { state in
                self.updateUI(for: state)
            }
            .store(in: &cancellables)

    }

    private func updateUI(for state: ViewState) {
        switch state {
        case .loading:
            dataSource = .empty
        case .characters(let characters):
            dataSource = .characters(characters)
        case .aliveCharacters(let characters):
            dataSource = .characters(characters)
        case .locations(let locations):
            dataSource = .locations(locations)
        case .error:
            break
        }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    @objc
    private func charactersButtonTapped(_ sender: UIButton) {
        interactor.fetchAllCharacters()
    }
    @objc
    private func aliveCharactersButtonTapped(_ sender: UIButton) {
        interactor.fetchAliveCharacters()
    }
    @objc
    private func locationsButtonTapped(_ sender: UIButton) {
        interactor.fetchAllLocations()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataSource {
        case .empty:
            return 0
        case .characters(let items):
            return items.count
        case .locations(let items):
            return items.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource {
        case .empty:
            return .init()
        case .characters(let characters):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
            guard indexPath.row < characters.count else { return .init() }
            let char = characters[indexPath.row]
            cell.textLabel?.text = char.name
            Task {
                if Task.isCancelled { return }
                await cell.imageView?.loadImage(from: char.imageURL)
                if Task.isCancelled { return }
                cell.layoutSubviews()
            }
            return cell
        case .locations(let locations):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
            guard indexPath.row < locations.count else { return .init() }
            let location = locations[indexPath.row]
            cell.textLabel?.text = location.displayText
            return cell
        }
    }
}

