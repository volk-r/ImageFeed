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

        if continueButton.waitForExistence(timeout: 5) {
            continueButton.tap()
        }
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp(velocity: .slow)
        
        sleep(2)
        
        app.swipeDown()
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
        
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        
        cellToLike.tap()

        let singleImageView = app.scrollViews.images["SingleImageView"]
        XCTAssertTrue(singleImageView.waitForExistence(timeout: 5))
        
        singleImageView.pinch(withScale: 3, velocity: 1)
        sleep(1)
        singleImageView.pinch(withScale: 0.5, velocity: -1)
        sleep(1)

        let navBackButtonWhiteButton = "BackButton"
        app.buttons[navBackButtonWhiteButton].tap()
        
        let feed = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(feed.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 2)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        func yourElement() -> XCUIElement {
            let string = "@"
            let predicate = NSPredicate(format: "label CONTAINS[c] '\(string)'")
            return app.staticTexts.matching(predicate).firstMatch
        }
        
        XCTAssert(yourElement().waitForExistence(timeout: 5))
        
        let logoutButton = app.buttons["ExitButton"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 1))
        logoutButton.tap()

        let logoutAlert = app.alerts["Alert"]
        XCTAssertTrue(logoutAlert.waitForExistence(timeout: 3), "Logout alert has not been appeared")
        
        logoutAlert.scrollViews.otherElements.buttons["Да"].tap()
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }
}
