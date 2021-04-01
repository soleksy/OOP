import Vapor
import Fluent

struct Context: Content {
    let UserList: [User]
}

struct UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws{

    let users = routes.grouped("users")

    users.get(use: show_all_users)

    users.group(":userId"){ user in 
            user.get(use: show_user)
            user.delete(use: delete)
        }

    users.put(use: update)
    users.post(use: create)
    
    }


    func show_all_users(req: Request) throws -> EventLoopFuture<View> {
        let users = User.query(on: req.db).all()

        return users.flatMap { list in 
            let data = Context(UserList: list)
            return req.view.render("index" , data)
        }
    }

    func show_user(req: Request) throws -> EventLoopFuture<View> {

        guard let userId = req.parameters.get("userId") as UUID? else{
            throw Abort(.badRequest)
        }

        return User.find(userId , on: req.db).flatMap { user in
            let data = ["user" : user]
            return req.view.render("user", data)
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.content.decode(User.self)
        return user.create(on: req.db).map { _ in 
            return req.redirect(to: "/users")
        }
    }

    func update(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.content.decode(User.self)
        return User.find(user.id, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.name = user.name
            return $0.update(on: req.db).map { _ in 
                return req.redirect(to: "/users")
                }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<Response>{
        return User.find(req.parameters.get("userId") , on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.delete(on: req.db).map {_ in 
                return req.redirect(to: "/users")
            }
        }
    }

}