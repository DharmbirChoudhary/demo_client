import SwiftUI

struct JobDetailView: View {
    let job: Job
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Block
                VStack(alignment: .leading, spacing: 8) {
                    Text(job.title).font(.largeTitle).bold()
                    Text(job.companyName).font(.title3).foregroundColor(.secondary)
                }
                
                Divider()
                
                // Metadata Badges
                VStack(alignment: .leading, spacing: 12) {
                    Label("Location: \(job.location)", systemImage: "mappin.and.ellipse")
                    Label("Salary: \(job.salaryRange)", systemImage: "banknote")
                }
                .font(.body)
                
                Divider()
                
                // Job Details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Job Description").font(.title2).bold()
                    Text(job.description).font(.body).foregroundColor(.primary)
                }
                
                // Company Details
                VStack(alignment: .leading, spacing: 8) {
                    Text("About the Company").font(.title2).bold()
                    Text(job.companyInfo).font(.body).foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
