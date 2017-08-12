

import Foundation
import Firebase

struct Coupon {
    let uid: String
    let ownerID: String
    let shopName: String
    let validationCode: Int
    let couponName: String
    let couponValue: Int
    let redemeed: Bool
    let dateCreated: String
    let dateRedeemd: String?
    
    func toAnyObject() -> [String: Any] {
        return [
            "uid": uid as AnyObject,
            "ownerID": ownerID as AnyObject,
            "shopName": shopName as AnyObject,
            "validationCode": validationCode as AnyObject,
            "couponName": couponName as AnyObject,
            "couponValue": couponValue as AnyObject,
            "redeemed": redemeed as AnyObject,
            "dateCreated": dateCreated as AnyObject,
            "dateRedeemed": dateRedeemd as AnyObject
        ]
    }
}

extension Coupon {
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        uid = snapshotValue?["uid"] as! String
        ownerID = snapshotValue?["ownerID"] as! String
        shopName = snapshotValue?["shopName"] as! String
        validationCode = snapshotValue?["validationCode"] as! Int
        couponName = snapshotValue?["couponName"] as! String
        couponValue = snapshotValue?["couponValue"] as! Int
        redemeed = snapshotValue?["redeemed"] as! Bool
        dateCreated = snapshotValue?["dateCreated"] as! String
        dateRedeemd = snapshotValue?["dateRedeemed"] as? String
    }
}
