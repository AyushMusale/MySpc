import type { InputHTMLAttributes, ReactNode } from 'react'

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string
  icon?: ReactNode
  hint?: string
  error?: string
}

export function Input({
  label,
  icon,
  hint,
  error,
  className = '',
  id,
  ...props
}: InputProps) {
  const inputId = id ?? label.toLowerCase().replace(/\s+/g, '-')

  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={inputId} className="text-sm font-medium text-myspc-text">
        {label}
      </label>
      <div className="relative">
        {icon && (
          <span className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-myspc-muted">
            {icon}
          </span>
        )}
        <input
          id={inputId}
          className={[
            'w-full rounded-xl border border-myspc-border bg-white py-3 text-sm text-myspc-text',
            'placeholder:text-myspc-muted/70 focus:border-myspc-orange focus:outline-none focus:ring-2 focus:ring-myspc-orange/20',
            icon ? 'pl-11 pr-4' : 'px-4',
            error ? 'border-red-400 focus:border-red-400 focus:ring-red-200' : '',
            className,
          ]
            .filter(Boolean)
            .join(' ')}
          {...props}
        />
      </div>
      {hint && !error && <p className="text-xs text-myspc-muted">{hint}</p>}
      {error && <p className="text-xs text-red-500">{error}</p>}
    </div>
  )
}
