import XCTest
@testable import ActiveDays

class DateExtensionTest: XCTestCase {

	func testBeginOfTheWeek1() {
		guard let date = Date.from(year: 2018, month: 5, day: 9, hour: 16, minute: 4, second: 0),
		      let begin = date.weekBeginDay else {
			return
		}
		let gmt0 = TimeZone(secondsFromGMT: 0)!
		let calendar = Calendar(identifier: .gregorian)
		let components = calendar.dateComponents(in: gmt0, from: begin)
		XCTAssertTrue(components.year == 2018)
		XCTAssertTrue(components.month == 5)
		XCTAssertTrue(components.day == 7)
		XCTAssertTrue(components.hour == 0)
		XCTAssertTrue(components.second == 0)
		XCTAssertTrue(components.minute == 0)
	}

	func testBeginOfTheWeek2() {
		guard let date = Date.from(year: 2018, month: 5, day: 25, hour: 16, minute: 4, second: 0),
		      let begin = date.weekBeginDay else {
			return
		}
		let gmt0 = TimeZone(secondsFromGMT: 0)!
		let calendar = Calendar(identifier: .gregorian)
		let components = calendar.dateComponents(in: gmt0, from: begin)
		XCTAssertTrue(components.year == 2018)
		XCTAssertTrue(components.month == 5)
		XCTAssertTrue(components.day == 21)
		XCTAssertTrue(components.hour == 0)
		XCTAssertTrue(components.second == 0)
		XCTAssertTrue(components.minute == 0)
	}

	func testIsSameDay() {
		guard let date1 = Date.from(year: 2018, month: 5, day: 25, hour: 16, minute: 4, second: 0),
		      let date2 = Date.from(year: 2018, month: 5, day: 25, hour: 17, minute: 4, second: 0) else {
			return
		}
		XCTAssertTrue(date1.isInSameDay(with: date2))
	}

	func testIsNotSameDay() {
		guard let date1 = Date.from(year: 2018, month: 5, day: 25, hour: 16, minute: 4, second: 0),
		      let date2 = Date.from(year: 2017, month: 5, day: 25, hour: 17, minute: 4, second: 0) else {
			return
		}
		XCTAssertFalse(date1.isInSameDay(with: date2))

	}


}
