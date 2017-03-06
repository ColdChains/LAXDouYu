//
//  RemmViewController.swift
//  LAXDouyu
//
//  Created by 冰凉的枷锁 on 2016/10/9.
//  Copyright © 2016年 liuaoxiang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RemmViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    // MARK: - Property
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArray = [[String: AnyObject]]()
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - Override Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        request()
    }
    
    // MARK: - Custum Function
    
    func registerNib() {
        collectionView.register(UINib.init(nibName: "RoomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoomCollectionViewCell")
    }
    
    func request() {
//        let str = "http://capi.douyucdn.cn/api/v1/getCustomRoom?aid=ios&client_sys=ios&tagIds=133_2_173_193_137_115_136_134_172_111_&time=1460265840"
        let str = "http://capi.douyucdn.cn/api/v1/getCustomRoom?aid=ios&client_sys=ios&tagIds=133_2_173_193_137_115_136_134_172_111_&time=" + String.init(format: "%f", Date.timeIntervalBetween1970AndReferenceDate)
        Alamofire.request(str).responseJSON { (response) in
            if let json = response.result.value {
                let obj = json as! [String: AnyObject]
                self.dataArray = obj["data"] as! [[String: AnyObject]]
                
                self.collectionView.reloadData()

            }
        }
    }
    
    // MARK: - CollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let data = dataArray[section]
        if let list = data["room_list"] as? [[String: AnyObject]] {
            
            return list.count
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCollectionViewCell", for: indexPath) as! RoomCollectionViewCell
        
        let data = dataArray[indexPath.section]
        
        if let dict = (data["room_list"] as? [[String: AnyObject]])?[indexPath.item] {
            
            cell.roomTitleLabel.text = dict["room_name"] as? String
            cell.nickNameLabel.text = dict["nickname"] as? String
            let num = dict["online"] as! Int
            let str = num > 9999 ? String.init(format: "%.1f万", Float(num) / 10000) : "\(num)"
            cell.onLineLabel.text = str
            
            cell.roomImageView.af_setImage(withURL: URL.init(string: dict["room_src"] as! String)!, placeholderImage: UIImage.init(named: "Img_default"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: false, completion: nil)
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = dataArray[indexPath.section]
        
        if let dict = (data["room_list"] as? [[String: AnyObject]])?[indexPath.item] {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LiveViewController") as! LiveViewController
            vc.roomId = dict["room_id"] as! String
            self.show(vc, sender: nil)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 10, 10, 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = (UIScreen.main.bounds.size.width - 30) / 2
        return CGSize.init(width: w, height: w / 5 * 4)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let b = kind == UICollectionElementKindSectionHeader
        let str = b ? "RoomCollectionViewHeader" : "RoomCollectionViewFooter"
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: str, for: indexPath)
        
        if b {
            (view as! RoomCollectionViewHeader).callback = {
                print(555)
            }
        }
        
        return view
    }
    
}
