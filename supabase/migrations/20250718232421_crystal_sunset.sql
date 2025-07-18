/*
  # Create articles table for documentation chatbot

  1. New Tables
    - `articles`
      - `id` (uuid, primary key)
      - `title` (text, not null)
      - `content` (text, not null) 
      - `keywords` (text array for search)
      - `category` (text with default)
      - `author` (text with default)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `articles` table
    - Add policy for public read access (internal use)
    - Add policy for authenticated users to manage articles

  3. Indexes
    - GIN index on keywords for fast array searches
    - Full-text search index on title and content
    - Index on category for filtering

  4. Sample Data
    - Insert sample articles for testing
*/

-- Create articles table
CREATE TABLE IF NOT EXISTS articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  content text NOT NULL,
  keywords text[] DEFAULT '{}',
  category text DEFAULT 'General',
  author text DEFAULT 'Admin',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Anyone can read articles"
  ON articles
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage articles"
  ON articles
  FOR ALL
  TO authenticated
  USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_articles_keywords ON articles USING GIN (keywords);
CREATE INDEX IF NOT EXISTS idx_articles_category ON articles (category);
CREATE INDEX IF NOT EXISTS idx_articles_created_at ON articles (created_at DESC);

-- Create full-text search index
CREATE INDEX IF NOT EXISTS idx_articles_search ON articles USING GIN (to_tsvector('english', title || ' ' || content));

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_articles_updated_at
  BEFORE UPDATE ON articles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert sample articles
INSERT INTO articles (title, content, keywords, category, author) VALUES
(
  'React Component Best Practices',
  '# React Component Best Practices

## 1. Component Structure
Always structure your React components with clear separation of concerns:

```jsx
import React, { useState, useEffect } from ''react'';

const MyComponent = ({ prop1, prop2 }) => {
  const [state, setState] = useState(initialValue);
  
  useEffect(() => {
    // Side effects here
  }, [dependencies]);
  
  return (
    <div>
      {/* JSX here */}
    </div>
  );
};

export default MyComponent;
```

## 2. Props Validation
Use TypeScript or PropTypes for type checking:

```tsx
interface Props {
  title: string;
  count: number;
  onUpdate: (value: string) => void;
}

const Component: React.FC<Props> = ({ title, count, onUpdate }) => {
  // Component logic
};
```

## 3. State Management
- Use useState for local component state
- Use useReducer for complex state logic
- Consider Context API for global state
- Use external libraries like Redux for large applications

## 4. Performance Optimization
- Use React.memo for preventing unnecessary re-renders
- Use useMemo and useCallback for expensive calculations
- Implement code splitting with React.lazy

## 5. Testing
Write comprehensive tests using Jest and React Testing Library:

```jsx
import { render, screen } from ''@testing-library/react'';
import MyComponent from ''./MyComponent'';

test(''renders component correctly'', () => {
  render(<MyComponent title="Test" />);
  expect(screen.getByText(''Test'')).toBeInTheDocument();
});
```',
  ARRAY['react', 'components', 'best-practices', 'javascript', 'frontend', 'jsx', 'hooks'],
  'Frontend',
  'John Doe'
),
(
  'API Authentication with JWT',
  '# API Authentication with JWT

## Overview
JSON Web Tokens (JWT) provide a secure way to authenticate API requests. This guide covers implementation best practices.

## 1. JWT Structure
A JWT consists of three parts:
- **Header**: Contains token type and signing algorithm
- **Payload**: Contains claims (user data)
- **Signature**: Verifies token integrity

## 2. Implementation Steps

### Backend Setup
```javascript
const jwt = require(''jsonwebtoken'');

// Generate token
const generateToken = (user) => {
  return jwt.sign(
    { userId: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: ''24h'' }
  );
};

// Verify token middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers[''authorization''];
  const token = authHeader && authHeader.split('' '')[1];
  
  if (!token) {
    return res.sendStatus(401);
  }
  
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};
```

### Frontend Integration
```javascript
// Store token
localStorage.setItem(''token'', token);

// Add to requests
const apiCall = async () => {
  const token = localStorage.getItem(''token'');
  const response = await fetch(''/api/protected'', {
    headers: {
      ''Authorization'': `Bearer ${token}`,
      ''Content-Type'': ''application/json''
    }
  });
};
```

## 3. Security Best Practices
- Use HTTPS in production
- Set appropriate expiration times
- Implement token refresh mechanism
- Store tokens securely (httpOnly cookies preferred)
- Validate all incoming tokens
- Use strong secret keys

## 4. Error Handling
Implement proper error responses:
- 401: Unauthorized (missing/invalid token)
- 403: Forbidden (valid token, insufficient permissions)
- 500: Server error

## 5. Testing
Test authentication flows thoroughly:
```javascript
describe(''Authentication'', () => {
  test(''should authenticate valid token'', async () => {
    const token = generateToken(mockUser);
    const response = await request(app)
      .get(''/api/protected'')
      .set(''Authorization'', `Bearer ${token}`);
    expect(response.status).toBe(200);
  });
});
```',
  ARRAY['jwt', 'authentication', 'api', 'security', 'backend', 'nodejs', 'express'],
  'Backend',
  'Jane Smith'
),
(
  'Database Migration Best Practices',
  '# Database Migration Best Practices

## 1. Migration Principles
Database migrations should be:
- **Reversible**: Always include rollback procedures
- **Atomic**: Each migration should be a single logical change
- **Tested**: Test migrations on staging before production
- **Documented**: Include clear descriptions and comments

## 2. Migration Structure
```sql
-- Migration: add_user_preferences_table
-- Description: Add user preferences table for storing user settings
-- Author: DevOps Team
-- Date: 2024-01-15

-- Forward migration
CREATE TABLE user_preferences (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  preference_key VARCHAR(100) NOT NULL,
  preference_value TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);
CREATE UNIQUE INDEX idx_user_preferences_unique ON user_preferences(user_id, preference_key);

-- Rollback migration (in separate file)
-- DROP INDEX idx_user_preferences_unique;
-- DROP INDEX idx_user_preferences_user_id;
-- DROP TABLE user_preferences;
```

## 3. Common Migration Types

### Adding Columns
```sql
-- Safe: Adding nullable column
ALTER TABLE users ADD COLUMN phone_number VARCHAR(20);

-- Risky: Adding non-nullable column (provide default)
ALTER TABLE users ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT ''active'';
```

### Modifying Columns
```sql
-- Safe: Increasing column size
ALTER TABLE users ALTER COLUMN email TYPE VARCHAR(320);

-- Risky: Decreasing column size (check data first)
-- ALTER TABLE users ALTER COLUMN username TYPE VARCHAR(50);
```

### Adding Indexes
```sql
-- Create index concurrently to avoid locks
CREATE INDEX CONCURRENTLY idx_users_email ON users(email);
```

## 4. Migration Tools
Popular migration tools:
- **Flyway**: Java-based, supports multiple databases
- **Liquibase**: XML/YAML based migrations
- **Alembic**: Python SQLAlchemy migrations
- **Knex.js**: JavaScript migrations
- **Rails Migrations**: Ruby on Rails built-in

## 5. Best Practices
1. **Version Control**: Store migrations in version control
2. **Naming Convention**: Use descriptive, timestamped names
3. **Backup**: Always backup before running migrations
4. **Monitoring**: Monitor migration performance
5. **Communication**: Coordinate with team on schema changes

## 6. Rollback Strategy
```sql
-- Always plan rollback procedures
-- Document dependencies and constraints
-- Test rollback procedures in staging
-- Keep rollback scripts ready for production
```

## 7. Performance Considerations
- Run heavy migrations during low-traffic periods
- Use batched operations for large data changes
- Monitor lock duration and blocking queries
- Consider online schema change tools for large tables',
  ARRAY['database', 'migration', 'sql', 'devops', 'postgresql', 'mysql', 'schema'],
  'Database',
  'Mike Johnson'
),
(
  'Docker Deployment Guide',
  '# Docker Deployment Guide

## 1. Dockerfile Best Practices

### Multi-stage Build
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage
FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Optimization Tips
```dockerfile
# Use specific versions
FROM node:18.17.0-alpine

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Copy package files first (better caching)
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY --chown=nextjs:nodejs . .
USER nextjs
```

## 2. Docker Compose Setup
```yaml
version: ''3.8''

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/myapp
    depends_on:
      - db
      - redis
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    restart: unless-stopped

volumes:
  postgres_data:
```

## 3. Production Deployment

### Environment Variables
```bash
# .env.production
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
JWT_SECRET=your-secret-key
```

### Health Checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

### Resource Limits
```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: ''0.5''
          memory: 512M
        reservations:
          cpus: ''0.25''
          memory: 256M
```

## 4. Security Considerations
- Use non-root users in containers
- Scan images for vulnerabilities
- Keep base images updated
- Use secrets management for sensitive data
- Implement proper network segmentation

## 5. Monitoring and Logging
```yaml
services:
  app:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 6. CI/CD Integration
```yaml
# GitHub Actions example
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build and push Docker image
        run: |
          docker build -t myapp:latest .
          docker push myregistry/myapp:latest
      - name: Deploy to production
        run: |
          docker-compose -f docker-compose.prod.yml up -d
```',
  ARRAY['docker', 'deployment', 'devops', 'containers', 'production', 'ci-cd'],
  'DevOps',
  'Sarah Wilson'
);