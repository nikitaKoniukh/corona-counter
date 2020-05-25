//
//  Corona_CounterTests.swift
//  Corona CounterTests
//
//  Created by Nikita Koniukh on 10/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

import XCTest
@testable import Corona_Counter

class Corona_CounterTests: XCTestCase {
    var sut: NewMainViewController!

    override class func setUp() {
        super.setUp()
        sut = NewMainViewController()
        sut.activeCasesCardView
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
