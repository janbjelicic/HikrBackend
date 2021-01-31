import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Volim te najvise :)"
    }
    
    app.post("login") { req -> EventLoopFuture<String> in
        let login = try req.content.decode(Login.self)
        let loginCopy = login
        loginCopy.date = Date()
        return loginCopy.save(on: req.db).map {
            "It works"
        }
    }
}
