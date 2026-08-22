import axios from 'axios'
import type { ApiResponse } from '../types/auth'

const API_BASE = import.meta.env.VITE_API_BASE ?? 'http://localhost:3069/api/myspc'

export const apiClient = axios.create({
  baseURL: API_BASE,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
    'x-client-type': 'web',
  },
})

apiClient.interceptors.response.use(
  (response) => {
    const data = response.data as ApiResponse

    if (!data.success) {
      return Promise.reject(new Error(data.message ?? 'Something went wrong'))
    }

    return response
  },
  (error) => {
    const message =
      error.response?.data?.message ??
      error.message ??
      'Something went wrong'
    return Promise.reject(new Error(message))
  },
)
