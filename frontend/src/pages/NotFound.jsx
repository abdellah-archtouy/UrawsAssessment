import { useNavigate } from 'react-router-dom'

function NotFound() {
  const navigate = useNavigate()

  return (
    <div className="card" style={{ textAlign: 'center', padding: '3rem', maxWidth: '500px', margin: '3rem auto' }}>
      <h1 style={{ fontSize: '4rem', marginBottom: '1rem' }}>404</h1>
      <h2 style={{ marginBottom: '1rem', color: '#2d3748' }}>Page Not Found</h2>
      <p style={{ marginBottom: '2rem', color: '#718096' }}>
        The page you're looking for doesn't exist.
      </p>
      <button className="btn btn-primary" onClick={() => navigate('/')}>
        Go to Home
      </button>
    </div>
  )
}

export default NotFound
