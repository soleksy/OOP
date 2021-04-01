import Fluent
import Vapor

func routes(_ app: Application) throws {

    try app.register(collection: UserController())
    try app.register(collection: PostController())

    // Comments

    //get all comments
    app.get("comments") { req in 
        Comment.query(on: req.db).all()
    }
    //get comments by id
    app.get("comments" , ":commentId") { req -> EventLoopFuture<Comment> in

        Comment.find(req.parameters.get("commentId") , on: req.db)
        .unwrap(or: Abort(.notFound))
    }

    //add a comment
     app.post("comments") { req -> EventLoopFuture<Comment> in
        let comment = try req.content.decode(Comment.self)
        return comment.create(on: req.db).map{ comment }
    }

    //update a comment (edit)
    struct UpdateComment: Content {
        var id: UUID?
        var body: String
    }

    app.put("comments") { req -> EventLoopFuture<HTTPStatus> in

        let comment = try req.content.decode(UpdateComment.self)

        return Comment.find(comment.id , on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.body = comment.body
            return $0.update(on: req.db).transform(to: .ok)
        }
    }

    //delete a comment

    app.delete("comments", ":commentId") {req -> EventLoopFuture<HTTPStatus> in

        Comment.find(req.parameters.get("commentId") , on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.delete(on: req.db)
        }.transform(to: .ok)
    }


}
