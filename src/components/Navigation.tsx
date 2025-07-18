import React from 'react'
import { MessageCircle, Settings, Bot } from 'lucide-react'
import { motion } from 'framer-motion'

interface NavigationProps {
  activeView: 'chat' | 'admin'
  onViewChange: (view: 'chat' | 'admin') => void
}

export default function Navigation({ activeView, onViewChange }: NavigationProps) {
  return (
    <nav className="bg-white/10 backdrop-blur-md border-b border-white/20 px-6 py-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center">
            <Bot className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-xl font-bold text-white">DocBot</h1>
            <p className="text-sm text-gray-300">Internal Documentation Assistant</p>
          </div>
        </div>

        <div className="flex items-center space-x-2">
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => onViewChange('chat')}
            className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all duration-200 ${
              activeView === 'chat'
                ? 'bg-blue-600 text-white'
                : 'text-gray-300 hover:text-white hover:bg-white/10'
            }`}
          >
            <MessageCircle className="w-5 h-5" />
            <span>Chat</span>
          </motion.button>

          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => onViewChange('admin')}
            className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all duration-200 ${
              activeView === 'admin'
                ? 'bg-purple-600 text-white'
                : 'text-gray-300 hover:text-white hover:bg-white/10'
            }`}
          >
            <Settings className="w-5 h-5" />
            <span>Admin</span>
          </motion.button>
        </div>
      </div>
    </nav>
  )
}