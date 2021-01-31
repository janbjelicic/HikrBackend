import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    app.views.use(.leaf)
    
    app.databases.use(.sqlite(.file("hikr.db")), as: .sqlite)
    app.migrations.add(Login())
    try app.autoMigrate().wait()
}
