# Growth Map

<p align="center">
  <img src="https://github.com/user-attachments/assets/4b2f1c8c-8d8a-4b2f-8d8a-4b2f1c8c8d8a" alt="Growth Map Logo" width="200"/>
</p>

<p align="center">
  <strong>Your AI-Powered Personal Development Journey</strong>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#api-integration">API Integration</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#license">License</a>
</p>

---

## 🌱 Overview

Growth Map is an innovative iOS application that leverages artificial intelligence to create personalized learning paths and development goals for users. The app transforms ambitious objectives into structured, achievable weekly sprints with AI-generated skill trees and actionable tasks.

### Key Benefits
- 🤖 **AI-Powered Planning**: Automatically generate skill trees and learning paths from your goals
- 📋 **Sprint Management**: Break down long-term goals into manageable weekly tasks
- 📊 **Progress Tracking**: Monitor your development journey with detailed reports
- 🔐 **Secure Authentication**: Safeguard your progress with robust security measures

---

## 🚀 Features

### 🎯 Goal Management
- Create and manage personal development goals
- Set time horizons and daily commitment levels
- Track goal status (Draft, Active, Paused, Completed)

### 🌳 AI-Generated Skill Trees
- Automatic generation of skill trees from goal descriptions
- Structured learning paths with progressive difficulty
- Detailed node information with focus hours recommendations

### 📅 Sprint Planning
- Weekly sprint generation with specific tasks
- Progress tracking with status updates (Pending, Done, Skipped)
- Regeneration capability based on progress and feedback

### 📈 Growth Reports
- Comprehensive progress analysis
- AI-generated insights and recommendations
- Detailed sprint summaries and metrics

### 🔐 User Authentication
- Secure sign-up and sign-in functionality
- Session management and auto-refresh
- User profile management

---

## 🛠️ Installation

### Prerequisites
- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- Supabase account (for backend services)

### Getting Started

1. **Clone the Repository**
```bash
git clone https://github.com/your-username/growth-map.git
cd growth-map
```

2. **Install Dependencies**
- Open the project in Xcode
- Xcode will automatically resolve Swift Package dependencies
- Ensure all dependencies are properly linked

3. **Set Up Environment Variables**
- Create a `.env` file in the project root (template provided in `.env.example`)
- Add your Supabase URL and anonymous key

---

## ⚙️ Configuration

### Environment Variables
Create a `.env` file with the following variables:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Supabase Setup
1. Create a free Supabase account at [supabase.com](https://supabase.com)
2. Create a new project
3. Update your database schema based on the provided models:
   - `goals` table
   - `skill_trees` table
   - `sprint_tasks` table
   - `sprints` table
   - `profiles` table

---

## 🌐 API Integration

Growth Map integrates with Supabase for backend services and uses AI-powered Edge Functions for intelligent features:

### Edge Functions
- **create-growth-map**: Generate complete growth maps with skill trees and initial sprints
- **regenerate-sprint**: Regenerate sprints based on progress and feedback
- **growth-report**: Generate comprehensive growth reports with insights
- **get-goal-detail**: Fetch detailed goal information

### Data Models
The app uses structured data models for seamless API communication:

```swift
struct Goal: Codable {
    let id: UUID
    let userId: UUID
    let title: String
    let description: String
    // ... more properties
}

struct SkillTreeWithNodes: Codable {
    let skillTree: SkillTree
    let nodes: [SkillTreeNode]
}

struct SprintWithTasks: Codable {
    let sprint: Sprint
    let tasks: [SprintTask]
}
```

---

## 🏗️ Architecture

### Layered Architecture
```
┌─────────────────┐
│   Presentation  │  SwiftUI Views
├─────────────────┤
│   Business Logic│  Services & Managers  
├─────────────────┤
│   Data Models   │  Codable Structs
├─────────────────┤
│   API Layer     │  Supabase Integration
└─────────────────┘
```

### Core Components

#### Services
- **SupabaseService**: Handles authentication, database operations, and session management
- **GrowthMapAPI**: Manages AI-powered edge function calls
- **DateFormatters**: Centralized date formatting utilities

#### Models
- **Goal**: Represents user development objectives
- **SkillTree**: Structured learning path data
- **Sprint**: Time-bounded development period
- **SprintTask**: Individual actionable items

#### Views
- **ContentView**: Main application interface
- **Goal Views**: Goal creation and management interfaces
- **Skill Tree Views**: Visual representations of learning paths
- **Sprint Views**: Task management and progress tracking

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests if applicable
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Standards
- Follow Swift API Design Guidelines
- Write clear, concise commit messages
- Add documentation to public APIs
- Ensure all tests pass before submitting

### Reporting Issues
When reporting issues, please include:
- Detailed steps to reproduce
- Expected vs. actual behavior
- iOS version and device information
- Any relevant screenshots or logs

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🌟 Support

If you find Growth Map helpful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs and issues
- ✨ Contributing features and improvements

---

## 📞 Contact

- **Project Link**: [Growth Map](https://github.com/your-username/growth-map)
- **Issues**: [GitHub Issues](https://github.com/your-username/growth-map/issues)

---

<p align="center">
  <em>Transform your ambitions into achievable growth with Growth Map</em>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/4b2f1c8c-8d8a-4b2f-8d8a-4b2f1c8c8d8b" alt="Growth Map Screenshot" width="300"/>
</p>