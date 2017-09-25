import Foundation
class ChatObject: NSObject {
    var sender : String?
    var avatar : String?
    var message: String?
    var chat_description : AnyObject?
    var time : String?
    var isMe : Bool?
    
    
    func parseDataFromObject (_ sfObj:SFSObject)->ChatObject
    {
    
        self.sender = sfObj.getUtfString("sender")
        self.avatar = sfObj.getUtfString("avatar")
        self.message = sfObj.getUtfString("message")
        self.time = sfObj.getUtfString("time")
        self.isMe = sfObj.getBool("isMe")
        if self.message == kPublicChatText
        {
            self.chat_description = sfObj.getUtfString("chat_description") as AnyObject?
        }
        else{
            self.chat_description = sfObj.getByteArray("chat_description") as AnyObject?
        }
        return self
        
    }
}
