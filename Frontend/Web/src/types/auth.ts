export interface Profile {
  userId: string
  username: string
  displayName: string
  avatarUrl: string | null
}

export interface SignupFormData {
  displayName: string
  username: string
  email: string
  otp: string
  otpVerified: boolean
}

export interface LoginFormData {
  email: string
  otp: string
}

export interface AuthState {
  form: SignupFormData
  otpSent: boolean
  loginForm: LoginFormData
  loginOtpSent: boolean
  loading: boolean
  error: string | null
  profile: Profile | null
  isAuthenticated: boolean
}

export interface ApiResponse {
  success: boolean
  message?: string
  profile?: Profile
  email?: string
}

export interface verifyOtpResponse{
  success: boolean
  message: string
}