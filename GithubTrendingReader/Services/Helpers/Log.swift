//
//  Log.swift
//  Way
//
//  Created by Laurent Grondin on 17/01/2017.
//  Copyright © 2017 LG. All rights reserved.
//

import Foundation
import SystemConfiguration

public func log_info(_ text: String, className: String = #file, functionName: String = #function) {
    #if DEBUG
//        let string : NSString = NSString(format: "%@ | %@ - %@ :\n%@\n", Thread.current.threadName, className.components(separatedBy: "/").last!, functionName, text)
    let string: NSString = NSString(format: "%@ - %@ :\n%@\n", className.components(separatedBy: "/").last!, functionName, text)
    print(string)
    #endif
}

public func log_start(className: String = #file, functionName: String = #function) {
    #if DEBUG
//    let string : NSString = NSString(format: "%@ | %@ - %@ :\n--- START ---\n", Thread.current.threadName, className.components(separatedBy: "/").last!, functionName)
    let string: NSString = NSString(format: "%@ - %@ :\n--- START ---\n", className.components(separatedBy: "/").last!, functionName)
    print(string)
    #endif
}

public func log_done(className: String = #file, functionName: String = #function) {
    #if DEBUG
    //    let string : NSString = NSString(format: "%@ | %@ - %@ :\n--- DONE ---\n", Thread.current.threadName, className.components(separatedBy: "/").last!, functionName)
    let string: NSString = NSString(format: "%@ - %@ :\n--- DONE ---\n", className.components(separatedBy: "/").last!, functionName)
    print(string)
    #endif
}

public func log_error(_ text: String, className: String = #file, functionName: String = #function) {
    #if DEBUG
    let string: NSString = NSString(format: "*** ERROR *** %@ - %@ :\n%@\n", className.components(separatedBy: "/").last!, functionName, text)
    print(string)
    #endif
}

extension Thread {
    
    var threadName: String {
        if let currentOperationQueue = OperationQueue.current?.name {
            return "\(currentOperationQueue)"
        } else if let underlyingDispatchQueue = OperationQueue.current?.underlyingQueue?.label {
            return "\(underlyingDispatchQueue)"
        } else {
            let name = __dispatch_queue_get_label(nil)
            return String(cString: name, encoding: .utf8) ?? Thread.current.description
        }
    }
}
