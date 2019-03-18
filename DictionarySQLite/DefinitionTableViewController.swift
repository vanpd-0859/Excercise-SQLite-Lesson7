//
//  DefinitionTableViewController.swift
//  DictionarySQLite
//
//  Created by Phan Dinh Van on 3/18/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit

class DefinitionTableViewController: UITableViewController {
    
    var db: SQLiteDatabase!
    var searchedWord = ""
    var searchedEntries = [Word]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60)
        let wordLabel = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 40)!]
        let attributedString = NSAttributedString(string: searchedWord, attributes: attributes)
        wordLabel.attributedText = attributedString
        header.addSubview(wordLabel)
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: wordLabel, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 10)
        let left = NSLayoutConstraint(item: wordLabel, attribute: .leading, relatedBy: .equal, toItem: header, attribute: .leading, multiplier: 1, constant: 20)
        let bottom = NSLayoutConstraint(item: wordLabel, attribute: .bottom, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1, constant: 10)
        let right = NSLayoutConstraint(item: wordLabel, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: header, attribute: .trailing, multiplier: 1, constant: 20)
        header.addConstraints([top, left, bottom, right])
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        
        
        if let db = try? SQLiteDatabase.open(path: (Bundle.main.url(forResource: "Dictionary", withExtension: "db")?.absoluteString)!) {
            self.db = db
            print("Successfully opened connection to database.")
            loadData()
            tableView.reloadData()
        }
    }
    
    func loadData() {
        searchedEntries = db.getWord(searchedWord)!
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "definition", for: indexPath) as! DefinitionCell
        cell.lblWordType.text = searchedEntries[indexPath.row].wordtype
        cell.lblDefinition.text = searchedEntries[indexPath.row].definition
        cell.lblNumber.text = "\(indexPath.row+1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
