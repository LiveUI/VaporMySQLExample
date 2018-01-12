import Routing
import Vapor
import Fluent
import FluentMySQL

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
final class Routes: RouteCollection {
    
    enum DbError: Error {
        case missingLastInsertedId
    }
    
    /// Use this to create any services you may
    /// need for your routes.
    let app: Application

    /// Create a new Routes collection with
    /// the supplied application.
    init(app: Application) {
        self.app = app
    }

    /// See RouteCollection.boot
    func boot(router: Router) throws {
        router.get("test") { req in
            return req.withPooledConnection(to: .mysql, closure: { (db) -> Future<[TestModel]> in
                return TestModel.query(on: db).all()
            })
        }
        
        router.post("test") { req in
            return req.withPooledConnection(to: .mysql, closure: { (db) -> Future<TestModel> in
                let test = TestModel()
                test.type = ":)"
                return test.save(on: db).map(to: TestModel.self) {
                    guard let id = db.lastInsertID else {
                        throw DbError.missingLastInsertedId
                    }
                    test.id = Int(id)
                    return test
                }
            })
        }
        
        router.get("test", Int.parameter) { (req) -> Future<TestModel> in
            let id = try req.parameter(Int.self)
            return req.withPooledConnection(to: .mysql, closure: { (db) -> Future<TestModel> in
                return db.query(TestModel.self).filter(\TestModel.id == id).first().map(to: TestModel.self) { model in
                    guard let model = model else {
                        throw Abort(.notFound, reason: "Could not find model.")
                    }
                    return model
                }
            })
        }
        
        router.delete("test", Int.parameter) { (req) -> Future<Response> in
            let id = try req.parameter(Int.self)
            return req.withPooledConnection(to: .mysql, closure: { (db) -> Future<Response> in
                return db.query(TestModel.self).filter(\TestModel.id == id).delete().map(to: Response.self, { _ in
                    let response = Response(using: req)
                    response.status = .noContent
                    return response
                })
            })
        }
    }
}
