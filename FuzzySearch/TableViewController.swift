//
//  TableViewController.swift
//  FuzzySearch
//
//  Created by Uldis Zingis on 17/11/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {

    var allwords = [[String]]()
    var words = [[String]]()

    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        loadWords()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let term = searchBar.text else { return }
        
        fuzzySearch(term: term)
        
        tableView.reloadData()
    }

    func fuzzySearch(term: String) {
        words = [[]]
        for word in allwords {
            let wordLetters: [Character] = (word.first?.lowercased().characters.flatMap { $0 })!
            let searchLetters: [Character] = term.lowercased().characters.flatMap({ $0 })
            let wordSet = Set(wordLetters)
            let searchSet = Set(searchLetters)

            if searchSet.isSubset(of: wordSet) {
                words.append(word)
            }
        }
    }

    func loadWords() {
        guard let path = Bundle.main.path(forResource: "dictionary", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

            guard let dict = jsonObj as? [String: Any] else { return }
            for obj in dict {
                let objDict = [obj.key, "\(obj.value)"]
                self.allwords.append(objDict)
            }

        } catch {
            NSLog(error.localizedDescription)
        }
        words = allwords
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)

        let word = words[indexPath.row] as [String]
        cell.textLabel?.text = word.first
        cell.detailTextLabel?.text = word.last

        return cell
    }
}


