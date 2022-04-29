//
//  LogUtilities.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-09.
//

import Foundation

///
/// log printer
///

// easy function
func Xlog(_ msg: String) {
    LogUtilities.log(msg)
}

protocol LogUtilitiesPrinter {
    mutating func onPrint(_ msg: String)
}

class LogUtilities {
    
    static var logPrinter: LogUtilitiesPrinter?
    
    static public func registLogPrinter(_ printer: LogUtilitiesPrinter) {
        logPrinter = printer
    }

    static public func log(_ msg: String) {
        print(msg)
        logPrinter?.onPrint(msg)
    }
}
