import Script from 'next/script';
import type { Metadata } from 'next';
import { Navigation } from '@/components/navigation';
import { ThemeProvider } from '@/components/theme-provider';
import './globals.css';

const GA_TRACKING_ID = 'G-FGXDPZVYSW';
const isProduction = process.env.NODE_ENV === 'production';

export const metadata: Metadata = {
  title: {
    default: 'Angus Hsu - Software Engineer',
    template: '%s | Angus Hsu'
  },
  description: 'Innovative full-stack developer specializing in React, Next.js, Node.js, and scalable web applications. Expert in modern web technologies with proven track record in building high-performance solutions.',
  keywords: ['Angus Hsu', 'Full Stack Developer', 'Software Engineer', 'React', 'Next.js', 'Node.js', 'JavaScript', 'TypeScript', 'Web Development', 'Software Development'],
  authors: [{ name: 'Angus Hsu' }],
  creator: 'Angus Hsu',
  publisher: 'Angus Hsu',
  metadataBase: new URL('https://angushsu.me'),
  alternates: {
    canonical: '/',
  },
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: 'https://angushsu.me',
    title: 'Angus Hsu - Full Stack Developer & Software Engineer',
    description: 'Innovative full-stack developer specializing in React, Next.js, Node.js, and scalable web applications. Expert in modern web technologies.',
    siteName: 'Angus Hsu Portfolio',
    images: [
      {
        url: '/images/AH-seo.png',
        width: 1200,
        height: 630,
        alt: 'Angus Hsu - Full Stack Developer',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Angus Hsu - Full Stack Developer & Software Engineer',
    description: 'Innovative full-stack developer specializing in React, Next.js, Node.js, and scalable web applications.',
    images: ['/images/AH-seo.png'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  icons: {
    icon: [
      { url: '/images/favicons/favicon-16x16.png', sizes: '16x16', type: 'image/png' },
      { url: '/images/favicons/favicon-32x32.png', sizes: '32x32', type: 'image/png' },
      { url: '/images/favicons/favicon-96x96.png', sizes: '96x96', type: 'image/png' },
      { url: '/images/favicons/favicon.ico', sizes: 'any' },
    ],
    apple: [
      { url: '/images/favicons/favicon-96x96.png', sizes: '96x96' },
    ],
  },
  verification: {
    google: 'your-google-site-verification-code',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const structuredData = {
    "@context": "https://schema.org",
    "@type": "Person",
    "name": "Angus Hsu",
    "jobTitle": "Full Stack Developer",
    "description": "Innovative full-stack developer specializing in React, Next.js, Node.js, and scalable web applications",
    "url": "https://angushsu.me",
    "image": "https://angushsu.me/images/angus-self.jpg",
    "sameAs": [
      "https://github.com/angushsu",
      "https://linkedin.com/in/angushsu"
    ],
    "knowsAbout": [
      "React",
      "Next.js", 
      "Node.js",
      "JavaScript",
      "TypeScript",
      "Full Stack Development",
      "Software Engineering"
    ],
    "worksFor": {
      "@type": "Organization",
      "name": "Freelance Developer"
    }
  };

  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }}
        />
      </head>
      <body>
        {isProduction && (
          <>
            <Script
              src={`https://www.googletagmanager.com/gtag/js?id=${GA_TRACKING_ID}`}
              strategy="afterInteractive"
            />
            <Script id="google-analytics" strategy="afterInteractive">
              {`
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());
                gtag('config', '${GA_TRACKING_ID}');
              `}
            </Script>
          </>
        )}
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <Navigation />
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}