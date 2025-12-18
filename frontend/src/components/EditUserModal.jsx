import { useState } from 'react'

function EditUserModal({ user, onClose, onSubmit, isLoading, error }) {
  const [formData, setFormData] = useState({
    firstname: user.firstname,
    lastname: user.lastname,
    email: user.email,
  })
  const [errors, setErrors] = useState({})

  const validate = () => {
    const newErrors = {}

    if (!formData.firstname.trim()) {
      newErrors.firstname = 'First name is required'
    } else if (formData.firstname.length < 2) {
      newErrors.firstname = 'First name must be at least 2 characters'
    }

    if (!formData.lastname.trim()) {
      newErrors.lastname = 'Last name is required'
    } else if (formData.lastname.length < 2) {
      newErrors.lastname = 'Last name must be at least 2 characters'
    }

    if (!formData.email.trim()) {
      newErrors.email = 'Email is required'
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      newErrors.email = 'Invalid email format'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    if (validate()) {
      onSubmit(formData)
    }
  }

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData((prev) => ({ ...prev, [name]: value }))
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: '' }))
    }
  }

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal" onClick={(e) => e.stopPropagation()}>
        <h2>Edit User</h2>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="firstname">First Name *</label>
            <input
              type="text"
              id="firstname"
              name="firstname"
              value={formData.firstname}
              onChange={handleChange}
              className={errors.firstname ? 'error' : ''}
              disabled={isLoading}
            />
            {errors.firstname && <p className="error-message">{errors.firstname}</p>}
          </div>

          <div className="form-group">
            <label htmlFor="lastname">Last Name *</label>
            <input
              type="text"
              id="lastname"
              name="lastname"
              value={formData.lastname}
              onChange={handleChange}
              className={errors.lastname ? 'error' : ''}
              disabled={isLoading}
            />
            {errors.lastname && <p className="error-message">{errors.lastname}</p>}
          </div>

          <div className="form-group">
            <label htmlFor="email">Email *</label>
            <input
              type="email"
              id="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              className={errors.email ? 'error' : ''}
              disabled={isLoading}
            />
            {errors.email && <p className="error-message">{errors.email}</p>}
          </div>

          {error && <p className="error-message">{error.message}</p>}

          <div className="modal-actions">
            <button
              type="button"
              className="btn btn-secondary"
              onClick={onClose}
              disabled={isLoading}
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn btn-primary"
              disabled={isLoading}
            >
              {isLoading ? 'Updating...' : 'Update User'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default EditUserModal
