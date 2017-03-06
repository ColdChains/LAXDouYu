//
//  LiveViewController.swift
//  LAXDouyu
//
//  Created by 冰凉的枷锁 on 2016/10/10.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class LiveViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Property
    
    var roomId = ""
    var roomInfo = [String: AnyObject]()
    
    let player = AVPlayer.init()
    var playerLayer: AVPlayerLayer?
    
    var liveChatManager = LiveChatManager.init()
    
    var dataArr = [ChatViewModel]()
    
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var playerUIV: UIView!
    
    @IBOutlet weak var playerUIH: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Override Function
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        request()
        playerView.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
        startLiveChat()
        
//        tableView.estimatedRowHeight = 20
//        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            
            playerLayer?.frame = playerView.bounds
            
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                playerUIV.isHidden = true
                playerUIH.isHidden = false
                (playerUIH as! PlayerUIHView).startDanmu()
            }
            else {
                playerUIV.isHidden = false
                playerUIH.isHidden = true
                (playerUIH as! PlayerUIHView).stopDanmu()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        playerView.removeObserver(self, forKeyPath: "bounds")
        liveChatManager.stop()
        player.pause()
        
    }
    
    //  MARK: - Custom Function
    
    func startLiveChat() {
        
        liveChatManager.setMessageReceive { [unowned self] (model) in
            self.showChatMessage(model: model)
        }
        liveChatManager.setInfoCallbackBlock { [unowned self] (model) in
            self.showChatMessage(model: model)
        }
        liveChatManager.connect(withRoomID: roomId, groupId: "-9999")
        
    }
    
    func request() {
        if roomId == "" {
            return
        }
        
        let str = "http://m.douyu.com/html5/live?roomId=" + roomId
        Alamofire.request(URL.init(string: str)!).responseJSON { (response) in
            
            if let obj = response.result.value as? [String: AnyObject] {
                self.roomInfo = obj["data"] as! [String: AnyObject]
                self.playLive()
            }
            
        }
    }
    
    func playLive() {
        
        let playItem = AVPlayerItem.init(url: URL.init(string: roomInfo["hls_url"] as! String)!)
        player.replaceCurrentItem(with: playItem)
        playerLayer = AVPlayerLayer.init(player: player)
        playerLayer?.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer!)
        player.play()
        
    }
    
    func showChatMessage(model: STTModel?) {
        if model == nil || model?.txt == nil {
            return
        }
        
        if dataArr.count > 2000 {
            dataArr.removeSubrange(Range.init(uncheckedBounds: (lower: 0, upper: 1000)))
            tableView.reloadData()
        }
        
//        print(model?.txt)
        
        let chat = ChatViewModel()
        chat.message = model!.txt //+ "==========================================================="
        chat.height = chat.message!.boundingRect(with: CGSize.init(width: tableView.frame.size.width - 20, height: 100), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil).size.height + 6
        dataArr.append(chat)
        
        if playerUIH.isHidden == false {
            (playerUIH as! PlayerUIHView).messageQueue.append(chat.message!)
        }
        
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
            let index = IndexPath.init(row: dataArr.count - 1, section: 0)
            tableView.insertRows(at: [index], with: .none)
            tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
    
    // MARK: - Protocol
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        let m = dataArr[indexPath.row]
        cell.chatTextLabel.text = m.message
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if dataArr[indexPath.row].message == nil {
            return 0
        }
//        return dataArr[indexPath.row].txt.boundingRect(with: CGSize.init(width: 414, height: 100), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil).size.height + 10
//        return UITableViewAutomaticDimension
        return dataArr[indexPath.row].height!
        
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 20
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        view.backgroundColor = UIColor.orange
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.init())
    }
    
    // MARK: - IBAction
    
    @IBAction func backAction(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func backActionV(_ sender: UIButton) {
        
        UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
        
    }
    
}
