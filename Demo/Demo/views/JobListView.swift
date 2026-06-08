import SwiftUI


import SwiftUI
import Observation

struct JobListView: View {
    // Modern Observation Framework initialization
    @State private var viewModel = JobListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 1. Explicit Search Bar on Top
                searchBar
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                
                // 2. State-Based Content
                Group {
                    switch viewModel.state {
                    case .loading:
                        Spacer()
                        ProgressView("Fetching Jobs...")
                        Spacer()
                        
                    case .empty:
                        Spacer()
                        ContentUnavailableView(
                            "No Jobs Found",
                            systemImage: "briefcase.slash",
                            description: Text("Try searching for a different title or company.")
                        )
                        Spacer()
                        
                    case .error(let message):
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 44)).foregroundColor(.red)
                            Text(message).multilineTextAlignment(.center)
                            Button("Retry") {
                                Task { await viewModel.loadJobs() }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        Spacer()
                        
                    case .loaded:
                        List(viewModel.filteredJobs) { job in
                            NavigationLink(destination: JobDetailView(job: job)) {
                                JobRowView(job: job)
                            }
                            .listRowSeparator(.visible)
                        }
                        .listStyle(.plain) // Clean look without group containers
                    }
                }
            }
            // 3. Removed .navigationTitle("Find Work")
            // The navigation bar is now hidden or transparent by default without a title
        }
        .task {
            await viewModel.loadJobs()
        }
    }
    
    // MARK: - Search Bar Component
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Using @Bindable for properties in an @Observable class
            TextField("Search title or company...", text: Bindable(viewModel).searchText)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Row View
struct JobRowView: View {
    let job: Job
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(job.title)
                .font(.headline)
            
            Text(job.companyName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Label(job.location, systemImage: "mappin.and.ellipse")
                Spacer()
                Text(job.salaryRange)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .font(.caption)
            .padding(.top, 2)
        }
        .padding(.vertical, 8)
    }
}
