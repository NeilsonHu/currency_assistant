//
//  ForVisaTask.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-03.
//

import Foundation
import WebKit

///
/// to request visa time on conditions
///
class ForVisaTask {
    
    static public let shared = ForVisaTask()
        
    private let request = FVRequest()
    
    public func startTask() {
        Xlog("startTask")
        _processUntil("5:59 AM") { [weak self] in
            self?.tryTaskForOnce()
            self?._tryFixSchedule()
        }
    }
        
    public func tryTaskForOnce() {
        Xlog("tryTaskForOnce")
        request.startDataRequest(whiteList: ["Ottawa", "Toronto"], { [weak self] result in
            self?._processResponse(result)
        })
    }
    
    public func getWebView() -> WKWebView {
        return request.embedWebView
    }
    
}

///
/// private methods
///
extension ForVisaTask {
        
    private func _getCurrentTime() -> String {
        let format = DateFormatter()
        format.dateStyle = .none
        format.timeStyle = .short
        return format.string(from: Date())
    }
    
    private func _processUntil(_ time: String, _ block: (@escaping ()->Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let s = self else {
                return
            }
            if s._getCurrentTime().contains(time) {
                block()
            } else {
                s._processUntil(time, block)
            }
        }
    }
    
    private func _tryFixSchedule() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let s = self else {
                return
            }
            let date = s._getCurrentTime()
            if date.contains(":01 ") || date.contains(":31 ") {
                s.tryTaskForOnce()
                s._nextTask()
            } else {
                s._tryFixSchedule()
            }
        }
    }
    
    private func _nextTask() {
            // loop every 30mins
        DispatchQueue.main.asyncAfter(deadline: .now() + 1800) { [weak self] in
            self?.tryTaskForOnce()
            self?._nextTask() // loop
        }
    }
    
    @discardableResult
    private func _processResponse(_ rsp: [String: [[String: Any]]], isTest: Bool = false) -> String? {
        guard !rsp.isEmpty else {
            Xlog("All cities are empty")
            return nil
        }
        var mostRecentDay: String = "2022-12-30"
        var cityName: String = ""
        rsp.forEach { (key: String, value: [[String: Any]]) in
            guard !value.isEmpty else {
                Xlog("\(key) is empty")
                return
            }
            value.forEach { dict in
                guard let time = dict["date"] as? String else {
                    Xlog("\(key) is empty")
                    return
                }
                Xlog("\(key):\(time)")
                if time <= mostRecentDay {
                    mostRecentDay = time
                    cityName = key
                }
            }
        }
        if !cityName.isEmpty {
            let content = "Find \(mostRecentDay) of \(cityName) !"
            if !isTest {
                PushManager().pushToDefault(content)
            }
            return content
        }
        return nil
    }
}

///
/// for unitTest
///
extension ForVisaTask {
    public func testProcessResponse(_ rsp: [String: [[String: Any]]]) -> String? {
        let result: String? = _processResponse(rsp, isTest:true)
        print(result ?? "nil")
        return result
    }
}
