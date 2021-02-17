//
//  Login.swift
//  
//
//  Created by Jan Bjelicic on 31/01/2021.
//

import Vapor
import Fluent
import FluentSQLiteDriver

extension FieldKey {
    static var email: Self { "email" }
    static var password: Self { "password" }
    static var date: Self { "date" }
}

final class User: Content, Model, Migration {
    
    static let schema = "Login"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .email)
    var email: String
    
    @Field(key: .password)
    var password: String
    
    @OptionalField(key: .date)
    var date: Date?
    
    init() { }

    init(id: UUID? = nil, email: String, password: String, date: Date?) {
        self.id = id
        self.email = email
        self.password = password
        self.date = date
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .id()
            .field(.email, .string, .required)
            .field(.password, .string, .required)
            .field(.date, .date, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
    
}


