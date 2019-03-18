//
//  ViewController.swift
//  DictionarySQLite
//
//  Created by Phan Dinh Van on 3/18/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var tblDictionary: UITableView!
    @IBOutlet weak var searchWord: UISearchBar!
    var db: SQLiteDatabase!
    var entries = [Word]()
    var searchedWords = [Word]()
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDictionary.delegate = self
        tblDictionary.dataSource = self
        tblDictionary.tableFooterView = UIView()
        searchWord.delegate = self
        if let db = try? SQLiteDatabase.open(path: (Bundle.main.url(forResource: "Dictionary", withExtension: "db")?.absoluteString)!) {
            self.db = db
            print("Successfully opened connection to database.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    //MARK: Actions
    func loadData() {
        entries = db.getAllWords()!
        searchedWords = entries
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordcell", for: indexPath) as! WordCell
        cell.lblWord.text = searchedWords[indexPath.row].word
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let definitionCtrl = storyboard?.instantiateViewController(withIdentifier: "definitionCtrl") as! DefinitionTableViewController
        definitionCtrl.searchedWord = searchedWords[indexPath.row].word
        navigationController?.pushViewController(definitionCtrl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let btnEdit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            
        }
        btnEdit.backgroundColor = UIColor.blue
        let btnDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            do {
                print(self.searchedWords[indexPath.row].word as String)
                try self.db.deleteWord(self.searchedWords[indexPath.row].word as String)
                self.searchedWords.remove(at: indexPath.row)
                self.tblDictionary.reloadData()
                handler(true)
            } catch {
                print("Error while deleting word")
                handler(false)
            }
        }
        btnDelete.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [btnEdit, btnDelete])
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            searchedWords = entries
            self.tblDictionary.reloadData()
        } else {
            if timer != nil {
                timer.invalidate()
            }
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                self.searchTerm(searchText)
                self.tblDictionary.reloadData()
            })
        }
    }
    
    func searchTerm(_ keyword: String) {
        self.searchedWords = db.searchTerm(keyword) ?? []
    }
}
