import Vapor

func routes(_ app: Application) throws {
    app.get { req -> EventLoopFuture<View> in
        return req.view.render("index")
    }
    
    // MARK: - Routes
    try RoutesRouter.routes(app)
    
    // MARK: - User
    app.post("login") { req -> EventLoopFuture<String> in
        let user = try req.content.decode(User.self)
        let userCopy = user
        userCopy.date = Date()
        return userCopy.save(on: req.db).map {
            "It works"
        }
    }
}
