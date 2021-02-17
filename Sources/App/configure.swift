import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    app.routes.defaultMaxBodySize = "1mb"
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // register routes
    try routes(app)
    app.views.use(.leaf)
    
    app.databases.use(.sqlite(.file("hikr.db")), as: .sqlite)
    app.migrations.add(User())
    app.migrations.add(Route())
    try app.autoMigrate().wait()
}
