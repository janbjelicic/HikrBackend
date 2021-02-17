import Vapor

func routes(_ app: Application) throws {
    app.get { req -> EventLoopFuture<View> in
        return req.view.render("index")
    }
    
    app.get("routes") { req -> EventLoopFuture<View> in
        struct PageData: Content {
            var routes: [Route]
        }
        
        let allRoutes = Route.query(on: req.db).all()
        
        return allRoutes.flatMap { routes in
            let context = PageData(routes: routes)
            return req.view.render("Routes/viewRoutes", context)
        }
    }
    
    app.get("uploadRoute") { req -> EventLoopFuture<View> in
        return req.view.render("Routes/createRoute")
    }
    
    app.post("uploadRoute") { req -> EventLoopFuture<String> in
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
                        return input.file.filename
                    }
//                    .flatMap {
//                        struct Context: Encodable {
//                            let fileUrl: String
//                        }
//                        let context = Context(fileUrl: input.file.filename)
//                        req.leaf.render("createRouteSuccess", context: context)
//                    }
            }
    }
    
    app.post("login") { req -> EventLoopFuture<String> in
        let user = try req.content.decode(User.self)
        let userCopy = user
        userCopy.date = Date()
        return userCopy.save(on: req.db).map {
            "It works"
        }
    }
}
