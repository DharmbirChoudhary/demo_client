import Observation
import SwiftUI

enum ViewState: Equatable {
    case loading
    case empty
    case loaded
    case error(String)
}

@Observable
@MainActor
final class JobListViewModel {
    // Implicitly observable properties instead of @Published
    private(set) var state: ViewState = .loading
    var searchText: String = ""
    
    private var allJobs: [Job] = []
    private let jobService: JobServiceProtocol
    
    init(jobService: JobServiceProtocol = DependencyContainer.shared.jobService) {
        self.jobService = jobService
    }
    
    // Computed property updates automatically whenever searchText or allJobs changes
    var filteredJobs: [Job] {
        guard !searchText.isEmpty else { return allJobs }
        return allJobs.filter { job in
            job.title.localizedCaseInsensitiveContains(searchText) ||
            job.companyName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadJobs() async {
        state = .loading
        do {
            allJobs = try await jobService.fetchJobs()
            state = allJobs.isEmpty ? .empty : .loaded
        } catch {
            state = .error("Failed to load jobs. Please check your connection.")
        }
    }
}
