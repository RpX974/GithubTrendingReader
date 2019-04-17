//
//  Log.swift
//  Way
//
//  Created by Laurent Grondin on 17/01/2017.
//  Copyright © 2017 LG. All rights reserved.
//

import Foundation
import SystemConfiguration

public func log_info(_ text:String, className:String = #file, functionName:String = #function){
    #if DEBUG
//        let string : NSString = NSString(format: "%@| %@ - %@ : %@", Thread.current, className.components(separatedBy: "/").last!, functionName, text)
    let string : NSString = NSString(format: "%@ - %@ : %@", className.components(separatedBy: "/").last!, functionName, text)
        print(string)
    #endif
}

public func log_start(className:String = #file, functionName:String = #function){
    #if DEBUG
//    let string : NSString = NSString(format: "%@| %@ - %@ : --- START ---", Thread.current, className.components(separatedBy: "/").last!, functionName)
    let string : NSString = NSString(format: "%@ - %@ : --- START ---", className.components(separatedBy: "/").last!, functionName)
        print(string)
    #endif
}

public func log_done(className:String = #file, functionName:String = #function){
    #if DEBUG
    let string : NSString = NSString(format: "%@ - %@ : --- DONE ---", className.components(separatedBy: "/").last!, functionName)
//    let string : NSString = NSString(format: "%@| %@ - %@ : --- DONE ---", Thread.current, className.components(separatedBy: "/").last!, functionName)
    print(string)
    #endif
}

public func log_error(_ text:String, className:String = #file, functionName:String = #function){
    #if DEBUG
        let string : NSString = NSString(format: "*** ERROR *** %@ - %@ : %@", className.components(separatedBy: "/").last!, functionName, text)
        print(string)
    #endif
}
