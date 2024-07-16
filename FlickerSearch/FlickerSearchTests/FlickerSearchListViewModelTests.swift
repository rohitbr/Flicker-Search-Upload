//
//  FlickerSearchListViewModelTests.swift
//  FlickerSearchTests
//
//  Created by Bhat, Rohit on 7/16/24.
//

import XCTest
@testable import FlickerSearch

final class FlickerSearchListViewModelTests: XCTestCase {
    
    var vm : FlickerSearchListViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.'
        vm = FlickerSearchListViewModel(networkManager: NetworkManager())
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vm = nil
    }
    
    func testResetState() {
        vm?.resetState()
        XCTAssertEqual(vm?.pageNumber, 1)
        XCTAssertEqual(vm?.photoArray, [])
    }
}
