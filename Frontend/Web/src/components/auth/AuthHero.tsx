import type { ReactNode } from 'react'
import { Logo } from '../ui/Logo'

function HeroIllustrations() {
  return (
    <div className="relative mt-10 h-56 w-full max-w-lg">
      <svg
        className="absolute right-8 top-0 h-16 w-16 text-myspc-orange"
        viewBox="0 0 64 64"
        fill="currentColor"
        aria-hidden="true"
      >
        <path d="M8 32C8 18.7452 18.7452 8 32 8C45.2548 8 56 18.7452 56 32C56 45.2548 45.2548 56 32 56C18.7452 56 8 45.2548 8 32Z" opacity="0.15" />
        <path d="M48 16L56 12V28L48 24V16Z" />
        <path
          d="M20 40C20 40 28 28 40 24"
          stroke="currentColor"
          strokeWidth="2"
          strokeDasharray="4 4"
          fill="none"
        />
      </svg>

      <div className="absolute bottom-4 left-0 flex items-end gap-4">
        <div className="relative">
          <div className="h-28 w-36 rounded-[2rem] rounded-bl-md bg-myspc-orange shadow-lg" />
          <div className="absolute -bottom-2 left-6 h-0 w-0 border-l-8 border-r-8 border-t-12 border-l-transparent border-r-transparent border-t-myspc-orange" />
          <div className="absolute left-6 top-1/2 flex -translate-y-1/2 gap-2">
            <span className="h-2 w-2 rounded-full bg-white/90" />
            <span className="h-2 w-2 rounded-full bg-white/90" />
            <span className="h-2 w-2 rounded-full bg-white/90" />
          </div>
        </div>

        <div className="relative mb-6">
          <div className="flex h-24 w-28 items-center justify-center rounded-[1.75rem] rounded-br-md bg-myspc-cream shadow-md">
            <svg width="40" height="40" viewBox="0 0 40 40" aria-hidden="true">
              <circle cx="14" cy="16" r="2.5" fill="#FF7A00" />
              <circle cx="26" cy="16" r="2.5" fill="#FF7A00" />
              <path
                d="M14 26C14 26 17 29 20 29C23 29 26 26 26 26"
                stroke="#FF7A00"
                strokeWidth="2.5"
                strokeLinecap="round"
                fill="none"
              />
            </svg>
          </div>
        </div>
      </div>

      <div className="absolute bottom-16 right-16 flex h-12 w-12 items-center justify-center rounded-full bg-myspc-cream shadow-md">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="#FF7A00" aria-hidden="true">
          <path d="M10 17.5C10 17.5 3.75 12.5 3.75 8.125C3.75 6.08938 5.46438 4.375 7.5 4.375C8.66094 4.375 9.69688 4.92813 10.3125 5.78125C10.9281 4.92813 11.9641 4.375 13.125 4.375C15.1606 4.375 16.875 6.08938 16.875 8.125C16.875 12.5 10.625 17.5 10 17.5Z" />
        </svg>
      </div>

      <span className="absolute left-32 top-20 h-2 w-2 rounded-full bg-myspc-orange/30" />
      <span className="absolute right-24 top-28 h-3 w-3 rounded-full bg-myspc-orange/20" />
    </div>
  )
}

function SlideDots({ activeIndex = 0 }: { activeIndex?: number }) {
  return (
    <div className="mt-12 flex gap-2">
      {[0, 1, 2].map((index) => (
        <span
          key={index}
          className={[
            'h-2.5 w-2.5 rounded-full',
            index === activeIndex ? 'bg-myspc-orange' : 'bg-myspc-orange/25',
          ].join(' ')}
        />
      ))}
    </div>
  )
}

type AuthHeroVariant = 'signup' | 'login'

const heroContent: Record<
  AuthHeroVariant,
  { title: ReactNode; subtitle: string; slideIndex: number }
> = {
  signup: {
    title: (
      <>
        Connect. Chat.{' '}
        <span className="text-myspc-orange">Belong.</span>
      </>
    ),
    subtitle:
      'MySpc helps you connect with people who matter and build real relationships.',
    slideIndex: 0,
  },
  login: {
    title: (
      <>
        Welcome{' '}
        <span className="text-myspc-orange">Back!</span>
      </>
    ),
    subtitle:
      "Glad to see you again. Let's continue your journey and stay connected.",
    slideIndex: 1,
  },
}

export function AuthHero({
  compact = false,
  variant = 'signup',
}: {
  compact?: boolean
  variant?: AuthHeroVariant
}) {
  const content = heroContent[variant]

  return (
    <div className="relative z-10 flex h-full flex-col justify-center px-8 py-12 lg:px-16 xl:px-20">
      <Logo className={compact ? 'mb-6' : 'mb-auto'} />

      <div className="max-w-lg">
        <h1 className="text-3xl font-bold leading-tight tracking-tight text-myspc-text sm:text-5xl lg:text-[3.25rem]">
          {content.title}
        </h1>
        <p className="mt-4 max-w-md text-base leading-relaxed text-myspc-muted sm:mt-5 sm:text-lg">
          {content.subtitle}
        </p>

        {!compact && (
          <>
            <HeroIllustrations />
            <SlideDots activeIndex={content.slideIndex} />
          </>
        )}
      </div>
    </div>
  )
}
