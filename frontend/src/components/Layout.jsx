import { Link } from 'react-router-dom'

function Layout({ children }) {
  return (
    <>
      <header>
        <div className="container">
          <Link to="/" style={{ textDecoration: 'none', color: 'inherit' }}>
            <h1>👤 User Management System</h1>
            <p>YourAWS Technical Assessment - Full Stack Application</p>
          </Link>
        </div>
      </header>
      <main className="container">
        {children}
      </main>
    </>
  )
}

export default Layout
