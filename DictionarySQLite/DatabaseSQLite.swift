//
//  DatabaseSQLite.swift
//  DictionarySQLite
//
//  Created by Phan Dinh Van on 3/18/19.
//  Copyright © 2019 Phan Dinh Van. All rights reserved.
//

import Foundation

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

class SQLiteDatabase {
    fileprivate let dbPointer: OpaquePointer?
    fileprivate var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }

    
    fileprivate init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer? = nil
        // 1
        if sqlite3_open(path, &db) == SQLITE_OK {
            // 2
            return SQLiteDatabase(dbPointer: db)
        } else {
            // 3
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String.init(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    func close() {
        sqlite3_close(dbPointer)
    }
    
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        
        return statement
    }
    
    func getAllWords() -> [Word]? {
        let queryString = "SELECT DISTINCT word FROM entries;"
        guard let queryStatement = try? prepareStatement(sql: queryString) else {
            return nil
        }
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var entries = [Word]()
        while(sqlite3_step(queryStatement) == SQLITE_ROW) {
            let word = String(cString: sqlite3_column_text(queryStatement, 0))
            var wordElement = Word()
            wordElement.word = word
            entries.append(wordElement)
        }
        return entries
    }
    
    func  getWord(_ word: String) -> [Word]? {
        let queryString = "SELECT * FROM entries WHERE UPPER(word) = UPPER(\"\(word)\");"
        guard let queryStatement = try? prepareStatement(sql: queryString) else {
            return nil
        }
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var entries = [Word]()
        while(sqlite3_step(queryStatement) == SQLITE_ROW) {
            let wordtype = String(cString: sqlite3_column_text(queryStatement, 1))
            let definition = String(cString: sqlite3_column_text(queryStatement, 2))
            var wordElement = Word()
            wordElement.wordtype = wordtype
            wordElement.definition = definition
            entries.append(wordElement)
        }
        return entries
    }
    
    func searchTerm(_ keyword: String) -> [Word]? {
        let queryString = "SELECT DISTINCT word FROM entries WHERE UPPER(word) LIKE UPPER(\"%\(keyword)%\");"
        guard let queryStatement = try? prepareStatement(sql: queryString) else {
            return nil
        }
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var entries = [Word]()
        while(sqlite3_step(queryStatement) == SQLITE_ROW) {
            let word = String(cString: sqlite3_column_text(queryStatement, 0))
            var wordElement = Word()
            wordElement.word = word
            entries.append(wordElement)
        }
        return entries
    }
    
    func addWord(_ word: Word) throws {
        let queryString = "INSERT INTO entries (word, wordtype, definition) VALUES (?, ?, ?);"
        guard let queryStatement = try? prepareStatement(sql: queryString) else {
            throw  SQLiteError.Prepare(message: errorMessage)
        }
        
        defer {
            sqlite3_finalize(queryStatement)
        }

        guard sqlite3_bind_text(queryStatement, 1, (word.word! as NSString).utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(queryStatement, 2, ((word.wordtype ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_text(queryStatement, 3, (word.definition! as NSString).utf8String, -1, nil) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Added word success!")
    }
    
    func deleteWord(_ word: String) throws {
        let queryString = "DELETE FROM entries WHERE word = \"\(word)\";"
        print(queryString)
        guard let queryStatement = try? prepareStatement(sql: queryString) else {
            throw  SQLiteError.Prepare(message: errorMessage)
        }
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Deleted word success!")
    }
}
