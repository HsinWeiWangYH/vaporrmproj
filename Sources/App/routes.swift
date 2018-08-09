import Vapor
import Fluent
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    //取得維修單資料
    router.get("api", "repairt") { req -> Future<[Repair]> in
        return Repair.query(on: req).all()
    }
    //建立維修單
    router.post("api", "repairt","UserInformation") { req -> String in
        try req.content.decode(Repair.self)
            .flatMap(to: Repair.self) { repairtest in
                repairtest.workEnd = false
                repairtest.repairDetailPicArray = [""]
                repairtest.serviceType = repairtest.serviceType?.removingPercentEncoding
                repairtest.address = repairtest.address?.removingPercentEncoding
                repairtest.brokenDescription = repairtest.brokenDescription?.removingPercentEncoding
                repairtest.contactPerson = repairtest.contactPerson?.removingPercentEncoding
                repairtest.client = repairtest.client?.removingPercentEncoding
                
                return repairtest.save(on: req)
        }
        return "已傳送"
    }
    //維修資料
    router.post(RepairTData.self, at:"api", "repairt","UserRepair") { req, data -> String in
        let idX = data.nameid
        
        let datachange = Repair.query(on : req).filter(\.id == idX).first().map(to: Repair.self) {
            repairtest in
            guard let repairtest = repairtest else {
                throw Abort(.notFound)
            }
            repairtest.workEnd = data.workEnd
            repairtest.repairItem = data.repairItem
            repairtest.repaircostSum = data.repaircostSum
            repairtest.repairDetailDescription = data.repairDetailDescription
            repairtest.repairDetailNote = data.repairDetailNote
            repairtest.repairDetailState = data.repairDetailState
            return repairtest
        }
        datachange.save(on: req)
        return "已上傳維修資料"
    }
    //維修資料_照片
    router.post(ImageData.self, at:"api", "repairt","UserImage") { req, data -> String in
        let idX = data.nameid
        let cFN = data.changeField
        
        let imageData:Data? = data.image
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let photoName = "UserImage" + String(idX) + "_" + String(timeInterval) + ".png";
        let dest = URL(fileURLWithPath: "/Users/zenchermini/Desktop/vaporrmproj/Public/image/"+photoName)
        do{try imageData?.write(to: dest)}
        catch {
            print(error.localizedDescription)
        }
        
        let datachange = Repair.query(on : req).filter(\.id == idX).first().map(to: Repair.self) {
                repairtest in
            guard let repairtest = repairtest else {
                throw Abort(.notFound)
            }
            if(cFN == 0){
                repairtest.customerSign = dest
            }
            if(cFN == 1){
                repairtest.engineerSign = dest
            }
            if(cFN == 2){
                var arrT = repairtest.repairDetailPicArray!
                arrT.append(dest.path)
                repairtest.repairDetailPicArray = arrT
            }
            return repairtest
        }
        datachange.save(on: req)
        return "已上傳圖片"
    }
    
    
    
    //取得帳戶資料
    router.get("api", "userlogin") { req -> Future<[UserLogin]> in
        return UserLogin.query(on: req).all()
    }
    //account state : [1]verification[2]general[3]modify
    //account is Use: [1]true[0]false
    //申請帳號
    router.post("set", "userlogin","userInfoSignUp") { req -> String in
        try req.content.decode(UserLogin.self)
            .flatMap(to: UserLogin.self) { logintest in
                logintest.astate = 1
                logintest.isUse = false
                logintest.userpassword = String(logintest.userpassword.hashValue)
                return logintest.save(on: req)
        }
        return "審核中"
    }
    //修改登入狀態
    router.post(UserUseData.self, at:"set", "userlogin","Use") { req, data -> String in
        let account = data.useremail.removingPercentEncoding
        let datachange = UserLogin.query(on : req).filter(\.useremail == account).first().map(to: UserLogin.self) {
            accounttest in
            guard let accounttest = accounttest else {
                throw Abort(.notFound)
            }
            accounttest.isUse = data.isUse
            return accounttest
        }
        datachange.save(on: req)
        return "已允許"
    }
    
    //允許申請
    router.post(UserAccountData.self, at:"set", "userlogin","userVerification") { req, data -> String in
        let account = data.useremail.removingPercentEncoding
        let datachange = UserLogin.query(on : req).filter(\.useremail == account).first().map(to: UserLogin.self) {
            accounttest in
            guard let accounttest = accounttest else {
                throw Abort(.notFound)
            }
            accounttest.astate = 2
            return accounttest
        }
        datachange.save(on: req)
        return "已允許"
    }
    //忘記帳號
    router.post(UserAccountData.self, at:"set", "userlogin","tryChange") { req, data -> String in
        let account = data.useremail
        
        let datachange = UserLogin.query(on : req).filter(\.useremail == account).first().map(to: UserLogin.self) {
            accounttest in
            guard let accounttest = accounttest else {
                throw Abort(.notFound)
            }
            accounttest.astate = 3
            
            return accounttest
        }
        datachange.save(on: req)
        return "修改申請審核中"
    }
    //允許修改
    router.post(UserAccountData.self, at:"set", "userlogin","userAllow") { req, data -> String in
        let account = data.useremail
        
        let datachange = UserLogin.query(on : req).filter(\.useremail == account).first().map(to: UserLogin.self) {
            accounttest in
            guard let accounttest = accounttest else {
                throw Abort(.notFound)
            }
            accounttest.astate = 2
            accounttest.userpassword = "4799450043618438031"
            
            return accounttest
        }
        datachange.save(on: req)
        return "已允許"
    }
    //不允許修改
    router.post(UserAccountData.self, at:"set", "userlogin","userNotAllow") { req, data -> String in
        let account = data.useremail
        
        let datachange = UserLogin.query(on : req).filter(\.useremail == account).first().map(to: UserLogin.self) {
            accounttest in
            guard let accounttest = accounttest else {
                throw Abort(.notFound)
            }
            accounttest.astate = 2
            
            return accounttest
        }
        datachange.save(on: req)
        return "已拒絕"
    }
    //修改帳號
    router.post(UserModifyData.self, at:"set", "userlogin","userChange") { req, data -> String in
        let account = data.changeaccount
        
        let datachange = UserLogin.query(on : req).filter(\.useremail == account).first().map(to: UserLogin.self) {
            accounttest in
            guard let accounttest = accounttest else {
                throw Abort(.notFound)
            }
            accounttest.userpassword = String(data.newpassword.hashValue)
            
            return accounttest
        }
        datachange.save(on: req)
        return "已修改"
    }
    //回傳hashValue
    router.post( VerData.self , at:"set", "allowlogin") {  req , data  -> String in
        let password = data.userpassword
        return String(password.hashValue)
    }
}
struct RepairTData: Content {
    var nameid: Int
    
    var repairItem : String?
    var repaircostSum : Int?
    var repairDetailDescription : String?
    var repairDetailNote : String?
    var repairDetailState : Bool?
    var workEnd: Bool?
}
struct ImageData: Content {
    var nameid: Int
    
    var changeField: Int
    var image: Data
}
struct VerData: Content {
    var userpassword:String
}
struct UserModifyData: Content {
    var changeaccount: String
    var newpassword: String
}
struct UserAccountData: Content {
    var useremail: String
}
struct UserUseData: Content {
    var useremail: String
    var isUse: Bool
}
