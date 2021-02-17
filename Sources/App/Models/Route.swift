import Vapor
import Fluent
import FluentSQLiteDriver

extension FieldKey {
    
    static var nameText: Self { "nameText" }
    static var pathToGpxFile: Self { "pathToGpxFile" }
    
}

final class Route: Content, Model, Migration {
    
    static let schema = "Route"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .nameText)
    var nameText: String
    
    @Field(key: .pathToGpxFile)
    var pathToGpxFile: String
    
    init() { }
    
    init(id: UUID? = nil, nameText: String, pathToGpxFile: String) {
        self.id = id
        self.nameText = nameText
        self.pathToGpxFile = pathToGpxFile
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Route.schema)
            .id()
            .field(.nameText, .string, .required)
            .field(.pathToGpxFile, .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Route.schema).delete()
    }
    
}
