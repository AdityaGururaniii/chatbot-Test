import React, { useState, useEffect } from 'react'
import { Plus, Edit, Trash2, Save, X, FileText, Tag, User, Calendar } from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import { supabase, type Article } from '../lib/supabase'

export default function AdminPanel() {
  const [articles, setArticles] = useState<Article[]>([])
  const [isEditing, setIsEditing] = useState(false)
  const [editingArticle, setEditingArticle] = useState<Partial<Article> | null>(null)
  const [loading, setLoading] = useState(true)

  const categories = ['Frontend', 'Backend', 'DevOps', 'Database', 'API', 'Security', 'Testing', 'General']

  useEffect(() => {
    fetchArticles()
  }, [])

  const fetchArticles = async () => {
    try {
      const { data, error } = await supabase
        .from('articles')
        .select('*')
        .order('created_at', { ascending: false })

      if (error) throw error
      setArticles(data || [])
    } catch (error) {
      console.error('Error fetching articles:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleSave = async () => {
    if (!editingArticle?.title || !editingArticle?.content) return

    try {
      const articleData = {
        title: editingArticle.title,
        content: editingArticle.content,
        keywords: editingArticle.keywords || [],
        category: editingArticle.category || 'General',
        author: editingArticle.author || 'Admin'
      }

      if (editingArticle.id) {
        // Update existing article
        const { error } = await supabase
          .from('articles')
          .update(articleData)
          .eq('id', editingArticle.id)

        if (error) throw error
      } else {
        // Create new article
        const { error } = await supabase
          .from('articles')
          .insert([articleData])

        if (error) throw error
      }

      setIsEditing(false)
      setEditingArticle(null)
      fetchArticles()
    } catch (error) {
      console.error('Error saving article:', error)
    }
  }

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this article?')) return

    try {
      const { error } = await supabase
        .from('articles')
        .delete()
        .eq('id', id)

      if (error) throw error
      fetchArticles()
    } catch (error) {
      console.error('Error deleting article:', error)
    }
  }

  const startEditing = (article?: Article) => {
    setEditingArticle(article || {
      title: '',
      content: '',
      keywords: [],
      category: 'General',
      author: 'Admin'
    })
    setIsEditing(true)
  }

  const handleKeywordsChange = (value: string) => {
    const keywords = value.split(',').map(k => k.trim()).filter(k => k.length > 0)
    setEditingArticle(prev => prev ? { ...prev, keywords } : null)
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-full">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  return (
    <div className="h-full bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 p-6">
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-3xl font-bold text-white mb-2">Documentation Admin</h1>
            <p className="text-gray-300">Manage your company's knowledge base</p>
          </div>
          <button
            onClick={() => startEditing()}
            className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white px-6 py-3 rounded-xl flex items-center space-x-2 transition-all duration-200"
          >
            <Plus className="w-5 h-5" />
            <span>New Article</span>
          </button>
        </div>

        {/* Articles Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <AnimatePresence>
            {articles.map((article) => (
              <motion.div
                key={article.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -20 }}
                className="bg-white/10 backdrop-blur-md border border-white/20 rounded-xl p-6 hover:bg-white/15 transition-all duration-200"
              >
                <div className="flex items-start justify-between mb-4">
                  <div className="flex items-center space-x-2">
                    <FileText className="w-5 h-5 text-blue-400" />
                    <span className="text-sm bg-blue-500/20 text-blue-300 px-2 py-1 rounded">
                      {article.category}
                    </span>
                  </div>
                  <div className="flex space-x-2">
                    <button
                      onClick={() => startEditing(article)}
                      className="text-gray-400 hover:text-blue-400 transition-colors"
                    >
                      <Edit className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => handleDelete(article.id)}
                      className="text-gray-400 hover:text-red-400 transition-colors"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>

                <h3 className="text-lg font-semibold text-white mb-2 line-clamp-2">
                  {article.title}
                </h3>

                <p className="text-gray-300 text-sm mb-4 line-clamp-3">
                  {article.content.substring(0, 150)}...
                </p>

                <div className="space-y-2">
                  <div className="flex items-center space-x-2 text-xs text-gray-400">
                    <User className="w-3 h-3" />
                    <span>{article.author}</span>
                  </div>
                  <div className="flex items-center space-x-2 text-xs text-gray-400">
                    <Calendar className="w-3 h-3" />
                    <span>{new Date(article.created_at).toLocaleDateString()}</span>
                  </div>
                  <div className="flex items-center space-x-2 text-xs text-gray-400">
                    <Tag className="w-3 h-3" />
                    <span>{article.keywords.slice(0, 3).join(', ')}</span>
                  </div>
                </div>
              </motion.div>
            ))}
          </AnimatePresence>
        </div>

        {/* Edit Modal */}
        <AnimatePresence>
          {isEditing && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50"
            >
              <motion.div
                initial={{ scale: 0.9, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                exit={{ scale: 0.9, opacity: 0 }}
                className="bg-slate-800 rounded-xl p-6 w-full max-w-4xl max-h-[90vh] overflow-y-auto"
              >
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-2xl font-bold text-white">
                    {editingArticle?.id ? 'Edit Article' : 'New Article'}
                  </h2>
                  <button
                    onClick={() => setIsEditing(false)}
                    className="text-gray-400 hover:text-white transition-colors"
                  >
                    <X className="w-6 h-6" />
                  </button>
                </div>

                <div className="space-y-6">
                  {/* Title */}
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Title
                    </label>
                    <input
                      type="text"
                      value={editingArticle?.title || ''}
                      onChange={(e) => setEditingArticle(prev => prev ? { ...prev, title: e.target.value } : null)}
                      className="w-full bg-slate-700 border border-slate-600 rounded-lg px-4 py-3 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter article title..."
                    />
                  </div>

                  {/* Category and Author */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-300 mb-2">
                        Category
                      </label>
                      <select
                        value={editingArticle?.category || 'General'}
                        onChange={(e) => setEditingArticle(prev => prev ? { ...prev, category: e.target.value } : null)}
                        className="w-full bg-slate-700 border border-slate-600 rounded-lg px-4 py-3 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      >
                        {categories.map(cat => (
                          <option key={cat} value={cat}>{cat}</option>
                        ))}
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-300 mb-2">
                        Author
                      </label>
                      <input
                        type="text"
                        value={editingArticle?.author || ''}
                        onChange={(e) => setEditingArticle(prev => prev ? { ...prev, author: e.target.value } : null)}
                        className="w-full bg-slate-700 border border-slate-600 rounded-lg px-4 py-3 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Author name..."
                      />
                    </div>
                  </div>

                  {/* Keywords */}
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Keywords (comma-separated)
                    </label>
                    <input
                      type="text"
                      value={editingArticle?.keywords?.join(', ') || ''}
                      onChange={(e) => handleKeywordsChange(e.target.value)}
                      className="w-full bg-slate-700 border border-slate-600 rounded-lg px-4 py-3 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="react, javascript, frontend, components..."
                    />
                  </div>

                  {/* Content */}
                  <div>
                    <label className="block text-sm font-medium text-gray-300 mb-2">
                      Content (Markdown supported)
                    </label>
                    <textarea
                      value={editingArticle?.content || ''}
                      onChange={(e) => setEditingArticle(prev => prev ? { ...prev, content: e.target.value } : null)}
                      className="w-full bg-slate-700 border border-slate-600 rounded-lg px-4 py-3 text-white focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono"
                      rows={15}
                      placeholder="Write your article content here... Markdown is supported!"
                    />
                  </div>

                  {/* Actions */}
                  <div className="flex justify-end space-x-4">
                    <button
                      onClick={() => setIsEditing(false)}
                      className="px-6 py-3 border border-gray-600 text-gray-300 rounded-lg hover:bg-gray-700 transition-colors"
                    >
                      Cancel
                    </button>
                    <button
                      onClick={handleSave}
                      className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white px-6 py-3 rounded-lg flex items-center space-x-2 transition-all duration-200"
                    >
                      <Save className="w-5 h-5" />
                      <span>Save Article</span>
                    </button>
                  </div>
                </div>
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  )
}