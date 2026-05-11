import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Community App Preview',
  description: 'Close the app. Open your world.',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
