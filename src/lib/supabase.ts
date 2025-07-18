import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

export interface Article {
  id: string
  title: string
  content: string
  keywords: string[]
  category: string
  author: string
  created_at: string
  updated_at: string
}

export interface ChatMessage {
  id: string
  content: string
  isBot: boolean
  timestamp: Date
  articles?: Article[]
}

// Search articles with keyword matching and full-text search
export async function searchArticles(query: string): Promise<Article[]> {
  const keywords = extractKeywords(query)
  
  // First try keyword-based search
  let { data: keywordResults } = await supabase
    .from('articles')
    .select('*')
    .overlaps('keywords', keywords)
    .order('created_at', { ascending: false })
    .limit(5)

  // If no keyword results, try full-text search
  if (!keywordResults || keywordResults.length === 0) {
    const { data: textResults } = await supabase
      .from('articles')
      .select('*')
      .textSearch('title', query)
      .order('created_at', { ascending: false })
      .limit(5)
    
    keywordResults = textResults || []
  }

  return keywordResults || []
}

// Extract keywords from user query
function extractKeywords(query: string): string[] {
  const stopWords = ['the', 'is', 'at', 'which', 'on', 'how', 'to', 'what', 'where', 'when', 'why', 'and', 'or', 'but', 'in', 'with', 'for']
  return query
    .toLowerCase()
    .split(/\s+/)
    .filter(word => word.length > 2 && !stopWords.includes(word))
    .slice(0, 5) // Limit to 5 keywords
}

// Generate AI-like summary of articles
export function generateSummary(articles: Article[], query: string): string {
  if (articles.length === 0) {
    return "I couldn't find any relevant articles for your query. Try using different keywords or check with an admin to ensure the documentation is available."
  }

  const relevantContent = articles
    .slice(0, 3) // Use top 3 articles
    .map(article => `**${article.title}** (${article.category}): ${article.content.substring(0, 200)}...`)
    .join('\n\n')

  return `Based on your query about "${query}", I found ${articles.length} relevant article${articles.length > 1 ? 's' : ''}:\n\n${relevantContent}\n\n**Summary**: ${generateContextualSummary(articles, query)}`
}

function generateContextualSummary(articles: Article[], query: string): string {
  const categories = [...new Set(articles.map(a => a.category))]
  const mainCategory = categories[0]
  
  if (query.toLowerCase().includes('how')) {
    return `Here are the step-by-step instructions from our ${mainCategory} documentation. Follow the procedures outlined in these articles for best results.`
  } else if (query.toLowerCase().includes('what')) {
    return `These articles explain the concepts and definitions related to ${mainCategory}. Review the documentation for comprehensive understanding.`
  } else if (query.toLowerCase().includes('error') || query.toLowerCase().includes('issue')) {
    return `These articles contain troubleshooting information and solutions for common issues in ${mainCategory}. Check the error handling sections.`
  } else {
    return `The documentation covers various aspects of ${mainCategory}. These articles should provide the information you're looking for.`
  }
}