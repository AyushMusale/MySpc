import { Outlet, useLocation } from 'react-router-dom'
import { AuthHero } from './src/components/auth/AuthHero'

function BackgroundPattern() {
  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden" aria-hidden="true">
      <div className="absolute -left-32 -top-32 h-96 w-96 rounded-full bg-myspc-orange/8" />
      <div className="absolute -bottom-24 -right-24 h-[28rem] w-[28rem] rounded-full bg-myspc-orange/6" />
      <div className="absolute left-1/3 top-1/4 h-64 w-64 rounded-full bg-myspc-orange/5" />
    </div>
  )
}

export default function AuthLayout() {
  const { pathname } = useLocation()
  const heroVariant = pathname === '/login' ? 'login' : 'signup'

  return (
    <div className="relative min-h-screen bg-myspc-bg font-sans text-myspc-text">
      <BackgroundPattern />

      <div className="relative mx-auto grid min-h-screen max-w-7xl grid-cols-1 lg:grid-cols-2">
        <div className="hidden lg:block">
          <AuthHero variant={heroVariant} />
        </div>

        <div className="relative flex flex-col items-center justify-center px-4 py-10 sm:px-6 lg:px-10">
          <div
            className="pointer-events-none absolute bottom-0 left-0 top-0 hidden w-px bg-myspc-orange/20 lg:block"
            aria-hidden="true"
          />

          <div className="mb-8 w-full max-w-md px-2 lg:hidden">
            <AuthHero compact variant={heroVariant} />
          </div>
          <Outlet />
        </div>
      </div>
    </div>
  )
}
