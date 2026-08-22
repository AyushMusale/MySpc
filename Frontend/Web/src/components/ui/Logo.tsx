interface LogoProps {
  className?: string
}

export function Logo({ className = '' }: LogoProps) {
  return (
    <div className={`flex items-center gap-2.5 ${className}`}>
      <svg
        width="36"
        height="36"
        viewBox="0 0 36 36"
        fill="none"
        aria-hidden="true"
      >
        <rect width="36" height="36" rx="10" fill="#FF7A00" />
        <path
          d="M10 14C10 11.7909 11.7909 10 14 10H18C20.2091 10 22 11.7909 22 14V18C22 20.2091 20.2091 22 18 22H14C11.7909 22 10 20.2091 10 18V14Z"
          fill="white"
        />
        <circle cx="13.5" cy="16" r="1.2" fill="#FF7A00" />
        <circle cx="16" cy="16" r="1.2" fill="#FF7A00" />
        <circle cx="18.5" cy="16" r="1.2" fill="#FF7A00" />
        <path
          d="M22 16L26 14V20L22 18"
          fill="white"
        />
      </svg>
      <span className="text-2xl font-bold text-myspc-orange">MySpc</span>
    </div>
  )
}
