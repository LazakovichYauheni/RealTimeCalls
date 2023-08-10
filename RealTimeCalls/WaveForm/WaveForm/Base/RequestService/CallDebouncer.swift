import Foundation

public final class CallDebouncer {
    // MARK: - Private Properties

    private let queue = DispatchQueue(label: "com.application.throttler", qos: .default)

    private var job = DispatchWorkItem(block: {})
    private var currentJob = DispatchWorkItem(block: {})
    private var delay: TimeInterval

    // MARK: - Public Methods

    public init(delay: TimeInterval) {
        self.delay = delay
    }

    public func throttle(block: @escaping (() -> Void)) {
        currentJob = job
        job.cancel()
        job = DispatchWorkItem { [weak self] in
            guard self?.job.isCancelled == false else { return }
            block()
        }
        queue.asyncAfter(deadline: .now() + delay, execute: job)
    }

    public func flush() {
        job.cancel()
    }
    
    public func cancelCurrentJob() {
        currentJob.cancel()
    }
}
