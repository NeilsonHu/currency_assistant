//
//  CurrencyAssistantServerTests.swift
//  CurrencyAssistantServerTests
//
//  Created by neilson on 2022-03-19.
//

import XCTest
@testable import CurrencyAssistantServer

class CurrencyAssistantServerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPushMananger() throws {
        PushManager().pushToDefault("123")
    }
    
    func testProcessResponse() throws {
        //public func testProcessResponse(_ rsp: [String: [[String: Any]]]) -> String?
        let task = ForVisaTask()
        
        var rsp: [String: [[String: Any]]] = [:]
        XCTAssertNil(task.testProcessResponse(rsp))
        
        rsp = ["a": [["a":true]]]
        XCTAssertNil(task.testProcessResponse(rsp))
        
        rsp = ["a": [["date":"2023-01-01"]]]
        XCTAssertNil(task.testProcessResponse(rsp))
        
        rsp = ["a": [["date":"2023-01-01"],["date":"2023-01-01"]]]
        XCTAssertNil(task.testProcessResponse(rsp))
        
        rsp = ["a": [["date":"2021-01-01"],["date":"2023-01-01"]]]
        var result: String? = task.testProcessResponse(rsp)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "Find 2021-01-01 of a !")
        
        rsp = ["a": [["date":"2023-01-01"],["date":"2023-01-01"]],
               "b": [["date":"2021-01-01"],["date":"2023-01-01"]]]
        result = task.testProcessResponse(rsp)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "Find 2021-01-01 of b !")
        
        rsp = ["a": [["date":"2020-01-01"],["date":"2023-01-01"]],
               "b": [["date":"2021-01-01"],["date":"2023-01-01"]]]
        result = task.testProcessResponse(rsp)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "Find 2020-01-01 of a !")
    }

}
