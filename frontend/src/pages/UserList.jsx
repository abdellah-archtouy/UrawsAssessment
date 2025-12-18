import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { userApi } from '../api/userApi'
import CreateUserModal from '../components/CreateUserModal'

function UserList() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [isModalOpen, setIsModalOpen] = useState(false)

  const { data: users, isLoading, error } = useQuery({
    queryKey: ['users'],
    queryFn: userApi.getAll,
  })

  const createMutation = useMutation({
    mutationFn: userApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
      setIsModalOpen(false)
    },
  })

  const handleUserClick = (userId) => {
    navigate(`/users/${userId}`)
  }

  if (isLoading) {
    return <div className="loading">Loading users</div>
  }

  if (error) {
    return (
      <div className="error-state">
        <h2>Error Loading Users</h2>
        <p>{error.message}</p>
      </div>
    )
  }

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
        <h2 style={{ fontSize: '1.5rem', color: '#2d3748' }}>
          All Users ({users?.length || 0})
        </h2>
        <button
          className="btn btn-primary"
          onClick={() => setIsModalOpen(true)}
        >
          ➕ Create New User
        </button>
      </div>

      {users && users.length === 0 ? (
        <div className="card" style={{ textAlign: 'center', padding: '3rem' }}>
          <p style={{ fontSize: '1.2rem', color: '#718096' }}>
            No users found. Create your first user!
          </p>
        </div>
      ) : (
        <div className="user-grid">
          {users?.map((user) => (
            <div
              key={user.id}
              className="card user-card"
              onClick={() => handleUserClick(user.id)}
            >
              <h3>{user.firstname} {user.lastname}</h3>
              <p>{user.email}</p>
              <p style={{ fontSize: '12px', marginTop: '0.5rem', color: '#a0aec0' }}>
                ID: {user.id}
              </p>
            </div>
          ))}
        </div>
      )}

      {isModalOpen && (
        <CreateUserModal
          onClose={() => setIsModalOpen(false)}
          onSubmit={(userData) => createMutation.mutate(userData)}
          isLoading={createMutation.isPending}
          error={createMutation.error}
        />
      )}
    </div>
  )
}

export default UserList
