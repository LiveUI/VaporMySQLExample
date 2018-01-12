import Vapor
import Fluent
import FluentMySQL


extension DatabaseIdentifier {
    static var mysql: DatabaseIdentifier<MySQLDatabase> {
        return .init("foo")
    }
}

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    try services.register(FluentMySQLProvider())
    
    var databaseConfig = DatabaseConfig()
    
    let username = "root"
    let password: String? = nil
    let database = "test"
    
    let db = MySQLDatabase(hostname: "localhost", user: username, password: password, database: database)
    databaseConfig.add(database: db, as: .mysql)
    services.register(databaseConfig)
    
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: TestModel.self, database: .mysql)
    services.register(migrationConfig)
}
