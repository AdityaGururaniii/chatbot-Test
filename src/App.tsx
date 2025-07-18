import React, { useState } from 'react'
import Navigation from './components/Navigation'
import ChatInterface from './components/ChatInterface'
import AdminPanel from './components/AdminPanel'

function App() {
  const [activeView, setActiveView] = useState<'chat' | 'admin'>('chat')

  return (
    <div className="h-screen flex flex-col bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <Navigation activeView={activeView} onViewChange={setActiveView} />
      
      <div className="flex-1 overflow-hidden">
        {activeView === 'chat' ? <ChatInterface /> : <AdminPanel />}
      </div>
    </div>
  )
}

export default App