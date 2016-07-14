import Vapor
import CryptoEssentials
import Foundation
import CryptoSwift


extension String {
    public func split(separator: Character, maxSplits: Int = .max, omittingEmptySubsequences: Bool = true) -> [String] {
        return characters.split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences).map(String.init)
    }
}


class BasicAuthMiddleware: Middleware {

	func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        // You can manipulate the request before calling the handler
        // and abort early if necessary, a good injection point for
        // handling auth.
        
        let deniedResponse = try! Response(status: .unauthorized, json: JSON(["Unauthorized"]))
        
        guard let authorization = request.headers["Authorization"] else {
            return deniedResponse
        }

        let tokens = authorization.split(separator: " ")

        guard tokens.count == 2 || tokens.first == "Basic" else {
            return deniedResponse
        }

        let decodedData = try Base64.decode(tokens[1])
        let decodedCredentials = String.init(bytes: decodedData, encoding: String.Encoding.utf8)
        let credentials = decodedCredentials!.split(separator: ":")
        
        guard credentials.count == 2 else {
            return deniedResponse
        }
        
        let username = credentials[0]
        let password = try credentials[1].sha256().toString()
        print(password) // atzuQErhdbh2HZ3XyEIEslgp1vdJ/7wZv09bafRk6rA=
        
        if User.authorize(with: username, and: password) {
            return try chain.respond(to: request)
        }
        
        return deniedResponse
	}

}
