import Vapor
import FluentMySQL
final class UserLogin: Codable {
    var id: Int?
    
    var useremail : String?
    var userpassword : String
    var astate : Int?
    var isUse : Bool?
    
    //account state : [1]verification[2]general[3]modify
    init(useremail : String?,userpassword : String,astate : Int?,isUse : Bool?) {
        self.useremail = useremail
        self.userpassword = userpassword
        self.astate = astate
        self.isUse = isUse
    }
}
extension UserLogin: MySQLModel {}
extension UserLogin: Migration {}
extension UserLogin: Content {}
extension UserLogin: Parameter {}
