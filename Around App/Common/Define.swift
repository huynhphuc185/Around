//
//  Define.swift
//  Around
//
//  Created by phuc.huynh on 8/2/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import Foundation
let defaults = UserDefaults.standard
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let pickUpStoryBoard = UIStoryboard(name: "PickUp", bundle: nil)
let bannerStoryBoard = UIStoryboard(name: "Banner", bundle: nil)
let giftingStoryBoard = UIStoryboard(name: "Gifting", bundle: nil)
var ROOTVIEW = UIApplication.shared.keyWindow?.rootViewController
let filePathEnglish = getFileURL(fileName: "config_en.dat").path!
let filePathVietNamese = getFileURL(fileName: "config_vn.dat").path!
var token_API = defaults.value(forKey: "token") as! String
var userPhone_API = defaults.value(forKey: "userphone") as! String
let colorXam = "3f3e3e"
let colorXamNhat = "aeacac"
let colorCam = "fc8301"
typealias callBack = (_ result: AnyObject?)->()
typealias onCallBack = ()->()
typealias onSuccess = (_ type: String?,_ result : AnyObject?)->()
enum UIUserInterfaceIdiom : Int
{
    case unspecified
    case phone
    case pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

//var deviceTokenStr = defaults.value(forKey: "deviceToken") as! String
let kSegueLoginToHome = "logintohome"
let kSegueLoginToRegister = "logintoregister"
let kSegueRegisterToVerify = "registertoverify"
let kSegueVerifyToHome = "verifytohome"

//let kCountryCode = getCountryPhonceCode(((Locale.current as NSLocale).object(forKey: .countryCode) as? String)!)
let kCountryCode = "84"
let name_alow_Button_Normal = "btnAlow"
let name_dontalow_Button_Normal = "btndontAlow"
let name_confirm_Button_Normal = "btnCamChung"
let name_cancel_Button_Normal = "btnXamChung"
let kVersion = "1.0.2"
let kzoneSmartfox = "AroundAppZone"
let kUserRole = 0
let kShipperRole = 1
let kExtCmd = "user"
let kPublicChatText = "TEXT_TYPE"
let kPublicChatImage = "IMAGE_TYPE"
let kPublicChatImageURL = "URL_TYPE"

let kCmdEstimateCost = "ESTIMATE_COST"
let kCmdRequestShipper = "REQUEST_SHIPPER"
let kCmdResponseShipper = "RESPONSE_SHIPPER"
let kCmdUpdateShipperPosition = "UPDATE_SHIPPER_POSITION"
let kCmdGetChatHistory = "GET_CHAT_HISTORY"
let kCmdShipperAccept = "REQUEST_SHIPPER_ACCEPT"
let kCmdShipperCancel = "REQUEST_SHIPPER_CANCEL"
let kCmdCreateRoomSuccess = "CREATE_ROOM_SUCCESS"
let kCmdConnectedSuccess = "CONNECTED_SUCCESS"
let kCmdFinish = "FINISH_DELIVERY"
let kCmdCancelOrder = "CANCEL_ORDER"
let kCmdRating = "RATING"
let kCmdUpdatePayment = "UPDATE_PAYMENT"
let kCmdGetPayment = "GET_PAYMENT"
let kCmdLoginSuccess = "LOGIN_SUCCESS"
let kCmdLoginFail = "LOGIN_FAIL"
let kCmdverifySuccess = "VERIFY_SUCCESS"
let kCmdverifyFail = "VERIFY_FAIL"
let kCmdLoginSuccess2ND = "LOGIN_SUCCESS_2ND"
let kCmdGetProfile = "GET_PROFILE"
let kCmdUpdateProfile = "UPDATE_PROFILE"
let kCmdVerifyProfile = "VERIFY_PROFILE"
let kCmdPing = "PING"
let kCmdDisconnect = "DISCONNECTED"
let kCmdReconnectStatus = "RECONNECT_JOURNEY"
let kCmdError = "ERROR"
let kCmdChangeRequestScreen = "CHANGE_REQUEST_SCREEN"

let kCmdCancelRequestByUser = "CANCEL_REQUEST_SHIPPER"
let kcmdGetFollowJourney = "GET_FOLLOW_JOURNEY"
let kCmdRequestPaymentURL = "REQUEST_NL_PAYMENT"
let kCmdResponsePayment = "RESPONSE_NL_PAYMENT"

let kCmdResponseError = "RESPONSE_ERROR"
let kCmdRequestError = "REQUEST_ERROR"
//let kCmdSendIDRequest = "SEND_REQUEST_ID"
let kCmdCkeckRequest = "CHECK_REQUEST"
