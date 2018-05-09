import XCTest
@testable import ActiveDays

final class ActiveDaysTests: XCTestCase {
	var counter: ActiveDaysPerWeekCounter!

	override func setUp() {
		self.counter = ActiveDaysPerWeekCounter(setingKey: "com.kkbox.activedays")
		self.counter.reset()
	}

	override func tearDown() {
		self.counter.reset()
		self.counter = nil
	}

	func testStartSession() {
		XCTAssertTrue(self.counter.startNewSessionIfNoExitingOne())
		XCTAssertFalse(self.counter.startNewSessionIfNoExitingOne())
	}

	func testUnstartedSession() {
		do {
			_ = try self.counter.commit(accessDate: Date())
			XCTFail()
		} catch {
			XCTAssertNotNil(error)
		}
	}

	func testOldDate() {
		self.counter.startSession(date: Date.from(year: 2018, month: 5, day: 9, hour: 1, minute: 2, second: 3)!)
		do {
			_ = try self.counter.commit(accessDate: Date.from(year: 2018, month: 4, day: 15, hour: 1, minute: 2, second: 3)!)
			XCTFail()
		} catch ActiveDaysCounterError.invalidDate {
		} catch {
			XCTFail()
		}
	}

	func testNeedNewSession() {
		self.counter.startSession(date: Date.from(year: 2018, month: 5, day: 9, hour: 1, minute: 2, second: 3)!)
		do {
			_ = try self.counter.commit(accessDate: Date.from(year: 2018, month: 6, day: 15, hour: 1, minute: 2, second: 3)!)
			XCTFail()
		} catch ActiveDaysCounterError.needsNewSession {
		} catch {
			XCTFail()
		}
	}

	func testCommit() {
		self.counter.startSession(date: Date.from(year: 2018, month: 5, day: 9, hour: 1, minute: 2, second: 3)!)
		var result = try! self.counter.commit(accessDate: Date.from(year: 2018, month: 5, day: 9, hour: 1, minute: 2, second: 3)!)
		if case let .active(days) = result {
			XCTAssertTrue(days == 1)
		} else {
			XCTFail()
		}
		result = try! self.counter.commit(accessDate: Date.from(year: 2018, month: 5, day: 9, hour: 2, minute: 2, second: 3)!)
		if case .noEvent = result {
		} else {
			XCTFail()
		}

		result = try! self.counter.commit(accessDate: Date.from(year: 2018, month: 5, day: 11, hour: 2, minute: 2, second: 3)!)
		if case let .active(days) = result {
			XCTAssertTrue(days == 2)
		} else {
			XCTFail()
		}

		result = try! self.counter.commit(accessDate: Date.from(year: 2018, month: 5, day: 11, hour: 8, minute: 2, second: 3)!)
		if case .noEvent = result {
		} else {
			XCTFail()
		}


		do {
			_ = try self.counter.commit(accessDate: Date.from(year: 2018, month: 5, day: 9, hour: 1, minute: 2, second: 3)!)
			XCTFail()
		} catch ActiveDaysCounterError.invalidDate {
		} catch {
			XCTFail()
		}

		result = try! self.counter.commit(accessDate: Date.from(year: 2018, month: 5, day: 13, hour: 2, minute: 2, second: 3)!)
		if case let .active(days) = result {
			XCTAssertTrue(days == 3)
		} else {
			XCTFail()
		}

		do {
			_ = try self.counter.commit(accessDate: Date.from(year: 2018, month: 5, day: 14, hour: 1, minute: 2, second: 3)!)
			XCTFail()
		} catch ActiveDaysCounterError.needsNewSession {
		} catch {
			XCTFail()
		}
	}

}
