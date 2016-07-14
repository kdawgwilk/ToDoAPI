import Vapor


final class User {
    var name: String
    
    init(name: String) {
        self.name = name
    }
//    var firstName: String
//    var lastName: String
//    var email: String
//    var username: String
//    var encryptedPasword: String
    class func authorize(with username: String, and password: String) -> Bool {
        return true
    }
}

/**
	This allows instances of User to be 
	passed into Json arrays and dictionaries
	as if it were a native JSON type.
*/
extension User: JSONRepresentable {
    func makeJSON() -> JSON {
        return JSON([
            "name": "\(name)"
            ])
//        return JSON([
////            "uuid": uuid,
//            "id": id,
//            "first_name": firstName,
//            "last_name": lastName,
//            "email": email,
//            "username": username
//        ])
    }
}

/**
	If a data structure is StringInitializable, 
	it's Type can be passed into type-safe routing handlers.
*/
extension User: StringInitializable {
    convenience init?(from string: String) throws {
        self.init(name: string)
    }
//    init?(from string: String) throws {
//        guard let int = Int(string) else {
//            return nil //Will Abort.InvalidRequest
//        }
//        
//        guard let user = User.find(int) else {
//            throw UserError.NotFound
//        }
//        
//        self = user
//    }
}
