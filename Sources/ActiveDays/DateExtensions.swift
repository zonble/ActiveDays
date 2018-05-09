import Foundation

extension Date {

	/// Create a new date instance basing on Gregorian calendar and
	/// GMT+0 timezone.
	///
	/// - Parameters:
	///   - year: year
	///   - month: month
	///   - day: day
	///   - hour: hour
	///   - minute: minute
	///   - second: second
	/// - Returns: a date instance.
	public static func from(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second
		let gmt0 = TimeZone(secondsFromGMT: 0)!
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = gmt0
		return calendar.date(from: components)
	}

	/// Return the day of the week where the date is at, basing on
	/// GMT+-0 timezone.
	public var weekBeginDay: Date? {
		let gmt0 = TimeZone(secondsFromGMT: 0)!
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = gmt0
		var components = calendar.dateComponents(in: gmt0, from: self)
		components.hour = 0
		components.minute = 0
		components.second = 0
		components.nanosecond = 0
		components.day = components.day! - components.weekdayOrdinal!
		components.weekdayOrdinal = 0
		return calendar.date(from: components)
	}

	/// If the date and another date is in the same date.
	public func isInSameDay(with date: Date) -> Bool {
		let gmt0 = TimeZone(secondsFromGMT: 0)!
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = gmt0

		let selfComponents = calendar.dateComponents(in: gmt0, from: self)
		let incomingComponents = calendar.dateComponents(in: gmt0, from: date)
		return selfComponents.year == incomingComponents.year &&
				selfComponents.month == incomingComponents.month &&
				selfComponents.day == incomingComponents.day
	}

}
