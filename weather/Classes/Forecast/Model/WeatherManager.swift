//
//  WeatherManager.swift
//  
//
//  Created by Michal on 07/07/2015.
//
//

import UIKit

class WeatherManager: NSObject {

	class var sharedManager: WeatherManager
	{
		struct Singleton { static let shared = WeatherManager() }
		return Singleton.shared;
	}

	func weatherForDestination(destination: Destination) -> Void
	{
		// TODO: Implement
	}

	func weatherForCurrentLocation(#completion: ((destination: Destination?, record: WeatherRecord?) -> Void)?) -> Void
	{
		if (LocationManager.sharedManager.checkAuthorisation() != true)
		{ completion?(destination: nil, record: nil) }

		if let location = LocationManager.sharedManager.lastLocation
		{
			let urlString = String(format: "http://api.openweathermap.org/data/2.5/forecast?lat=%.5f&lon=%.5f",
				location.coordinate.latitude, location.coordinate.longitude)

			let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
			request.timeoutInterval = 5.0

			NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (response, data, error) -> Void in

				if (error != nil) { NSLog("Request error"); return; }

				let json = JSON(data: data)

				let city = json["city"]
				let destination = Destination(json: city)

				let entries = json["list"].array
				let record = WeatherRecord(json: entries?.first)

				completion?(destination: destination, record: record)
				
			}
		}
	}

}