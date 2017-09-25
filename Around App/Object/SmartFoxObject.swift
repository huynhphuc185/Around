//
//  SmartFoxObject.swift
//  Around
//
//  Created by phuc.huynh on 10/19/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions
class SmartFoxObject:NSObject , ISFSEvents
{
    var blockCallBack : onSuccess!
    var smartFox : SmartFox2XClient!
    var countOfUserInRoom = 0
    var timer : Timer?
    var isNeedReconnect = true
    class var sharedInstance: SmartFoxObject {
        struct Static {
            static let instance = SmartFoxObject()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        smartFox = SmartFox2XClient(smartFoxWithDebugMode: false, delegate: self)
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.pingToServer), userInfo: nil, repeats: true)
    }
    func connectedToSmartfox()
    {
        print(ConfigIP.sharedInstance.smartfox_ip!)
        print(ConfigIP.sharedInstance.smartfox_port!)
        smartFox.connect(String(ConfigIP.sharedInstance.smartfox_ip!), port: Int32(ConfigIP.sharedInstance.smartfox_port!))
//        let config = ConfigData()
//        config.useBlueBox = true
//        config.host = String(ConfigIP.sharedInstance.smartfox_ip!)!
//        config.port = Int32(ConfigIP.sharedInstance.smartfox_port!)
//        config.setZone("AroundAppZone")
//        config.blueBoxPollingRate = 750
//        smartFox.connect(withConfig: config)
       

    }
    
    @objc fileprivate func pingToServer()
    {
        let param = SFSObject.newInstance()
        param?.putUtfString("command", value: kCmdPing)
        sendExtendsionRequest(kExtCmd, param: param,isNeedShowLoading: false)
        
    }
    
    // MARK: -
    func login (_ loginName: String,password : String, zone: String,params: SFSObject )
    {
        smartFox .send(LoginRequest.request(withUserName: loginName, password: password, zoneName: zone, params: params) as! IRequest)
    }
    
    func createRoom(_ name: String)
    {
        let roomSetting = RoomSettings(name: name)
        roomSetting?.maxUsers = 2
        smartFox.send(CreateRoomRequest.request(with: roomSetting, autoJoin: true, roomToLeave: smartFox.lastJoinedRoom) as! IRequest)
    }
    func leaveRoom()
    {
        smartFox.send(LeaveRoomRequest.request(with: nil) as! IRequest)
    }
    
    func disConnected(_isNeedReconnect : Bool)
    {
        isNeedReconnect = _isNeedReconnect
        smartFox.disconnect()
    }
    
    func sendPublicMessage(_ typeMessage : String, obj: ISFSObject?)
    {
        smartFox.send(PublicMessageRequest.request(withMessage: typeMessage, params: obj, targetRoom: nil) as! IRequest)
        
    }
    func sendExtendsionRequest(_ extCmd : String , param: ISFSObject?, isNeedShowLoading : Bool)
    {
        if param?.getUtfString("command") != kCmdPing && param?.getUtfString("command") != kCmdUpdateShipperPosition
        {
            if isNeedShowLoading
            {
                showProgressHub()
            }
           
        }
        smartFox.send(ExtensionRequest.request(withExtCmd: extCmd, params: param) as! IRequest)
    }
    // MARK: -

    func onConnection(_ evt: SFSEvent!) {
        print("connected")
        if evt.params["success"] is Bool
        {
            blockCallBack!(kCmdConnectedSuccess, nil)
        }
    }
    func onConnectionLost(_ evt: SFSEvent!) {
        print("disconnect")
        hideProgressHub()
        if isNeedReconnect{
            blockCallBack!(kCmdDisconnect, nil)
        }
        else
        {
            isNeedReconnect = true
        }
        
        
    }
    func onLogin(_ evt: SFSEvent!) {
        blockCallBack!(kCmdLoginSuccess2ND, 0 as AnyObject?)
        print("onLogin")
    }
    func onLoginError(_ evt: SFSEvent!) {
        print("login error")

    }
    func onRoomJoin(_ evt: SFSEvent!) {
        print("onRoomJoin")
    }
    func onRoomAdd(_ evt: SFSEvent!) {
        print("onRoomAdd")
    }
    func onUserCountChange(_ evt: SFSEvent!) {
        print("count of user", evt.params["uCount"]!)
        countOfUserInRoom = (evt.params["uCount"] as? Int)!
    }

    func onExtensionResponse(_ evt: SFSEvent!) {
        
        let obj  = evt.params["params"] as! SFSObject
        print(obj.getUtfString("command"))
        if obj.getUtfString("command") != kCmdPing && obj.getUtfString("command") != kCmdUpdateShipperPosition
        {
            hideProgressHub()
        }
       
        if obj.getUtfString("command") == kCmdEstimateCost
        {
            let estimationObj = EstimateObject()
            if obj.getInt("code") == 1
            {
                estimationObj.distance = Double(obj.getDouble("distance"))
                estimationObj.shipping_fee = obj.getInt("fee")
                estimationObj.total = obj.getInt("total")
                blockCallBack!(kCmdEstimateCost, estimationObj)
            }
            else{
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
            
        }
        else if obj.getUtfString("command") == kCmdResponseShipper
        {
        
            if obj.getInt("shipper_status") == 1
            {
                let shipperObj = ResponseShipper()
                shipperObj.shipper = ShipperInfoObject().parseDataFromObject(obj)
                let listLocation = obj.getSFSArray("locations")
                for index in 0...(listLocation?.size())! - 1
                {
                    let jSon = listLocation?.getUtfString(index)
                    let pointObj = PointLocation(JSONString: jSon!)
                    shipperObj.listLocation.append(pointObj!)
                }
                shipperObj.is_payment = obj.getBool("is_payment")
                shipperObj.order_id = obj.getInt("order_id")
                blockCallBack!(kCmdShipperAccept, shipperObj)
            }
            else if obj.getInt("shipper_status") == 0 {
                let errorRes = ResponseShipperError()
                errorRes.code = obj.getInt("code")
                errorRes.set_schedule_time = obj.getUtfString("set_schedule_time")
                errorRes.is_set_schedule_time = obj.getBool("is_set_schedule_time")
                errorRes.is_show_follow_list_screen = obj.getBool("is_show_follow_list_screen")
                blockCallBack!(kCmdShipperCancel, errorRes as AnyObject?)
            }
            else{
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
            
        }
        else if  obj.getUtfString("command") == kCmdRequestShipper
        {
            let requestShipper = RequestShipper().parseDataFromObject(obj)
            if obj.getInt("code") == 1
            {
                blockCallBack!(kCmdRequestShipper, requestShipper as AnyObject?)
            }
            else{
                blockCallBack!(kCmdRequestError, requestShipper as AnyObject)
            }
            
        }
        else if obj.getUtfString("command") == kCmdGetChatHistory
        {
            if obj.getInt("code") == 1
            {
                let listChat = obj.getSFSArray("chat_history")
                blockCallBack!(kCmdGetChatHistory, listChat)
            }
            else{
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
        }
        else if obj.getUtfString("command") == kCmdUpdateShipperPosition
        {
            
            if obj.getInt("code") == 1
            {
                
                let shipperPosition = ShipperPosition().parseDataFromObject(obj)
                
                blockCallBack!(kCmdUpdateShipperPosition, shipperPosition)
                
            }
            else{
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
            
        }
        else if obj.getUtfString("command") == kCmdFinish
        {
            blockCallBack!(kCmdFinish, obj.getUtfString("order_code") as AnyObject)
            
        }
        else if obj.getUtfString("command") == kCmdCancelOrder
        {

            blockCallBack!(kCmdCancelOrder, obj.getUtfString("order_code") as AnyObject)
            
        }
        else if obj.getUtfString("command") == kCmdRating
        {
            
            if obj.getInt("code") == 1
            {
                blockCallBack!(kCmdRating, nil)
            }
            else{
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
        }
            
        else if obj.getUtfString("command") == kCmdReconnectStatus
        {
            if obj.getInt("code") == 0
            {
                blockCallBack!(kCmdLoginSuccess2ND, 0 as AnyObject?)
            }
            else if obj.getInt("code") == 1
            {
                let reconnectObj = ReconnectObject().parseDataFromSFSObject(obj)
                blockCallBack!(kCmdReconnectStatus, reconnectObj)
            }
            else
            {
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
        }
        
        else if obj.getUtfString("command") == kCmdRequestPaymentURL
        {
            if obj.getInt("code") == 1
            {
                let url = obj.getUtfString("url")
                blockCallBack!(kCmdRequestPaymentURL, url as AnyObject?)
            }
            else
            {
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
        }
        else if obj.getUtfString("command") == kCmdChangeRequestScreen
        {
            let id_request = obj.getUtfString("id_request")
            blockCallBack!(kCmdChangeRequestScreen, id_request as AnyObject?)
        }

        
        else if obj.getUtfString("command") == kcmdGetFollowJourney
        {
            if obj.getInt("code") == 1
            {
                let followObj = obj.getSFSObject("data") as! SFSObject
                let followJourneyObj = FollowJourneyObject().parseDataFromSFSObject(followObj)
                blockCallBack!(kcmdGetFollowJourney, followJourneyObj)
            }
            else
            {
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
        }
        else if obj.getUtfString("command") == kCmdCancelRequestByUser
        {
            if obj.getInt("code") == 1
            {
                blockCallBack!(kCmdCancelRequestByUser, nil)
            }
            else
            {
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
        }
//        else if obj.getUtfString("command") == kCmdSendIDRequest
//        {
//            if obj.getInt("code") == 1
//            {
//                let id_request = obj.getUtfString("id_request")
//                blockCallBack!(kCmdSendIDRequest, id_request as AnyObject?)
//            }
//            else
//            {
//                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
//            }
//        }
        
        else if obj.getUtfString("command") == kCmdCkeckRequest
        {
            if obj.getInt("code") == 1
            {
                let checkRequestObj = obj.getSFSObject("data") as! SFSObject
                let obj = CheckRequest().parseDataFromSFSObject(checkRequestObj)
                blockCallBack!(kCmdCkeckRequest, obj)
            }
            else
            {
                blockCallBack!(kCmdError, obj.getInt("code") as AnyObject?)
            }
        }
        
    }

    func onPublicMessage(_ evt: SFSEvent!) {
        
        let objData = evt.params["data"] as! SFSObject
        let order_ID = objData.getInt("order_id_chat")
        var hashNumberChat = defaults.value(forKey: "chatNumber") as! [String:String]
        if hashNumberChat[String(describing:order_ID)] != nil
        {
            var number = Int(hashNumberChat[String(describing:order_ID)]!)
            number = number! + 1
            hashNumberChat[String(describing:order_ID)] = String(describing: number!)
            defaults.set(hashNumberChat, forKey: "chatNumber")
        }
        
        if (evt.params["message"]! as AnyObject).isEqual(to: kPublicChatText)
        {
            blockCallBack!(kPublicChatText,evt)
        }
        else if (evt.params["message"]! as AnyObject).isEqual(to: kPublicChatImage)
        {
            blockCallBack!(kPublicChatImage,evt)
        }
        else if (evt.params["message"]! as AnyObject).isEqual(to: kPublicChatImageURL)
        {
            blockCallBack!(kPublicChatImageURL,evt)
        }
    }
    
    
}
