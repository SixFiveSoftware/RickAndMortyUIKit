//
//  ViewController.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import SnapKit
import UIKit

class ViewController: UIViewController {

    private let tableView = UITableView()
    private let optionStackView = UIStackView()
    private let charactersButton = UIButton()
    private let aliveCharactersButton = UIButton()
    private let locationsButton = UIButton()

    private var characters = [RAMCharacter]()

    private let client = APIClient()

    override func loadView() {
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            optionStackView.addArrangedSubview(button)
        }

        charactersButton.setTitle("Characters", for: .normal)
        aliveCharactersButton.setTitle("Only Alive", for: .normal)
        locationsButton.setTitle("Locations", for: .normal)
    }

    @objc
    private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case charactersButton:
            Task {
                do {
                    characters = try await client.fetch(service: CharacterService.allCharacters).results
                    tableView.reloadData()
                } catch {
                    print("There was an error fetching all characters: \(error)")
                }
            }
        case aliveCharactersButton:
            Task {
                do {
                    characters = try await client.fetch(service: CharacterService.status(.alive)).results
                    tableView.reloadData()
                } catch {
                    print("There was an error fetching alive characters: \(error)")
                }
            }
        case locationsButton:
            break
        default:
            break
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
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
    }
}

