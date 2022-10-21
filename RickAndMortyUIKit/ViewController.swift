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
                print("about to fetch characters...")
                characters = try await client.fetch(service: CharacterService.allCharacters).results
                tableView.reloadData()
                print("fetched characters.")
            } catch {
                print("There was an error: \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("providing count: \(characters.count)")
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard indexPath.row < characters.count else {
            print("indexPath.row (\(indexPath.row) is greater or equal to characters.count (\(characters.count)")
            return .init()
        }
        print("in cellForRow, good indexPath.row: \(indexPath.row)")
        let char = characters[indexPath.row]
        cell.textLabel?.text = char.name
        return cell

        // BJ: was going to add a Task for image fetching and display, async/await style, that can cancel if cell is enqueued for reuse
    }
}

