//
//  ViewController.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var characters = [RAMCharacter]()

    private let client = APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            do {
                characters = try await client.fetch(service: CharacterService.allCharacters).results
                tableView.reloadData()
            } catch {
                print("There was an error: \(error)")
            }
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        128
    }
}

