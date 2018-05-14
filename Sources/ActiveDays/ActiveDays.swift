import Foundation

/// Errors that may happen while using ActiveDaysPerWeekCounter.
public enum ActiveDaysCounterError: Error, LocalizedError {
	/// You did not start a session before commiting a new access ddate.
	case sessionUnstarted
	/// The date is before the begin of the week of the session.
	case invalidDate
	/// The date is much after the end of the week of the session, and
	/// you should create a new session.
	case needsNewSession

	public var errorDescription: String? {
		switch self {
		case .sessionUnstarted:
			return NSLocalizedString("You did not start a session.", comment: "")
		case .invalidDate:
			return NSLocalizedString("The incoming date is before the week.", comment: "")
		case .needsNewSession:
			return NSLocalizedString("The incoming date is not in the week. Please start a new session.", comment: "")
		}
	}
}


/// The result that you get when you commit a new access date to
/// ActiveDaysPerWeekCounter.
///
/// - noEvent: you should not send anything to an analytics platform.
/// - active: you should send an event to indicate how many days this
///           user has been active.
public enum ActiveDaysCounterResult {
	case noEvent
	case active(Int)
}


/// ActiveDaysPerWeekCounter is a class that we made to answer a
/// challenge: how do we know about how many days does a user uses our
/// app per week?
///
/// In KKBOX, we would like to find methods to measure how much does
/// our app engadge with our users, and active days per week could be
/// an indicator. However, it looks like most of the popular analytics
/// platforms such as Firebase and so on do not provide such
/// information.
///
/// Thus, we would like to make active days as "events" on analytics
/// platforms, for example, "active for one day", "active for two
/// days" could be events. ActiveDaysPerWeekCounter is a helper class
/// to let us decide if we should send an event, and which event, to
/// analytics platforms.
///
/// After creating an instance of ActiveDaysPerWeekCounter, you should
/// ask it to start a session. And then you can get a result when you
/// commit a new access date to the counter.

public class ActiveDaysPerWeekCounter {
	private var settingKey: String

	/// Create an instance.
	///
	/// - Parameter settingKey: the key for helping storing data.
	public init(settingKey: String) {
		self.settingKey = settingKey
	}

	/// Remove all saved data.
	public func reset() {
		self.sessionBeginDate = nil
		self.lastResult = nil
		self.lastResultMadeDate = nil
	}

	/// Start a new session, if there is no existing session. You need
	/// to start a session before commiting new access date to the
	/// counter.
	///
	/// - Returns: true if a new session is started, otherwise
	///            the counter is using an existing session.
	public func startNewSessionIfNoExitingOne() -> Bool {
		if let _ = self.sessionBeginDate {
			return false
		}
		self.startSession(date: Date())
		return true
	}

	/// Start a new session by a given date, and the base of the
	/// session of be the start of the week where the given date is
	/// in.
	///
	/// You need to start a session before commiting new access date
	/// to the counter. If there is an existing session, it will be
	/// replaced with the new one.
	///
	/// - Parameter date: the date for helping deciding the time base
	///                   of the session.
	public func startSession(date: Date) {
		self.sessionBeginDate = date.weekBeginDay
		self.lastResult = nil
		self.lastResultMadeDate = nil
	}


	/// Commit a new access date, and return a result which indicates if you
	/// should send an event.
	///
	/// - Parameter accessDate: a new date for accessing the counter.
    /// - Returns: .active(days) if you should send an event for a
    ///             specific day count, or .noEvent, if you need not
    ///             do anything.
	/// - Throws: ActiveDaysCounterError
	public func commit(accessDate: Date) throws -> ActiveDaysCounterResult {
		guard let beginDate = self.sessionBeginDate else {
			throw ActiveDaysCounterError.sessionUnstarted
		}
		if accessDate.compare(beginDate) == ComparisonResult.orderedAscending {
			throw ActiveDaysCounterError.invalidDate
		}
		if accessDate.timeIntervalSince(beginDate) > 7 * 24 * 60 * 60 {
			throw ActiveDaysCounterError.needsNewSession
		}

		guard let lastResultMadeDate = self.lastResultMadeDate,
		      let lastResult = self.lastResult else {
			self.lastResultMadeDate = accessDate
			self.lastResult = 1
			return .active(1)
		}

		if accessDate.compare(lastResultMadeDate) == ComparisonResult.orderedAscending {
			throw ActiveDaysCounterError.invalidDate
		}

		if lastResultMadeDate.isInSameDay(with: accessDate) {
			return .noEvent
		}

		let newResult = lastResult + 1
		self.lastResult = newResult
		self.lastResultMadeDate = accessDate
		return .active(newResult)
	}

}


private extension ActiveDaysPerWeekCounter {

	private var sessionBeginDate: Date? {
		get {
			return UserDefaults.standard.object(forKey: settingKey + "-sessionBegin") as? Date
		}
		set {
			guard let newValue = newValue else {
				UserDefaults.standard.removeObject(forKey: settingKey + "-sessionBegin")
				return
			}
			UserDefaults.standard.set(newValue, forKey: settingKey + "-sessionBegin")
			UserDefaults.standard.synchronize()
		}
	}

	private var lastResult: Int? {
		get {
			guard let int = UserDefaults.standard.object(forKey: settingKey + "-lastResult") as? Int else {
				return nil
			}
			return int
		}
		set {
			guard let newValue = newValue else {
				UserDefaults.standard.removeObject(forKey: settingKey + "-lastResult")
				return
			}
			UserDefaults.standard.set(newValue, forKey: settingKey + "-lastResult")
			UserDefaults.standard.synchronize()
		}
	}

	private var lastResultMadeDate: Date? {
		get {
			return UserDefaults.standard.object(forKey: settingKey + "-lastDate") as? Date
		}
		set {
			guard let newValue = newValue else {
				UserDefaults.standard.removeObject(forKey: settingKey + "-lastDate")
				return
			}
			UserDefaults.standard.set(newValue, forKey: settingKey + "-lastDate")
			UserDefaults.standard.synchronize()
		}
	}
}
