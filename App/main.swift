import Vapor
import VaporMustache

let Int = Swift.Int.self
let String = Swift.String.self

let mustache = VaporMustache.Provider(withIncludes: [
    "header": "Includes/header.mustache"
])

let drop = Droplet(providers: [mustache])

drop.get("/") { request in
    return JSON(["ToDo API"])
}

drop.get("/v1") { request in
    return JSON(["version": "1.0"])
}

let users = UserController(droplet: drop)
drop.grouped("api") { api in
    api.grouped("v1") { v1 in
        v1.get("users", handler: users.index)
        v1.get("users", User.self, handler: users.show)
        v1.patch("users", User.self, handler: users.update)
        v1.post("users", handler: users.store)
        v1.delete("users", User.self, handler: users.destroy)
    }
}
//drop.get("users", users.index)
//drop.get("users", handler: users.index)
//drop.resource("users", users)

/**
    Middleware is a great place to filter 
    and modifying incoming requests and outgoing responses. 

    Check out the middleware in App/Middelware.

    You can also add middleware to a single route by
    calling the routes inside of `app.middleware(MiddelwareType) { 
        app.get() { ... }
    }`
*/
drop.globalMiddleware.append(BasicAuthMiddleware())

let port = drop.config["app", "port"].int ?? 80

// Print what link to visit for default port
print("Visit http://localhost:\(port)")
drop.serve()
