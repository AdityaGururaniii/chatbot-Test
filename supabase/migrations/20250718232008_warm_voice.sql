/*
  # Create articles table for documentation chatbot

  1. New Tables
    - `articles`
      - `id` (uuid, primary key)
      - `title` (text, not null) - Article title
      - `content` (text, not null) - Article content in markdown
      - `keywords` (text array) - Keywords for search
      - `category` (text, default 'General') - Article category
      - `author` (text, default 'Admin') - Article author
      - `created_at` (timestamptz, default now())
      - `updated_at` (timestamptz, default now())

  2. Security
    - Enable RLS on `articles` table
    - Add policy for public read access (for chatbot)
    - Add policy for authenticated admin write access

  3. Indexes
    - Add indexes for search optimization on title, content, and keywords
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

CREATE POLICY "Authenticated users can insert articles"
  ON articles
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update articles"
  ON articles
  FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can delete articles"
  ON articles
  FOR DELETE
  TO authenticated
  USING (true);

-- Create indexes for better search performance
CREATE INDEX IF NOT EXISTS articles_title_idx ON articles USING gin(to_tsvector('english', title));
CREATE INDEX IF NOT EXISTS articles_content_idx ON articles USING gin(to_tsvector('english', content));
CREATE INDEX IF NOT EXISTS articles_keywords_idx ON articles USING gin(keywords);
CREATE INDEX IF NOT EXISTS articles_category_idx ON articles (category);
CREATE INDEX IF NOT EXISTS articles_created_at_idx ON articles (created_at DESC);

-- Insert sample articles
INSERT INTO articles (title, content, keywords, category, author) VALUES
(
  'Getting Started with React',
  '# Getting Started with React

React is a JavaScript library for building user interfaces. Here''s how to get started:

## Installation

```bash
npm create react-app my-app
cd my-app
npm start
```

## Basic Component

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}!</h1>;
}
```

## Key Concepts

- **Components**: Building blocks of React applications
- **JSX**: Syntax extension for JavaScript
- **Props**: Data passed to components
- **State**: Component''s internal data

React makes it easy to create interactive UIs with reusable components.',
  ARRAY['react', 'javascript', 'frontend', 'components', 'jsx'],
  'Frontend',
  'Tech Team'
),
(
  'API Authentication Guide',
  '# API Authentication Guide

This guide covers how to implement authentication in our APIs.

## JWT Tokens

We use JSON Web Tokens for authentication:

```javascript
const token = jwt.sign(
  { userId: user.id, email: user.email },
  process.env.JWT_SECRET,
  { expiresIn: ''24h'' }
);
```

## Middleware

```javascript
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

## Best Practices

- Always use HTTPS in production
- Set appropriate token expiration times
- Implement refresh token mechanism
- Store secrets securely',
  ARRAY['api', 'authentication', 'jwt', 'security', 'backend'],
  'Backend',
  'Security Team'
),
(
  'Database Migration Guide',
  '# Database Migration Guide

Learn how to manage database schema changes safely.

## Creating Migrations

```sql
-- Create new table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## Running Migrations

```bash
# Run pending migrations
npm run migrate

# Rollback last migration
npm run migrate:rollback
```

## Best Practices

1. **Always backup** before running migrations in production
2. **Test migrations** on staging environment first
3. **Make migrations reversible** when possible
4. **Use transactions** for complex migrations

## Common Patterns

### Adding Columns
```sql
ALTER TABLE users ADD COLUMN phone VARCHAR(20);
```

### Creating Indexes
```sql
CREATE INDEX idx_users_email ON users(email);
```

### Data Migrations
```sql
UPDATE users SET status = ''active'' WHERE created_at > NOW() - INTERVAL ''30 days'';
```',
  ARRAY['database', 'migration', 'sql', 'schema', 'deployment'],
  'Database',
  'DevOps Team'
),
(
  'Deployment Process',
  '# Deployment Process

Our standardized deployment process ensures reliable releases.

## Environments

- **Development**: Local development
- **Staging**: Pre-production testing
- **Production**: Live environment

## CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: ''18''
      - run: npm ci
      - run: npm test
      - run: npm run build
      - name: Deploy to production
        run: npm run deploy
```

## Deployment Checklist

- [ ] All tests passing
- [ ] Code review completed
- [ ] Database migrations ready
- [ ] Environment variables updated
- [ ] Monitoring alerts configured

## Rollback Procedure

If issues are detected:

1. Stop deployment immediately
2. Revert to previous version
3. Investigate and fix issues
4. Re-deploy when ready',
  ARRAY['deployment', 'cicd', 'devops', 'production', 'rollback'],
  'DevOps',
  'DevOps Team'
);