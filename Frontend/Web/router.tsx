import { createBrowserRouter, Navigate } from 'react-router-dom'
import AuthLayout from './layout'
import { LoginPage } from './src/pages/LoginPage'
import { SignupPage } from './src/pages/SignupPage'

export const router = createBrowserRouter([
  {
    element: <AuthLayout />,
    children: [
      { index: true, element: <Navigate to="/signup" replace /> },
      { path: 'signup', element: <SignupPage /> },
      { path: 'login', element: <LoginPage /> },
    ],
  },
])
