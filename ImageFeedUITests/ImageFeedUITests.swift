//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Roman Romanov on 17.08.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("eduardkarimov.rb@gmail.com")// TODO: data from network
        app.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("A2c2d2c2")// TODO: data from network
        app.buttons["Done"].tap()

        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 3))
        loginButton.tap()
        
        let predicate = NSPredicate(format: "label CONTAINS 'Continue as'")
        let createAccountText = app.webViews.buttons.containing(predicate)
        let continueButton = createAccountText.element(boundBy: 0)
        continueButton.waitForExistence(timeout: 5)
        
        if continueButton.exists {
            continueButton.tap()
        }
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        sleep(15)
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}
