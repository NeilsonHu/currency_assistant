//
//  LogUtilities.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-09.
//

import Foundation

protocol LogUtilitiesPrinter {
    mutating func onPrint(_ msg: String)
}

func Xlog(_ msg: String) {
    LogUtilities.log(msg)
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
