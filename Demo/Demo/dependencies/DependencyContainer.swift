import Foundation

// MARK: - Protocols & DI
protocol JobServiceProtocol {
    func fetchJobs() async throws -> [Job]
}

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    // Configurable runtime network mocking client
    var jobService: JobServiceProtocol = MockJobService()
    
    private init() {}
}
