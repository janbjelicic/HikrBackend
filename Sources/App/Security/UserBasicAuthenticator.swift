//import Vapor
//
//struct UserBasicAuthenticator: BasicAuthenticator {
//
//    func authenticate(basic: BasicAuthorization, for request: Request) -> EventLoopFuture<Void> {
//        User.query(on: request.db)
//            .filter(\.$email == basic.username)
//            .first()
//            .map {
//                do {
//                    if let user = $0, try Bcrypt.verify(basic.password, created: user.password) {
//                        request.auth.login(user)
//                    }
//                }
//                catch {
//                    // do nothing...
//                }
//        }
//    }
//
//}
