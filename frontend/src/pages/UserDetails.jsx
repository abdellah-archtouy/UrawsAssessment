import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { userApi } from '../api/userApi'
import EditUserModal from '../components/EditUserModal'

function UserDetails() {
  const { id } = useParams()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [isEditModalOpen, setIsEditModalOpen] = useState(false)
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false)

  const { data: user, isLoading, error } = useQuery({
    queryKey: ['user', id],
    queryFn: () => userApi.getById(id),
  })

  const updateMutation = useMutation({
    mutationFn: userApi.update,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['user', id] })
      queryClient.invalidateQueries({ queryKey: ['users'] })
      setIsEditModalOpen(false)
    },
  })

  const deleteMutation = useMutation({
    mutationFn: userApi.delete,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
      navigate('/')
    },
  })

  const handleDelete = () => {
    deleteMutation.mutate(id)
  }

  if (isLoading) {
    return <div className="loading">Loading user details</div>
  }

  if (error) {
    return (
      <div className="error-state">
        <h2>Error Loading User</h2>
        <p>{error.message}</p>
        <button className="btn btn-secondary" onClick={() => navigate('/')}>
          ← Back to Users
        </button>
      </div>
    )
  }

  return (
    <div className="user-details">
      <button
        className="btn btn-secondary"
        onClick={() => navigate('/')}
        style={{ marginBottom: '1.5rem' }}
      >
        ← Back to Users
      </button>

      <div className="card">
        <h2 style={{ marginBottom: '1.5rem', color: '#2d3748' }}>User Details</h2>

        <div className="info-row">
          <div className="info-label">ID:</div>
          <div className="info-value">{user.id}</div>
        </div>

        <div className="info-row">
          <div className="info-label">First Name:</div>
          <div className="info-value">{user.firstname}</div>
        </div>

        <div className="info-row">
          <div className="info-label">Last Name:</div>
          <div className="info-value">{user.lastname}</div>
        </div>

        <div className="info-row">
          <div className="info-label">Email:</div>
          <div className="info-value">{user.email}</div>
        </div>

        <div className="info-row">
          <div className="info-label">Created:</div>
          <div className="info-value">
            {new Date(user.createdAt).toLocaleString()}
          </div>
        </div>

        <div className="info-row">
          <div className="info-label">Updated:</div>
          <div className="info-value">
            {new Date(user.updatedAt).toLocaleString()}
          </div>
        </div>

        <div className="actions">
          <button
            className="btn btn-primary"
            onClick={() => setIsEditModalOpen(true)}
            disabled={updateMutation.isPending}
          >
            Edit User
          </button>
          <button
            className="btn btn-danger"
            onClick={() => setShowDeleteConfirm(true)}
            disabled={deleteMutation.isPending}
          >
            Delete User
          </button>
        </div>
      </div>

      {isEditModalOpen && (
        <EditUserModal
          user={user}
          onClose={() => setIsEditModalOpen(false)}
          onSubmit={(userData) => updateMutation.mutate({ id, ...userData })}
          isLoading={updateMutation.isPending}
          error={updateMutation.error}
        />
      )}

      {showDeleteConfirm && (
        <div className="modal-overlay" onClick={() => setShowDeleteConfirm(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h2>Confirm Delete</h2>
            <p>Are you sure you want to delete this user? This action cannot be undone.</p>
            <p style={{ marginTop: '1rem', color: '#718096' }}>
              <strong>{user.firstname} {user.lastname}</strong> ({user.email})
            </p>
            {deleteMutation.error && (
              <p className="error-message">{deleteMutation.error.message}</p>
            )}
            <div className="modal-actions">
              <button
                className="btn btn-secondary"
                onClick={() => setShowDeleteConfirm(false)}
                disabled={deleteMutation.isPending}
              >
                Cancel
              </button>
              <button
                className="btn btn-danger"
                onClick={handleDelete}
                disabled={deleteMutation.isPending}
              >
                {deleteMutation.isPending ? 'Deleting...' : 'Delete'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default UserDetails
