import Vapor

enum RoutesSitePath: String {
    case upload = "upload"
}

class RoutesRouter: BaseRouter {
    
    static let basePath: String = "routes"
    
    static func routes(_ app: Application) throws {
        try api(app)
        try site(app)
    }
    
    static func api(_ app: Application) throws {
        app.group(PathComponent(stringLiteral: apiVersion), PathComponent(stringLiteral: basePath)) { apiRoutesPath in
            apiRoutesPath.get { req -> EventLoopFuture<[Route]> in
                return Route.query(on: req.db).all()
            }
        }
    }
    
    static func site(_ app: Application) throws {
        app.group(PathComponent(stringLiteral: basePath)) { routesPath in
            routesPath.get { req -> EventLoopFuture<View> in
                struct PageData: Content {
                    var routes: [Route]
                }
                let allRoutes = Route.query(on: req.db).all()
                
                return allRoutes.flatMap { routes in
                    let context = PageData(routes: routes)
                    return req.view.render("Routes/viewRoutes", context)
                }
            }
            
            routesPath.get(PathComponent(stringLiteral: RoutesSitePath.upload.rawValue)) { req -> EventLoopFuture<View> in
                return req.view.render("Routes/createRoute")
            }
            
            routesPath.post(PathComponent(stringLiteral: RoutesSitePath.upload.rawValue)) { req -> EventLoopFuture<Response> in
                struct Input: Content {
                    var nameText: String
                    var file: File
                }
                let input = try req.content.decode(Input.self)
                guard input.file.data.readableBytes > 0 else {
                    throw Abort(.badRequest)
                }
                
                let path = app.directory.publicDirectory + input.file.filename
                return req.application.fileio.openFile(path: path,
                                                       mode: .write,
                                                       flags: .allowFileCreation(posixMode: 0x744),
                                                       eventLoop: req.eventLoop)
                    .flatMap { handle in
                        req.application.fileio.write(fileHandle: handle,
                                                     buffer: input.file.data,
                                                     eventLoop: req.eventLoop)
                            .flatMapThrowing { _ in
                                try handle.close()
                                let route = Route(nameText: input.nameText, pathToGpxFile: input.file.filename)
                                _ = route.save(on: req.db)
                                return req.redirect(to: "/")
                            }
                    }
            }
        }
    }
    
}
