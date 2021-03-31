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



    //Posts


    //get all posts
    app.get("posts") { req in 
        Post.query(on: req.db).with(\.$comments).all()
    }
    //get post by id
    app.get("posts" , ":postId") { req -> EventLoopFuture<Post> in

        Post.find(req.parameters.get("postId") , on: req.db)
        .unwrap(or: Abort(.notFound))
    }
    //add a post
     app.post("posts") { req -> EventLoopFuture<Post> in
        let post = try req.content.decode(Post.self)
        return post.create(on: req.db).map{ post }
    }

    //update a post (edit)
    struct UpdatePost: Content {
        var id: UUID?
        var title: String
        var body: String
    }

    app.put("posts") { req -> EventLoopFuture<HTTPStatus> in

        let post = try req.content.decode(UpdatePost.self)

        return Post.find(post.id , on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.title = post.title
            $0.body = post.body
            return $0.update(on: req.db).transform(to: .ok)
        }
    }

    //delete a post

    app.delete("posts", ":postId") {req -> EventLoopFuture<HTTPStatus> in

        Post.find(req.parameters.get("postId") , on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.delete(on: req.db)
        }.transform(to: .ok)
    }

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
