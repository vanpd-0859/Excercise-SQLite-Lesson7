//
//  AddEditViewController.swift
//  DictionarySQLite
//
//  Created by Phan Dinh Van on 3/18/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var txtWord: UITextField!
    @IBOutlet weak var txtWordType: UITextField!
    @IBOutlet weak var txvDefinition: UITextView!
    @IBOutlet weak var btnButton: UIButton!
    @IBOutlet weak var lblWordError: UILabel!
    @IBOutlet weak var lblDefinitionError: UILabel!
    var isEditMode = false
    var db: SQLiteDatabase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txvDefinition.delegate = self
        if let db = try? SQLiteDatabase.open(path: (Bundle.main.url(forResource: "Dictionary", withExtension: "db")?.absoluteString)!) {
            self.db = db
            print("Successfully opened connection to database.")
        }
    }
    
    @IBAction func wordEdit(_ sender: UITextField) {
        if let text = sender.text, text.isEmpty {
            self.lblWordError.isHidden = false
            self.lblWordError.text = "Word is empty!"
        } else {
            lblWordError.isHidden = true
        }
    }
    
    //MARK: Actions
    @IBAction func clickButton(_ sender: Any) {
        guard let definition = txvDefinition.text, !definition.isEmpty else {
            return
        }
        guard let wordtext = txtWord.text, !wordtext.isEmpty else {
            return
        }
        let word = Word.init(word: txtWord.text, wordtype: txtWordType.text, definition: txvDefinition.text)
        do {
            try db.addWord(word)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Error while adding")
        }
    }
    
}
extension AddEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text, text.isEmpty {
            self.lblDefinitionError.isHidden = false
            self.lblDefinitionError.text = "Definition is empty!"
        } else {
            lblDefinitionError.isHidden = true
        }
    }
}
