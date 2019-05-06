//
//  GezginController.swift
//  zurnaFourth
//
//  Created by Yavuz on 13.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

import UIKit

class GezginController: UICollectionViewController{

    fileprivate let cellId = "cellId"
//    fileprivate let headerId = "headerId"
//    fileprivate let padding: CGFloat = 16
    
    let countries = ["01 Adana","02 Adıyaman","03 Afyon","04 Ağrı",
                     "05 Amasya","06 Ankara","07 Antalya","08 Artvin",
                     "09 Aydın","10 Balıkesir","11 Bilecik","12 Bingöl",
                     "13 Bitlis","14 Bolu","15 Burdur","16 Bursa",
                     "17 Çanakkale","18 Çankırı","19 Çorum","20 Denizli",
                     "21 Diyarbakır","22 Edirne","23 Elazığ","24 Erzincan",
                     "25 Erzurum","26 Eskişehir","27 Gaziantep","28 Giresun",
                     "29 Gümüşhane","30 Hakkari","31 Hatay","32 Isparta",
                     "33 İçel (Mersin)","34 İstanbul","35 İzmir","36 Kars",
                     "37 Kastamonu","38 Kayseri","39 Kırklareli","40 Kırşehir",
                     "41 Kocaeli","42 Konya","43 Kütahya","44 Malatya",
                     "45 Manisa","46 K.maraş","47 Mardin","48 Muğla",
                     "49 Muş","50 Nevşehir","51 Niğde","52 Ordu",
                     "53 Rize","54 Sakarya","55 Samsun","56 Siirt",
                     "57 Sinop","58 Sivas","59 Tekirdağ","60 Tokat",
                     "61 Trabzon","62 Tunceli","63 Şanlıurfa","64 Uşak",
                     "65 Van","66 Yozgat","67 Zonguldak","68 Aksaray",
                     "69 Bayburt","70 Karaman","71 Kırıkkale","72 Batman",
                     "73 Şırnak","74 Bartın","75 Ardahan","76 Iğdır",
                     "77 Yalova","78 Karabük","79 Kilis","80 Osmaniye",
                     "81 Düzce" ]
    
    
    
    override func viewDidLoad() {
        
        setupCollectionViewLayout()
        
        setupCollectionView()
//        tabBarController?.tabBar.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    fileprivate func setupCollectionViewLayout() {
        //layout customization
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{

            layout.sectionInset = UIEdgeInsets(top: 1, left: 10, bottom: 10, right: 10)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 5
            layout.itemSize = CGSize(width: 100, height: 70)
            self.collectionView.collectionViewLayout = layout
        }
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.backgroundColor = .white
        self.collectionView.contentInsetAdjustmentBehavior = .always
        
        
        
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView!.register(GezginViewCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return .init(width: view.frame.width, height: 70)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GezginViewCell
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        cell.layer.borderColor = bcolor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        cell.countryLabel.text = countries[indexPath.item]

//        cell.backgroundColor = .red
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(red:0.94, green:0.78, blue:0.76, alpha:1.0): UIColor(red:1.00, green:0.90, blue:0.83, alpha:1.0)
//        cell.frame.origin.x = self.view.frame.width - cell.frame.width
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GezginViewCell
        if let country = cell.countryLabel.text?.split(separator: " "){
            print(country[1])
            
            
            //navigationController?.popToViewController(self, animated: false)
//            self.navigationController?.popViewController(animated: true)
//            self.navigationController?.popToRootViewController(animated: true)
            
            
//            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            self.navigationController?.dismiss(animated: true, completion: nil)
            
            self.present(CustomTabBarController(), animated: true, completion: nil)
            
            var dic: Dictionary<String, String> = Dictionary()
            dic.updateValue(String(country[1]), forKey: "city")
            NotificationCenter.default.post(name: Notification.Name("didCitySelected"), object: nil, userInfo: dic)
            
            
//            navigationController?.popToViewController(self, animated: true)
//            navigationController?.pushViewController(a!, animated: true)
            

            //            navigationController?.popToViewController(CommentController(collectionViewLayout: UICollectionViewLayout()), animated: true)
        }
    }

}





