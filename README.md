# Internal Documentation Chatbot

A modern, AI-powered chatbot system for internal company documentation with admin management capabilities.

## 🚀 Features

### Intelligent Chatbot
- **Smart Search**: Advanced keyword extraction and full-text search
- **AI Summarization**: Contextual summaries of relevant articles
- **Modern UI**: Futuristic design with glass morphism and animations
- **Real-time Chat**: Instant responses with typing indicators
- **Markdown Support**: Rich text formatting with syntax highlighting

### Admin Panel
- **Article Management**: Full CRUD operations for documentation
- **Rich Editor**: Markdown editor with live preview
- **Category System**: Organize articles by Frontend, Backend, DevOps, etc.
- **Keyword Tagging**: Enhanced search capabilities
- **Author Attribution**: Track article creators and modifications

### Advanced Search
- **Multi-layered Search**: Keyword matching + full-text search
- **Relevance Ranking**: PostgreSQL-powered search with GIN indexes
- **Context Awareness**: Smart summarization based on query type
- **Performance Optimized**: Efficient database queries and caching

## 🛠 Tech Stack

- **Frontend**: React 18 + TypeScript + Tailwind CSS
- **Backend**: Supabase (PostgreSQL + Auth + Real-time)
- **UI/UX**: Framer Motion + Lucide Icons
- **Search**: PostgreSQL Full-Text Search with GIN indexes
- **Styling**: Tailwind CSS with custom animations

## 📋 Prerequisites

Before setting up the project, ensure you have:

1. **Supabase Account**: [Create account](https://supabase.com)
2. **Node.js**: Version 18 or higher
3. **Git**: For version control

## 🚀 Quick Start

### 1. Database Setup

1. **Connect to Supabase**: Click the "Connect to Supabase" button in the top right
2. **Run Migration**: The database schema will be automatically created
3. **Sample Data**: Sample articles will be inserted for testing

### 2. Environment Setup

1. Copy `.env.example` to `.env`
2. Add your Supabase credentials:
   ```env
   VITE_SUPABASE_URL=your_supabase_project_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

### 3. Start Development

```bash
npm run dev
```

## 📖 Usage

### For Employees (Chat Interface)
1. Open the application
2. Type questions about company documentation
3. Get instant AI-powered responses with relevant articles
4. Click on article cards for detailed information

### For Admins (Admin Panel)
1. Click the "Admin" button in the navigation
2. Add new articles with the "New Article" button
3. Edit existing articles by clicking the edit icon
4. Organize content with categories and keywords

## 🏗 Database Schema

### Articles Table
```sql
- id (uuid, primary key)
- title (text, not null)
- content (text, not null)
- keywords (text array)
- category (text)
- author (text)
- created_at (timestamp)
- updated_at (timestamp)
```

### Indexes
- GIN index on keywords for fast array searches
- Full-text search index on title and content
- Category and timestamp indexes for filtering

## 🔍 Search Algorithm

The chatbot uses a sophisticated multi-layered search approach:

1. **Keyword Extraction**: Removes stop words and extracts meaningful terms
2. **Primary Search**: Matches articles by keyword arrays
3. **Fallback Search**: Uses PostgreSQL full-text search if no keyword matches
4. **Relevance Ranking**: Orders results by creation date and relevance
5. **Smart Summarization**: Generates contextual summaries based on query type

## 🎨 UI/UX Features

- **Glass Morphism**: Modern translucent design elements
- **Smooth Animations**: Framer Motion powered transitions
- **Responsive Design**: Works on desktop and mobile
- **Dark Theme**: Professional dark mode interface
- **Syntax Highlighting**: Code blocks with proper formatting
- **Loading States**: Elegant loading animations and indicators

## 🔒 Security

- **Row Level Security (RLS)**: Database-level access control
- **Public Read Access**: Articles readable by all internal users
- **Admin Controls**: Authenticated users can manage content
- **Input Validation**: Proper sanitization of user inputs

## 🚀 Deployment

The application is ready for deployment on platforms like:
- **Netlify**: Static site deployment
- **Vercel**: Full-stack deployment
- **Docker**: Containerized deployment

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 Sample Articles Included

The system comes with sample articles covering:
- React Component Best Practices
- API Authentication with JWT
- Database Migration Best Practices
- Docker Deployment Guide

## 🆘 Support

For technical support or questions:
1. Check the admin panel for existing documentation
2. Contact your system administrator
3. Review the database migration files for schema details

## 📄 License

This project is for internal company use. All rights reserved.

---

**Built with ❤️ for efficient internal documentation management**