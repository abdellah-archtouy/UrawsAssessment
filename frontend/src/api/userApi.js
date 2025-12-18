import api from './axios'

export const userApi = {
  getAll: async () => {
    const { data } = await api.get('/users')
    return data.data
  },

  getById: async (id) => {
    const { data } = await api.get(`/users/${id}`)
    return data.data
  },

  create: async (userData) => {
    const { data } = await api.post('/users', userData)
    return data.data
  },

  update: async ({ id, ...userData }) => {
    const { data } = await api.put(`/users/${id}`, userData)
    return data.data
  },

  delete: async (id) => {
    const { data } = await api.delete(`/users/${id}`)
    return data
  },
}
