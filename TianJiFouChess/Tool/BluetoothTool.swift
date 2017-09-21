//
//  BluetoothTool.swift
//  TianJiFouChess
//
//  Created by 天机否 on 2017/5/10.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Protobuf
let serviceStr = "tianjifou"
class BluetoothTool: NSObject{
    static let  blueTooth = BluetoothTool()
    var session:MCSession?
    var myPeer:MCPeerID?
    var advertiser:MCAdvertiserAssistant?
    var browserBlock:(()->())?
    var getMessageBlock:((GPBMessage?)->())?
    
    private override init() {
        super.init()
       
    }
    
    func start() {
       stop()
       setupPeerSessionAdvertiser()
    }
    
    func stop() {
        myPeer = nil
        session = nil
        advertiser = nil
    }
    
    
    private func setupPeerSessionAdvertiser() {
        myPeer = MCPeerID.init(displayName: UIDevice.current.name)
        session = MCSession.init(peer: myPeer!, securityIdentity: nil, encryptionPreference: .none)
        
        advertiser = MCAdvertiserAssistant.init(serviceType: serviceStr, discoveryInfo: nil, session: session!)
        
        advertiser?.start()
        session?.delegate = self
        advertiser?.delegate = self
    }
    
    func setupBrowserVC() -> MCBrowserViewController?{
        guard let session = session else {
            return nil
        }
       let browser = MCBrowserViewController.init(serviceType: serviceStr, session: session)
        browser.delegate = self
        return browser
    }
    
    func sendData(_ messageVo: GPBMessage, successBlock:(()->())?,errorBlock:((NSError)->())?) {
        guard let session = session else {
            return
        }
        guard let data = NSDataTool.shareInstance().returnData(messageVo, messageId: 0) else {return}
        
        do {
          try session.send(data as Data , toPeers: session.connectedPeers, with: .reliable)
        }catch let error as NSError {
            errorBlock?(error)
            return
        }
        successBlock?()
    }
    
  
}

extension BluetoothTool: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("蓝牙连接完成")
       browserViewController.dismiss(animated: true, completion: { [weak self] in
             self?.browserBlock?()
            
        })
       
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("取消蓝牙连接")
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
}

extension BluetoothTool: MCSessionDelegate{
     func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .notConnected:
            print("未连接")
        case .connecting:
            print("正在连接中")
        case .connected:
            print("连接成功")
         
        }
        
    }
    
     func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
      NSDataTool.shareInstance().startParse(data) { (gpbMessage) in
         self.getMessageBlock?(gpbMessage)
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("streamName")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
         print("resourceName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
        
    }
   
    
}
extension BluetoothTool:MCAdvertiserAssistantDelegate{
    /// 发出广播请求
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        print("advertiserAssistantWillPresentInvitation")
    }
    /// 结束广播请求
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        print("advertiserAssistantDidDismissInvitation")
    }
}
