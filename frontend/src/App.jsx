import { Routes, Route } from 'react-router-dom'
import Layout from './components/Layout'
import UserList from './pages/UserList'
import UserDetails from './pages/UserDetails'
import NotFound from './pages/NotFound'

function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<UserList />} />
        <Route path="/users/:id" element={<UserDetails />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </Layout>
  )
}

export default App
