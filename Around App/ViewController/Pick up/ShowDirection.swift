

import UIKit
import GoogleMaps
import Alamofire

protocol ShowDirectionDelegate {
    
    func finishPrepareDirectionInfo(_ startPoint : String, endPoint : String)
    
}

class ShowDirection: NSObject {
    
    //typealias onSuccess = (_ result:AnyObject)->()
    var startAddress : String?
    var endAddress : String?
    
    weak var mapView : GMSMapView?
    var routePolyline:GMSPolyline?
    var callbackWhenDraw : callBack?
    class var sharedInstance: ShowDirection {
        struct Static {
            static let instance = ShowDirection()
        }
        return Static.instance
    }
    
    
    func showDirection(_ start : CLLocationCoordinate2D, end : CLLocationCoordinate2D,map: GMSMapView,color: UIColor,point: PointLocation?) {
        mapView = map
        let aPoint = NSString(format:"%f,%f",start.latitude , start.longitude)
        let bPoint = NSString(format:"%f,%f",end.latitude , end.longitude)
         let urlString = String(format: "https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@", aPoint, bPoint)
        DataConnect.getDirection(urlString, onsuccess: { (result) in
            // print(result)
            if result!["status"] as? String == "OK" {
                DispatchQueue.main.async(execute: {
                    let selectedRoute = (result?["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                    let legs = (selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>)[0]
                    let duration =  legs["duration"] as! Dictionary<String, AnyObject>
                    let distance =  legs["distance"] as! Dictionary<String, AnyObject>
                    let durationValue = duration["value"] as! Double
                    let distanceValue = distance["value"] as! Double
                    point?.duration = durationValue
                    point?.distance = distanceValue
                    let overviewPolyline = selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                    let route = overviewPolyline["points"] as! String
                
                    self.drawRoute(route,color: color)
                    if point?.role == 3
                    {
                        self.callbackWhenDraw!(nil)
                    }
                })
            }
        }) { (error) in
            
        }
    }
    
    func getDotsToDrawRoute(positionss : [ShipperPosition],map: GMSMapView, color: UIColor, point: PointLocation?) {
        if positionss.count > 1 {
            var positions = positionss
            let origin = positions.first
            let destination = positions.last
            positions.removeFirst()
            positions.removeLast()
            var wayPoints = ""
            for point in positions {
                wayPoints = wayPoints.characters.count == 0 ? "\(String(format: "%f", point.shipper_latitude!)),\(String(format: "%f", point.shipper_longitude!))" : "\(wayPoints)|\(String(format: "%f", point.shipper_latitude!)),\(String(format: "%f", point.shipper_longitude!))"
            } 
            
            let parameters : [String : String] = ["origin" : "\(String(format: "%f", origin!.shipper_latitude!)),\(String(format: "%f", origin!.shipper_longitude!))", "destination" : "\(String(format: "%f", destination!.shipper_latitude!)),\(String(format: "%f", destination!.shipper_longitude!))", "wayPoints" : wayPoints,"key": Config.sharedInstance.googleKey!]
            let request = "https://maps.googleapis.com/maps/api/directions/json"
            Alamofire.request(request, method:.get, parameters : parameters).responseJSON(completionHandler: { response in
                guard let result = response.result.value as? [String : AnyObject]
                    else {
                        return
                }
                if result["status"] as? String == "OK" {
                    DispatchQueue.main.async(execute: {
                        let selectedRoute = (result["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                        let legs = (selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>)[0]
                        let duration =  legs["duration"] as! Dictionary<String, AnyObject>
                        let durationValue = duration["value"] as! Double
                        point?.duration = durationValue
                        let overviewPolyline = selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                        let route = overviewPolyline["points"] as! String
                        self.drawRoute(route, color: color)
                        
                    })
                }
                
                //                if let routes = dictionary["routes"] as? [[String : AnyObject]] {
                //                    if routes.count > 0 {
                //                        var first = routes.first
                //                        if let legs = first!["legs"] as? [[String : AnyObject]] {
                //                            let fullPath : GMSMutablePath = GMSMutablePath()
                //                            for leg in legs {
                //                                if let steps = leg["steps"] as? [[String : AnyObject]] {
                //                                    for step in steps {
                //                                        if let polyline = step["polyline"] as? [String : AnyObject] {
                //                                            if let points = polyline["points"] as? String {
                //                                                fullPath.appendPath(GMSMutablePath(fromEncodedPath: points))
                //                                            }
                //                                        }
                //                                    }
                //                                    completion(path: fullPath)
                //                                }
                //                            }
                //                        }
                //                    }
                //                }
            })
        }
    }

    
    func drawRoute(_ routes: String,color:UIColor) {
        let path = GMSPath(fromEncodedPath: routes)
        routePolyline = GMSPolyline(path: path)
        routePolyline!.strokeWidth = 3
        routePolyline!.strokeColor = color
        routePolyline?.map = mapView

    }
    
    
    func drawPolylineAllPoint(_ listPoint: [ShipperPosition] ,color:UIColor,map: GMSMapView) {
        let path = GMSMutablePath()
        for item in listPoint
        {
            path.addLatitude(item.shipper_latitude!, longitude: item.shipper_longitude!)
        }
        routePolyline = GMSPolyline(path: path)
        routePolyline!.strokeWidth = 3
        routePolyline!.strokeColor = color
        routePolyline?.map = map
      
        
    }
    
    func drawPolylineTwoPoint(_ start : CLLocationCoordinate2D, end : CLLocationCoordinate2D ,color:UIColor,map: GMSMapView) {
        let path = GMSMutablePath()
        path.add(start)
        path.add(end)
        routePolyline = GMSPolyline(path: path)
        routePolyline!.strokeWidth = 3
        routePolyline!.strokeColor = color
        routePolyline?.map = map
        
        
    }

    
    func removeRoute()
    {
        //  routePolyline = nil
        routePolyline?.map = nil
    }
    
    func findMiddlePointInPath(_ path: GMSPath , distance:Double) -> CLLocationCoordinate2D? {
        
        let numberOfCoords = path.count()
        
        let halfDistance:Double = distance/2
        
        let threadhold:Double = 10 //10 meters
        
        var midDistance = 0.0
        
        if numberOfCoords > 1 {
            
            var index = 0 as UInt
            
            while index  < numberOfCoords{
                
                //1.1 cal the next distance
                
                let currentCoord = path.coordinate(at: index)
                
                let nextCoord = path.coordinate(at: index + 1)
                
                let newDistance = GMSGeometryDistance(currentCoord, nextCoord)
                
                midDistance = midDistance + newDistance
                
                if fabs(midDistance - halfDistance) < threadhold { //Found the middle point in route
                    
                    return nextCoord
                    
                }
                
                index = index + 1
                
            }
            
        }
        return nil //Return nil if we cannot find middle point in path for some reason
    }
    
}
