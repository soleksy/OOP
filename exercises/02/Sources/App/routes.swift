import Fluent
import Vapor

func routes(_ app: Application) throws {

    //show all users, their posts and comments,
    app.get("users") {req in 
        User.query(on: req.db).with(\.$posts).with(\.$comments).all()
    }


    //get user by its id
    app.get("users" , ":userId") { req -> EventLoopFuture<User> in
        
        User.find(req.parameters.get("userId") , on: req.db)
        .unwrap(or: Abort(.notFound))
    }

    //add a user
    app.post("users") { req -> EventLoopFuture<User> in
        let user = try req.content.decode(User.self) // decode body of http request
        return user.create(on: req.db).map {user}

    }

    //Update user info (name)
    app.put("users") { req -> EventLoopFuture<HTTPStatus> in

        let user = try req.content.decode(User.self)

        return User.find(user.id, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.name = user.name
            return $0.update(on: req.db).transform(to: .ok)
        }

    }

    //Delete user by id
    app.delete("users" , ":userId") {req -> EventLoopFuture<HTTPStatus> in
        
        User.find(req.parameters.get("userId"), on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.delete(on: req.db)
        }.transform(to: .ok)

    }

}
