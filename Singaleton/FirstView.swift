//
//  FirstView.swift
//  Singaleton
//
//  Created by Ferhat on 26.02.2024.
//

/*
 
 Singleton, bir sınıfın yalnızca bir örneğine (instance) sahip olduğu tasarım desenidir. Bu örneğe genellikle "singleton instance" veya sadece "singleton" denir. Singleton deseni, bir sınıfın yalnızca bir kez oluşturulmasını ve bu tek örneğe genel erişim noktası sağlamayı amaçlar. Bu, bir sınıfın belirli bir durumu paylaşmasını veya bir kaynağa tek bir noktadan erişilmesini gerektiren durumlar için kullanışlıdır.
 
 Burdaki örneğimde kişinin lokasyon bilgisini alacağım bir request yaptım.
 NCObject class ından LocationManager classını inherit ettim. Sebebi CLLocationManagerDelegate protokolünü uygulama yeteneği kazanmam... Çünkü CLLocationManagerDelegate bir protokoldür ve NSObjectProtocol den türetilmiştir. Dolayısıyla LocationManager classını NSObject sınıfından türeterek CLLocationManagerDelegate i uygulama yeteneği kazanmış oldum.
 
 */

import Foundation
import CoreLocation
// AnyObject yazmamın sebebi protocolü yalnızca class lar kullanabilsin istiyorum. AnyObject yerine class da yazabilirdim fakat böyle yazmam hem swift standartlarına uygun hemd de objective-c ile uyumlu.
protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(longitude: Double, latitude: Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate{
    
   static let shared = LocationManager() // singleton instance. Bu sayede başka dosyalarda bu sınıfın metotlarına ulaşabilirim.
    
   private var locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate? // weak kullanmamın sebebi Delegate aslında bir bir önceki VC nin referansı. Eğer bir önceki VC den gelen referans strong olarak tutulursa bir önceki VC deki referansın memoryleak olması halinde delegate in tanımlandığı sayfa memory den re init edilemeyeceği yani silinemeyeceği için retain cycle adı verilen bir hata ile karşılaşılacağı için uygulama çöker. Delegati bir önceki VC ye referans tutmak istediğimiz için her iki sayfa arasında kuvvetli bir ilişki kurmanın önüne geçiyoruz.
    
// init metodeunu private işaretlemek, singleton deseninin anahtarıdır. böylelikle sınıfın dışında başka bir yerde yeni bir LocationManager() örneği oluşturmak mümkün değildir. Bu şekilde, uygulama içinde tek bir noktadan (singleton örneği üzerinden) paylaşılan kaynaklara veya durumlara erişim sağlamak mümkün olur. LocationManager.shared üzerinden erişilen örnek, sınıf içinde oluşturulan bu tek örnektir.
   private override init() { // override, süperclass ın init ini yeniden yazma, başka bir tabirle süper class init üzerine yazma yapar.
        super.init() // Aşağıdaki subclass metotlarını çalıştırırken süperclass(NSObject) ın metotlarını da super.init() ile çalıştırmış oldum.
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            print("Latitude:\(location.latitude), longitude:\(location.longitude)")
            
            delegate?.didUpdateLocation(longitude: location.longitude, latitude: location.latitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
