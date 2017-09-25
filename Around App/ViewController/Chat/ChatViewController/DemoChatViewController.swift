/*
 The MIT License (MIT)
 
 Copyright (c) 2015-present Badoo Trading Limited.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit
import Chatto
import ChattoAdditions
class DemoChatViewController: BaseChatViewController {
    var listMessage:[ChatItemProtocol] = []
    var messageSender: FakeMessageSender!
    var senderShipper : ShipperInfoObject!
    var listPoint:[PointLocation]!
    var order_id_Chat : Int?
     var flagReconectSocketFromBackground = false
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var dataSource: FakeDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.chatDataSourceDidUpdate(self.dataSource)
        }
    }
    
    lazy fileprivate var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender)
    }()
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultNavigationBar()
        
        UIView.animate(withDuration: 0, animations: {
            showProgressHub()
        }) { (result) in
            NotificationCenter.default.addObserver(self, selector:  #selector(self.applicationDidBecomeActive),
                                                   name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                   object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(DemoChatViewController.clickMessengerImage(_:)), name:NSNotification.Name(rawValue: "userDidTapOnBubble"), object: nil)
            self.blockCallBackFromSmartFox()
        }
        
        
    }
    func applicationDidBecomeActive()
    {
        if flagReconectSocketFromBackground{
            flagReconectSocketFromBackground = false
            reConnectedSmartFox()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func resetNumberChat() {
        var hashNumberChat = defaults.value(forKey: "chatNumber") as! [String:String]
        if hashNumberChat[String(format: "%d", order_id_Chat!)] != nil
            
        {
            hashNumberChat[String(format: "%d", order_id_Chat!)] = "0"
            defaults.set(hashNumberChat, forKey: "chatNumber")
            
        }
        
    }
    func blockCallBackFromSmartFox()
    {
        let param = SFSObject.newInstance()
        param?.putUtfString("command", value: kCmdGetChatHistory)
        SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
        SmartFoxObject.sharedInstance.blockCallBack = {
            (type,result) in
            if type == kPublicChatText
            {
                let eve = result as! SFSEvent
                let objData = eve.params["data"] as! SFSObject
                let user = eve.params["sender"] as! SFSUser
                if user.isItMe == false{
                    self.dataSource.addTextMessage(objData.getUtfString("chat_description"),status: .success,inComming: true)
                }
                self.resetNumberChat()
            }
            else if type == kPublicChatImage
            {
                let eve = result as! SFSEvent
                let objData = eve.params["data"] as! SFSObject
                let user = eve.params["sender"] as! SFSUser
                if user.isItMe == false{
                    let senderImage = UIImage(data: objData.getByteArray("chat_description"))
                    self.dataSource.addPhotoMessage(senderImage!,status: .success,inComming: true)
                }
                self.resetNumberChat()
            }
            else if type == kCmdGetChatHistory
            {
                
                let listChat = result as! SFSArray
                if listChat.size() == 0
                {
                    hideProgressHub()
                    return
                }
                
                var nextID = 5000
                for index in 0...listChat.size() - 1
                {
                    nextID += 1
                    let item = listChat.getSFSObject(index) as! SFSObject
                    if item.getUtfString("message") == kPublicChatText
                    {
                        let mess = createTextMessageModel(String(format: "%d",nextID), text: item.getUtfString("chat_description") , isIncoming: !item.getBool("isMe"), status: .success)
                        self.listMessage.append(mess)
                    }
                    else if item.getUtfString("message") == kPublicChatImageURL
                    {
                        
                        let senderImage = UIImage.sd_image(with: try! Data(contentsOf: URL(string: item.getUtfString("chat_description"))!))
                        let mess = createPhotoMessageModel(String(format: "%d",nextID), image: senderImage!, size: (senderImage?.size)!, isIncoming: !item.getBool("isMe"), status: .success)
                        self.listMessage.append(mess)
                        
                    }
                    else if item.getUtfString("message") == kPublicChatImage
                    {
                        let senderImage = UIImage(data: item.getByteArray("chat_description"))
                        let mess = createPhotoMessageModel(String(format: "%d",nextID), image: senderImage!, size: (senderImage?.size)!, isIncoming: !item.getBool("isMe"), status: .success)
                        self.listMessage.append(mess)
                        
                    }
                    
                    
                }
                self.dataSource = FakeDataSource(messages: self.listMessage, pageSize: 50)
                hideProgressHub()
            }
            else if type == kCmdConnectedSuccess
            {
                loginToZone()
            }
             
            else if type == kCmdLoginSuccess2ND
            {
                let param = SFSObject.newInstance()
                param?.putUtfString("command", value: kcmdGetFollowJourney)
                param?.putInt("id_order", value: self.order_id_Chat!)
                SmartFoxObject.sharedInstance.sendExtendsionRequest(kExtCmd, param: param, isNeedShowLoading: true)
            }
            else if type == kcmdGetFollowJourney
            {
                print("reconnect")
            }
                
                
            else if type == kCmdDisconnect
            {
                if UIApplication.shared.applicationState == .active
                {
                    self.reConnectedSmartFox()
                }
                else
                {
                    self.flagReconectSocketFromBackground = true
                }
            }
            else if type == kCmdFinish
            {
                
                customAlertView(self, title: MCLocalization.string(forKey: "SHIPPERFINISH", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {
                    result in
                    let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "RateUsViewController") as! RateUsViewController
                    vc.order_id = self.order_id_Chat
                    self.present(vc, animated: true, completion: nil)
                    
                })
            }
            else if type == kCmdCancelOrder
            {
                customAlertView(self, title: MCLocalization.string(forKey: "SHIPPERCANCEL", withPlaceholders: ["%name%" : String(describing: result as! String)]), btnTitleNameNormal: name_confirm_Button_Normal,titleButton: "OK",blockCallback: {result in
                    appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
                })
                
            }
            else if type == kCmdError
            {
                customAlertView(self, title: getErrorStringConfig(code: String(describing: result as! Int))! , btnTitleNameNormal: name_confirm_Button_Normal, titleButton: "OK", blockCallback: { (result) in
                })
                
            }
            
            
        }
    }
    func reConnectedSmartFox()
    {
        
        if connectedToNetwork()
        {
            registerBackgroundTask()
            if  SmartFoxObject.sharedInstance.smartFox != nil && SmartFoxObject.sharedInstance.smartFox.isConnected != true
            {
                SmartFoxObject.sharedInstance.connectedToSmartfox()
            }
        }
        else
        {
            //SmartFoxObject.sharedInstance.blockCallBack!(kCmdDisconnect, nil)
            customAlertViewWithCancelButton(self, title: MCLocalization.string(forKey: "DISCONNECT"), btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "TRY"), titleGreyButton: MCLocalization.string(forKey: "EXIT"), isClose: false,  blockCallback: {result in
                self.reConnectedSmartFox()
            }, blockCallbackCancel: {result in
                appDelegate.setRootView(isShowFollowJouneyStackScreen: false)
            })
        }
    }


    
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }

    func clickMessengerImage(_ noti: Notification)
    {
        
        
        let index = noti.object as! String
        for item in dataSource.slidingWindow.itemsInWindow.enumerated()
        {
            if let obj = item.element as? DemoPhotoMessageModel
            {
                if obj.uid == index
                {
                    //                    let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "ChooseImageChatViewController") as! ChooseImageChatViewController
                    //                    vc.chooseImage = (item.element as! DemoPhotoMessageModel).image
                    //                    self.present(vc, animated: false, completion: nil)
                }
            }
            
            
        }
    }
    func back()
    {
        var hashNumberChat = defaults.value(forKey: "chatNumber") as! [String:String]
        if hashNumberChat[String(describing:order_id_Chat!)] != nil
        {
            hashNumberChat[String(describing:order_id_Chat!)] = "0"
            defaults.set(hashNumberChat, forKey: "chatNumber")
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    func setDefaultNavigationBar()
    {
        
        let image = UIImage(named: "bubble-incoming-tail-border", in: Bundle(for: DemoChatViewController.self), compatibleWith: nil)?.bma_tintWithColor(UIColor.blue)
        super.chatItemsDecorator = ChatItemsDemoDecorator()
        let addIncomingMessageButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(DemoChatViewController.addRandomIncomingMessage))
        self.navigationItem.rightBarButtonItem = addIncomingMessageButton
        super.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: ScreenSize.SCREEN_WIDTH, height: 44)
        super.navigationController?.navigationBar.backgroundColor = UIColor.black
        //phuc
        let defaultNav = UINavigationBar()
        defaultNav.barTintColor = UIColor(hex: "fc8301")
        defaultNav.barStyle = .black
        defaultNav.tintColor = UIColor.white
        defaultNav.alpha = 1
        defaultNav.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64)
        
        let closeBtn = UIBarButtonItem(image: UIImage(named: "back x2"), style: .plain, target: self, action: #selector(self.back))
        let navItem = UINavigationItem(title: "Chat")
        defaultNav.titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
        defaultNav.setItems([navItem], animated: false)
        defaultNav.topItem?.leftBarButtonItem = closeBtn
        self.view.addSubview(defaultNav)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .top, relatedBy: .equal, toItem: defaultNav, attribute: .top, multiplier: 1, constant: 40))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: self.collectionView, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.collectionView, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.collectionView, attribute: .trailing, multiplier: 1, constant: 0))
        
    }
    @objc
    fileprivate func addRandomIncomingMessage() {
        self.dataSource.addRandomIncomingMessage()
    }
    
    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = MCLocalization.string(forKey: "SEND")
        appearance.textInputAppearance.placeholderText = MCLocalization.string(forKey: "TYPEYOURMESSAGE")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: DemoPhotoMessageHandler(baseHandler: self.baseMessageHandler)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        return [
            DemoTextMessageModel.chatItemType: [
                textMessagePresenter
            ],
            DemoPhotoMessageModel.chatItemType: [
                photoMessagePresenter
            ],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
    }
    
    fileprivate func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self!.dataSource.addTextMessage(text, status: .success,inComming: false)
            let obj:ISFSObject = SFSObject.newInstance()
            obj.putUtfString("chat_description", value: text)
            obj.putInt("order_id_chat", value: (self?.order_id_Chat!)!)
            SmartFoxObject.sharedInstance.sendPublicMessage(kPublicChatText, obj: obj)
            
        }
        return item
    }
    
    fileprivate func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            let resizeImage = imageWithImage(image, width: 200, height: 200)
            self!.dataSource.addPhotoMessage(resizeImage,status: .success,inComming: false)
            let image_data = UIImageJPEGRepresentation(resizeImage, 0.8)
            let obj:ISFSObject = SFSObject.newInstance()
            obj.putByteArray("chat_description", value: image_data)
            obj.putInt("order_id_chat", value: (self?.order_id_Chat!)!)
            SmartFoxObject.sharedInstance.sendPublicMessage(kPublicChatImage, obj: obj)
            
        }
        return item
    }
}
