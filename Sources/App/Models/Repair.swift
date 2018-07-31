import Vapor
import FluentMySQL
final class Repair: Codable {
    var id: Int?
    
    var number : String?
    var machineType : String?
    var serviceType : String?
    var warranty : Bool?
    var brokenDescription : String?
    var client : String?
    var contactPerson : String?
    var address : String?
    var tel : String?
    
    var repairItem : String?
    var repaircostSum : Int?
    var repairDetailPicArray : [String]?
    var repairDetailDescription : String?
    var repairDetailNote : String?
    var repairDetailState : Bool?
    var customerSign : URL?
    var engineerSign : URL?
    var workEnd: Bool?
    
    init(number : String?,machineType : String?,serviceType : String?,warranty : Bool?,brokenDescription : String?,client : String?,contactPerson : String?,address : String?,tel : String?,repairItem : String? ,repaircostSum : Int? ,repairDetailDescription : String? ,repairDetailNote : String?,repairDetailState : Bool? ,customerSign : URL? ,engineerSign : URL?,repairDetailPicArray : [String]?,workEnd : Bool?) {
        self.number = number
        self.machineType = machineType
        self.serviceType = serviceType
        self.warranty = warranty
        self.brokenDescription = brokenDescription
        self.client = client
        self.contactPerson = contactPerson
        self.address = address
        self.tel = tel
        
        self.workEnd = workEnd
        self.repairItem = repairItem
        self.repaircostSum = repaircostSum
        self.repairDetailPicArray = repairDetailPicArray
        self.repairDetailDescription = repairDetailDescription
        self.repairDetailNote = repairDetailNote
        self.repairDetailState = repairDetailState
        self.customerSign = customerSign
        self.engineerSign = engineerSign
    }
}
extension Repair: MySQLModel {}
extension Repair: Migration {}
extension Repair: Content {}
extension Repair: Parameter {}


