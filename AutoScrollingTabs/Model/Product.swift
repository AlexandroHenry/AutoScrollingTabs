//
//  Product.swift
//  AutoScrollingTabs
//
//  Created by Seungchul Ha on 2023/02/17.
//

import SwiftUI

struct Product: Identifiable, Hashable {
	
	var id : UUID = UUID()
	var type: ProductType
	var title: String
	var subtitle: String
	var price: String
	var productImage: String = ""
}

enum ProductType: String, CaseIterable {
	case iphone = "iPhone"
	case ipad = "iPad"
	case macbook = "MacBook"
	case desktop = "Mac Desktop"
	case appleWatch = "Apple Watch"
	case airpods = "Airpods"
	
	var tabID: String {
		/// Creating Another UniqueID for Tab Scrolling
		/// Unique IDs for section and tab scrolling, rather than the same ID, to avoid incorret animations.
		return self.rawValue + self.rawValue.prefix(4)
	}
}

var products: [Product] = [
	// Apple Watch
	Product(type: .appleWatch, title: "Apple Watch", subtitle: "Ultra: Alphine Loop", price: "$999", productImage: "AppleWatchUltra"),
	Product(type: .appleWatch, title: "Apple Watch", subtitle: "Series 5: Black", price: "$599", productImage: "AppleWatch5"),
	Product(type: .appleWatch, title: "Apple Watch", subtitle: "Series 6: Hermes", price: "$799", productImage: "AppleWatch6Hermes"),
	Product(type: .appleWatch, title: "Apple Watch", subtitle: "Series 8: Black", price: "$899", productImage: "AppleWatch8"),
	// iPhone's
	Product(type: .iphone, title: "iPhone 14 Pro Max", subtitle: "A16 - Purple", price: "$1299", productImage: "iPhone14ProMax"),
	Product(type: .iphone, title: "iPhone 14 Pro", subtitle: "A16 - Purple", price: "$1099", productImage: "iPhone14Pro"),
	Product(type: .iphone, title: "iPhone 11", subtitle: "A13 - Black", price: "$499", productImage: "iPhone11"),
	Product(type: .iphone, title: "iPhone 12", subtitle: "A14 - Red", price: "$599", productImage: "iPhone12"),
	Product(type: .iphone, title: "iPhone 13 Pro", subtitle: "A15 - Blue", price: "$999", productImage: "iPhone13Pro"),
	// Macbook
	Product(type: .macbook, title: "Macbook Pro", subtitle: "M2 MAx - Space Gray", price: "$2599", productImage: "MacbookPro"),
	Product(type: .macbook, title: "Macbook Air", subtitle: "M1 Pro - Space Gray", price: "$1299", productImage: "MacbookAir"),
	// iPad
	Product(type: .ipad, title: "iPad Pro", subtitle: "M1 - Gray", price: "$1399", productImage: "iPadPro"),
	Product(type: .ipad, title: "iPad Air 4", subtitle: "A14 - Pink", price: "$599", productImage: "iPadAir"),
	Product(type: .ipad, title: "iPad Mini", subtitle: "A15 - Gray", price: "$499", productImage: "iPadMini"),
	// Desktop
	Product(type: .desktop, title: "Mac Studio", subtitle: "M1 Max - Silver", price: "$1999", productImage: "MacStudio"),
	Product(type: .desktop, title: "Mac Mini", subtitle: "M2 Pro - Space Gray", price: "$999", productImage: "MacMini"),
	Product(type: .desktop, title: "Mac Pro", subtitle: "3.5GHz 8‑core Intel Xeon W processor, Turbo Boost up to 4.0GHz", price: "$9999", productImage: "MacPro"),
	Product(type: .desktop, title: "iMac", subtitle: "M1 - Purple", price: "$1599", productImage: "iMac"),
	// Airpods
	Product(type: .airpods, title: "Airpods", subtitle: "Pro 2nd Gen", price: "$249", productImage: "AirPods2"),
	Product(type: .airpods, title: "Airpods", subtitle: "3rd Gen", price: "$179", productImage: "AirPods3"),
	Product(type: .airpods, title: "Airpods", subtitle: "Max - Space Gray", price: "$799", productImage: "AirPodsMax"),
]
