//
//  TFLAPIHandler.swift
//  GigRoulette
//
//  Created by apple on 16/06/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
// 2af9a281d929bcb15d3f0838ee372f2a

func getDirections(FromStartPoint startPoint: Point, ToEndPoint endPoint: Point, WithSuccess success: @escaping (Journey)->()) {
    //https://api.tfl.gov.uk/Journey/JourneyResults/51.5412969%2C-0.0954148/to/51.5388457%2C-0.1367267
    
    let urlRequest = URLRequest(url: URL(string:"https://api.tfl.gov.uk/Journey/JourneyResults/\(startPoint.lat)%2C\(startPoint.lon)/to/\(endPoint.lat)%2C\(endPoint.lon)")!)
    
    let defaultSession: URLSession = URLSession(configuration: .default)
    defaultSession.dataTask(with: urlRequest) { (responseData, responseURL, responseError) in
        if responseError != nil {
            print("failed")
        } else {
            do {
                let serializedData = try JSONSerialization.jsonObject(with: responseData!, options:.allowFragments) as! [String : AnyObject]
                                
                guard let journeys = serializedData["journeys"] as? [[String: AnyObject]], let firstJourney = journeys.first else {
                    print("no journeys")
                    return
                }
                
                guard let duration = firstJourney["duration"] as? Int, let legs = firstJourney["legs"] as? [[String: AnyObject]] else {
                    print("unparseable")
                    return
                }
                
                var theJourney = Journey(durationMinutes: duration)
                
                for leg in legs {
                    guard let duration = leg["duration"] as? Int, let instruction = leg["instruction"] as? [String: AnyObject], let description = instruction["summary"] as? String else { continue }
                    theJourney.legs.append(Leg(duration: duration, description: description))
                }
                
                print(theJourney)
                NotificationCenter.default.post(name: NotificationName.journeyReceived.realName, object: nil)
                
                DispatchQueue.main.async {
                    success(theJourney)
                }
            } catch {
                print("Failed to serialize responseData to [String : AnyObject]")
            }
        }
    }.resume()
}
