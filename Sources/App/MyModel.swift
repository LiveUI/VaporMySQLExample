//
//  MyModel.swift
//  App
//
//  Created by Ondrej Rafaj on 09/01/2018.
//

import Foundation
import Fluent
import FluentMySQL
import Vapor


final class TestModel: Model, Content {
    typealias Database = MySQLDatabase
    typealias ID = Int
    static var idKey = \TestModel.id
    var id: Int?
    var type: String
    init() { self.id = nil; self.type = ".text" }
}

extension TestModel: Migration {
    
//    static func prepare(on connection: Database.Connection) -> Future<Void> {
//          // You can make custom CREATE TABLE here
//    }
    
}
