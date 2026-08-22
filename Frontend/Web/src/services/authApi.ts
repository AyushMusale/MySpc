import { apiClient } from './apiClient'
import type { ApiResponse, LoginFormData, SignupFormData } from '../types/auth'

export async function sendOtp(email: string) {
  const { data } = await apiClient.post<ApiResponse>('/auth/send-otp', { email })
  return data
}

export async function verifyOtp(email: string, otp: string) {
  const { data } = await apiClient.post<ApiResponse>('/auth/verify-otp', { email, otp })
  return data
}

export async function signup(formData: SignupFormData) {
  const { data } = await apiClient.post<ApiResponse>('/auth/signup', {
    email: formData.email,
    displayName: formData.displayName,
    username: formData.username,
    otp: formData.otp,
  })
  return data
}

export async function login(formData: LoginFormData) {
  const { data } = await apiClient.post<ApiResponse>('/auth/verify-otp', {
    email: formData.email,
    otp: formData.otp,
  })
  return data
}
