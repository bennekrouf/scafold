#!/bin/bash
# Complete App Scaffold Generator - Minimal Empty Version
# Based on your mayorana.ch setup with all the production-ready features
# Usage: ./scaffold.sh <project-name>

set -e

PROJECT_NAME=${1:-"my-app"}
CURRENT_DIR=$(pwd)
PROJECT_DIR="$CURRENT_DIR/$PROJECT_NAME"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
  echo -e "${GREEN}✅ $1${NC}"
}

info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

warn() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
  echo -e "${RED}❌ $1${NC}"
  exit 1
}

# Check if project name provided
if [ -z "$1" ]; then
  error "Please provide a project name: ./scaffold.sh <project-name>"
fi

# Check if directory already exists
if [ -d "$PROJECT_DIR" ]; then
  error "Directory $PROJECT_NAME already exists!"
fi

info "🚀 Creating complete app scaffold: $PROJECT_NAME"
info "📁 Target directory: $PROJECT_DIR"

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Initialize git
git init
log "Git repository initialized"

# Create package.json with exact versions from mayorana
cat >package.json <<'EOF'
{
  "name": "PROJECT_NAME_PLACEHOLDER",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "@types/js-yaml": "^4.0.9",
    "framer-motion": "^12.10.1",
    "gray-matter": "^4.0.3",
    "js-yaml": "^4.1.0",
    "marked": "^15.0.11",
    "next": "15.3.1",
    "next-intl": "^4.3.4",
    "next-themes": "^0.4.6",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "react-hook-form": "^7.56.2",
    "react-icons": "^5.5.0",
    "reading-time": "^1.5.0",
    "remark": "^15.0.1",
    "remark-html": "^16.0.1",
    "remark-prism": "^1.3.6",
    "slugify": "^1.6.6",
    "tailwindcss-animate": "^1.0.7"
  },
  "devDependencies": {
    "@eslint/eslintrc": "^3",
    "@tailwindcss/typography": "^0.5.16",
    "@types/node": "^20",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "autoprefixer": "^10.4.21",
    "eslint": "^9",
    "eslint-config-next": "15.3.1",
    "postcss": "^8.5.3",
    "tailwindcss": "3.4.1",
    "typescript": "^5"
  }
}
EOF

# Replace project name placeholder (macOS compatible)
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s|PROJECT_NAME_PLACEHOLDER|$PROJECT_NAME|g" package.json
else
  sed -i "s|PROJECT_NAME_PLACEHOLDER|$PROJECT_NAME|g" package.json
fi
log "Package.json created with exact dependencies"

# Create TypeScript config
cat >tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": [
      "dom",
      "dom.iterable",
      "esnext"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "typeRoots": [
      "./node_modules/@types",
      "./src/types"
    ],
    "paths": {
      "@/*": [
        "./src/*"
      ]
    },
    "plugins": [
      {
        "name": "next"
      }
    ]
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts",
    "src/types/**/*.d.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF
log "TypeScript configuration created"

# Create Next.js config
cat >next.config.ts <<'EOF'
import createNextIntlPlugin from 'next-intl/plugin';

const withNextIntl = createNextIntlPlugin('./i18n.ts');

/** @type {import('next').NextConfig} */
const nextConfig = {
  trailingSlash: false,
  reactStrictMode: true,
  
  images: {
    remotePatterns: [
      {
        protocol: 'https' as const,
        hostname: 'localhost',
        port: '',
        pathname: '/**',
      },
    ],
  },

  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          { key: 'X-DNS-Prefetch-Control', value: 'on' },
          { key: 'X-Content-Type-Options', value: 'nosniff' },
          { key: 'X-Frame-Options', value: 'SAMEORIGIN' },
          { key: 'X-XSS-Protection', value: '1; mode=block' },
          { key: 'Referrer-Policy', value: 'origin-when-cross-origin' },
        ],
      },
    ];
  },

  poweredByHeader: false,
  compress: true,
};

export default withNextIntl(nextConfig);
EOF
log "Next.js configuration created"

# Create Tailwind config
cat >tailwind.config.ts <<'EOF'
import type { Config } from "tailwindcss"

const config: Config = {
  darkMode: ["class"],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
    './src/**/*.{ts,tsx}',
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: "0" },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: "0" },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
      typography: {
        DEFAULT: {
          css: {
            maxWidth: 'none',
            color: 'hsl(var(--foreground))',
            a: {
              color: 'hsl(var(--primary))',
              '&:hover': {
                color: 'hsl(var(--primary) / 0.8)',
              },
            },
            h1: {
              color: 'hsl(var(--foreground))',
            },
            h2: {
              color: 'hsl(var(--foreground))',
            },
            h3: {
              color: 'hsl(var(--foreground))',
            },
            h4: {
              color: 'hsl(var(--foreground))',
            },
            blockquote: {
              color: 'hsl(var(--muted-foreground))',
              borderLeftColor: 'hsl(var(--primary))',
            },
            code: {
              color: 'hsl(var(--foreground))',
              backgroundColor: 'hsl(var(--muted))',
              padding: '0.2em 0.4em',
              borderRadius: '0.25rem',
              fontWeight: '400',
              '&::before': {
                content: '""',
              },
              '&::after': {
                content: '""',
              },
            },
            'pre code': {
              backgroundColor: 'transparent',
              padding: '0',
            },
            pre: {
              color: 'hsl(var(--foreground))',
              backgroundColor: 'hsl(var(--muted))',
              borderRadius: '0.5rem',
              padding: '1rem',
              overflowX: 'auto',
            },
          },
        },
      },
    },
  },
  plugins: [
    require("tailwindcss-animate"),
    require('@tailwindcss/typography'),
  ],
}

export default config
EOF
log "Tailwind configuration created"

# Create PostCSS config
cat >postcss.config.mjs <<'EOF'
/** @type {import('postcss-load-config').Config} */
const config = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};

export default config;
EOF
log "PostCSS configuration created"

# Create ESLint config
cat >eslint.config.mjs <<'EOF'
import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const compat = new FlatCompat({
  baseDirectory: __dirname,
});

const eslintConfig = [
  ...compat.extends("next/core-web-vitals", "next/typescript"),
  {
    rules: {
      'react/no-unescaped-entities': 'off',
    }
  }
];

export default eslintConfig;
EOF
log "ESLint configuration created"

# Create directory structure
mkdir -p src/{app,components,lib,types,data}
mkdir -p src/app/{api,admin}
mkdir -p src/components/{layout,ui,seo}
mkdir -p public
mkdir -p config
mkdir -p messages
mkdir -p content/{en,fr}/blog
mkdir -p scripts

log "Directory structure created"

# Create i18n configuration
cat >i18n.ts <<'EOF'
import { getRequestConfig } from 'next-intl/server';

export const locales = ['en', 'fr'] as const;
export const defaultLocale = 'en' as const;

export default getRequestConfig(async ({ requestLocale }) => {
  let locale = await requestLocale;
  locale = defaultLocale;

  try {
    const messages = (await import(`./messages/${locale}.json`)).default;
    return {
      locale,
      messages
    };
  } catch (error) {
    console.error('Error loading messages:', error);
    return {
      locale: 'en',
      messages: {}
    };
  }
});
EOF
log "i18n configuration created"

# Create global CSS with complete design system
cat >src/app/globals.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Design System CSS Variables */
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 47.4% 11.2%;
    
    --card: 0 0% 100%;
    --card-foreground: 222.2 47.4% 11.2%;
 
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 47.4% 11.2%;
 
    --primary: 25 100% 50%; /* #FF6B00 - Change this for your brand */
    --primary-foreground: 0 0% 100%;
 
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
 
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
 
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
 
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
 
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;
 
    --radius: 0.5rem;
  }
 
  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
 
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
 
    --primary: 25 100% 50%; /* Keep primary consistent */
    --primary-foreground: 222.2 47.4% 11.2%;
 
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
 
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
 
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
 
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
 
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 212.7 26.8% 83.9%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
    transition-property: color, background-color, border-color;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
    transition-duration: 150ms;
    font-feature-settings: "rlig" 1, "calt" 1;
  }
}

/* Typography for blog/content */
.prose {
  max-width: 65ch;
  color: hsl(var(--foreground));
}

.prose a {
  color: hsl(var(--primary));
  text-decoration: underline;
  font-weight: 500;
}

.prose strong {
  color: hsl(var(--foreground));
  font-weight: 600;
}

.prose h1,
.prose h2,
.prose h3,
.prose h4,
.prose h5,
.prose h6 {
  color: hsl(var(--foreground));
  font-weight: 600;
  margin-top: 2em;
  margin-bottom: 1em;
}

.prose code {
  color: hsl(var(--foreground));
  font-weight: 600;
  background-color: hsl(var(--muted));
  padding: 0.2em 0.4em;
  border-radius: 0.25rem;
}

.prose pre {
  color: hsl(var(--foreground));
  background-color: hsl(var(--muted));
  border-radius: 0.5rem;
  padding: 1em;
  overflow-x: auto;
}

.prose blockquote {
  color: hsl(var(--muted-foreground));
  border-left-color: hsl(var(--border));
}

.prose hr {
  border-color: hsl(var(--border));
}

/* Text Selection Control */
* {
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

/* Allow text selection for form elements and content */
input,
textarea,
select,
button,
[contenteditable="true"],
[contenteditable=""],
.prose,
.prose *,
.selectable,
.selectable *,
pre,
code,
pre *,
code * {
  -webkit-user-select: text;
  -moz-user-select: text;
  -ms-user-select: text;
  user-select: text;
}

/* Code Syntax Highlighting */
.token.comment,
.token.prolog,
.token.doctype,
.token.cdata {
  color: #6a8494;
}

.token.punctuation {
  color: #a39e9b;
}

.token.property,
.token.tag,
.token.constant,
.token.symbol,
.token.deleted {
  color: #f92672;
}

.token.boolean,
.token.number {
  color: #ae81ff;
}

.token.selector,
.token.attr-name,
.token.string,
.token.char,
.token.builtin,
.token.inserted {
  color: #a6e22e;
}

.token.operator,
.token.entity,
.token.url,
.language-css .token.string,
.style .token.string,
.token.variable {
  color: #f8f8f2;
}

.token.atrule,
.token.attr-value,
.token.function,
.token.class-name {
  color: #e6db74;
}

.token.keyword {
  color: #66d9ef;
}

.token.regex,
.token.important {
  color: #fd971f;
}

.token.important,
.token.bold {
  font-weight: bold;
}

.token.italic {
  font-style: italic;
}

.token.entity {
  cursor: help;
}

/* Responsive Design */
@media (max-width: 768px) {
  .prose {
    font-size: 0.95rem;
  }
  
  .prose h1 {
    font-size: 1.875em;
  }
  
  .prose h2 {
    font-size: 1.375em;
  }
  
  .prose h3 {
    font-size: 1.125em;
  }
  
  .prose h4 {
    font-size: 1em;
  }
}
EOF
log "Global CSS with complete design system created"

# Create root layout (minimal)
cat >src/app/layout.tsx <<'EOF'
import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "My App",
  description: "Built with the complete app scaffold",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html suppressHydrationWarning>
      <body className={`${geistSans.variable} ${geistMono.variable} antialiased`}>
        {children}
      </body>
    </html>
  );
}
EOF
log "Root layout created"

# Create theme provider
cat >src/app/providers.tsx <<'EOF'
'use client';

import * as React from 'react';
import { ThemeProvider as NextThemesProvider } from 'next-themes';
import type { ThemeProviderProps } from 'next-themes';

export function ThemeProvider({ children, ...props }: ThemeProviderProps) {
  return (
    <NextThemesProvider {...props}>
      {children}
    </NextThemesProvider>
  );
}
EOF
log "Theme provider created"

# Create locale layout
mkdir -p "src/app/[locale]"
cat >"src/app/[locale]/layout.tsx" <<'EOF'
import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "../globals.css";
import { ThemeProvider } from "../providers";
import { NextIntlClientProvider } from 'next-intl';
import { getTranslations } from 'next-intl/server';
import { locales } from '../../../i18n';
import { notFound } from 'next/navigation';

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

type Props = {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
};

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: 'metadata' });

  return {
    title: {
      template: '%s | My App',
      default: t('site_title'),
    },
    description: t('site_description'),
  };
}

export function generateStaticParams() {
  return locales.map((locale) => ({ locale }));
}

export default async function LocaleLayout({
  children,
  params
}: Props) {
  const { locale } = await params;

  if (!locales.includes(locale as (typeof locales)[number])) {
    notFound();
  }

  let messages;
  try {
    if (locale === 'fr') {
      messages = (await import('../../../messages/fr.json')).default;
    } else {
      messages = (await import('../../../messages/en.json')).default;
    }
  } catch (error) {
    console.error('Error loading messages:', error);
    messages = (await import('../../../messages/en.json')).default;
  }

  return (
    <html lang={locale} suppressHydrationWarning>
      <body className={`${geistSans.variable} ${geistMono.variable} antialiased`}>
        <NextIntlClientProvider locale={locale} messages={messages}>
          <ThemeProvider attribute="class" defaultTheme="system" enableSystem disableTransitionOnChange>
            {children}
          </ThemeProvider>
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
EOF
log "Locale layout created"

# Create root page redirect
cat >src/app/page.tsx <<'EOF'
import { redirect } from 'next/navigation';
import { headers } from 'next/headers';

export default async function RootRedirectPage() {
  try {
    const headersList = await headers();
    const acceptLanguage = headersList.get('accept-language') || '';
    const userLocale = acceptLanguage.toLowerCase().includes('fr') ? 'fr' : 'en';
    redirect(`/${userLocale}`);
  } catch (error) {
    console.error('Root redirect error:', error);
    redirect('/en');
  }

  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
        <p>Redirecting...</p>
      </div>
    </div>
  );
}
EOF
log "Root page redirect created"

# Create empty home page
cat >"src/app/[locale]/page.tsx" <<'EOF'
import LayoutTemplate from '@/components/layout/LayoutTemplate';

export default function HomePage() {
  return (
    <LayoutTemplate>
      <main className="min-h-screen">
        {/* Your content goes here */}
        <section className="py-20">
          <div className="container">
            <div className="max-w-4xl mx-auto text-center">
              <h1 className="text-4xl md:text-6xl font-bold mb-6">
                Welcome
              </h1>
              <p className="text-xl text-muted-foreground mb-10">
                Your app is ready to build.
              </p>
            </div>
          </div>
        </section>
      </main>
    </LayoutTemplate>
  );
}
EOF
log "Empty home page created"

log "Empty navbar created"

# Create empty footer
cat >src/components/layout/Footer.tsx <<'EOF'
'use client';

import React from 'react';
import Link from 'next/link';
import { useTranslations, useLocale } from 'next-intl';

const Footer: React.FC = () => {
  const currentYear = new Date().getFullYear();
  const locale = useLocale();
  const t = useTranslations('footer');

  // Helper function to get localized path
  const getLocalizedPath = (path: string) => {
    if (locale === 'en') return path;
    return `/${locale}${path}`;
  };

  // Empty footer navigation - add your own
  const footerNav = [
    // Example: { label: t('privacy'), path: "/privacy" },
    // Example: { label: t('terms'), path: "/terms" },
  ];

  return (
    <footer className="border-t border-border bg-background">
      <div className="container py-12">
        <div className="grid md:grid-cols-4 gap-8">
          {/* Column 1: Logo & Description */}
          <div className="space-y-4">
            <Link href={getLocalizedPath("/")} className="flex items-center space-x-2">
              <span className="font-bold text-xl text-foreground">MyApp</span>
            </Link>
            <p className="text-muted-foreground text-sm">
              {t('description')}
            </p>
          </div>

          {/* Column 2: Quick Links */}
          <div>
            <h3 className="font-medium text-foreground mb-4">{t('quick_links')}</h3>
            <ul className="space-y-2">
              {footerNav.map((item) => (
                <li key={item.label}>
                  <Link
                    href={getLocalizedPath(item.path)}
                    className="text-sm text-muted-foreground hover:text-primary transition-colors"
                  >
                    {item.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Column 3: Placeholder */}
          <div>
            <h3 className="font-medium text-foreground mb-4">{t('category')}</h3>
            <ul className="space-y-2">
              {/* Add your links here */}
            </ul>
          </div>

          {/* Column 4: Contact */}
          <div>
            <h3 className="font-medium text-foreground mb-4">{t('connect')}</h3>
            <div className="flex space-x-4 mb-4">
              {/* Add your social links here */}
            </div>
            <p className="text-sm text-muted-foreground">
              {t('email_label')} contact@myapp.com
            </p>
          </div>
        </div>

        <div className="border-t border-border mt-8 pt-8 flex flex-col md:flex-row md:justify-between items-center">
          <p className="text-sm text-muted-foreground">
            &copy; {currentYear} MyApp. {t('copyright')}
          </p>
          <p className="text-sm text-muted-foreground mt-2 md:mt-0">
            {t('tagline')}
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
EOF
log "Empty footer created"

# Create API placeholder
mkdir -p src/app/api/contact
cat >src/app/api/contact/route.ts <<'EOF'
import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // TODO: Add your contact form handling logic here
    // Examples:
    // - Send email via SendGrid, Resend, etc.
    // - Save to database
    // - Integrate with CRM
    
    console.log('Contact form submission:', body);
    
    return NextResponse.json(
      { message: 'Message sent successfully' },
      { status: 200 }
    );
  } catch (error) {
    console.error('Contact form error:', error);
    return NextResponse.json(
      { message: 'Failed to send message' },
      { status: 500 }
    );
  }
}
EOF
log "API placeholder created"

# Create minimal messages files
cat >messages/en.json <<'EOF'
{
  "metadata": {
    "site_title": "MyApp",
    "site_description": "Your app description"
  },
  "navigation": {
    "home": "Home",
    "about": "About",
    "contact": "Contact"
  },
  "common": {
    "loading": "Loading...",
    "error": "Error"
  }
}
EOF
log "English messages created"

cat >messages/fr.json <<'EOF'
{
  "metadata": {
    "site_title": "MonApp",
    "site_description": "Description de votre app"
  },
  "navigation": {
    "home": "Accueil",
    "about": "À propos",
    "contact": "Contact"
  },
  "common": {
    "loading": "Chargement...",
    "error": "Erreur"
  }
}
EOF
log "French messages created"

# Create types file
cat >src/types/globals.d.ts <<'EOF'
export {};

declare global {
  interface Window {
    // Add your global window types here
    plausible?: {
      (event: string, options?: { props?: Record<string, string> }): void;
      q?: Array<unknown>;
    };
  }
}
EOF
log "Global types created"

# Create config placeholder
cat >config/site.yaml <<'EOF'
# Site Configuration
site:
  name: "MyApp"
  domain: "myapp.com"
  description: "Your app description"
  locale: "en"
  
# Add your configuration here
api:
  # example_service_url: "https://api.example.com"
  
# Logging preferences (following your Rust preference)
logging:
  level: "trace"
  format: "json"
  output: "console"
EOF
log "Site config created"

# Create gitignore
cat >.gitignore <<'EOF'
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.*
.yarn/*
!.yarn/patches
!.yarn/plugins
!.yarn/releases
!.yarn/versions

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# env files
.env*

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts

# Generated data
src/data/
public/sitemap.xml

# Runtime files
.last-publish
.publishing-paused
.skip-today
.queue-state.json
EOF
log "Gitignore created"

# Create environment template
cat >.env.template <<'EOF'
# Environment Variables Template
# Copy to .env.local for development

# Database
# DATABASE_URL="postgresql://..."

# API Keys
# OPENAI_API_KEY=""
# STRIPE_SECRET_KEY=""

# Email Service
# RESEND_API_KEY=""
# SENDGRID_API_KEY=""

# Analytics
# PLAUSIBLE_DOMAIN=""

# Admin
# ADMIN_SECRET_KEY="your-secret-key"
EOF
log "Environment template created"

# Create README
cat >README.md <<'EOF'
# MyApp

A modern, responsive web application built with Next.js, TypeScript, and Tailwind CSS.

## Features

- 🌍 **i18n Support**: English and French localization
- 🌙 **Dark Mode**: Built-in theme switching
- 📱 **Responsive**: Mobile-first design
- ⚡ **Performance**: Next.js 15 with App Router
- 🎨 **Design System**: Complete CSS variables and Tailwind config
- 🔒 **Type Safe**: Full TypeScript support
- 📦 **Production Ready**: ESLint, error handling, SEO optimized

## Tech Stack

- **Framework**: Next.js 15 with TypeScript
- **Styling**: Tailwind CSS with shadcn/ui design system
- **Internationalization**: next-intl
- **Theme**: next-themes with CSS variables
- **Animations**: Framer Motion
- **Forms**: React Hook Form
- **Icons**: React Icons (Feather)
- **Linting**: ESLint with Next.js config

## Getting Started

```bash
# Install dependencies
yarn install

# Start development server
yarn dev

# Build for production
yarn build

# Start production server
yarn start

# Type check
yarn type-check

# Lint code
yarn lint
```

## Project Structure

```
├── src/
│   ├── app/                 # Next.js App Router
│   │   ├── [locale]/        # Internationalized routes
│   │   ├── api/             # API routes
│   │   └── globals.css      # Global styles
│   ├── components/          # React components
│   │   ├── layout/          # Layout components
│   │   └── ui/              # UI components
│   ├── lib/                 # Utility functions
│   └── types/               # TypeScript types
├── messages/                # i18n translations
├── config/                  # Configuration files
├── public/                  # Static assets
└── content/                 # Content files (if using)
```

## Configuration

### Environment Variables

Copy `.env.template` to `.env.local` and fill in your values:

```bash
cp .env.template .env.local
```

### Site Configuration

Edit `config/site.yaml` for your app-specific settings.

### Internationalization

- Edit `messages/en.json` and `messages/fr.json` for translations
- Add new locales in `i18n.ts`

### Styling

- Primary brand color: Edit CSS variable `--primary` in `globals.css`
- Dark/light mode: Automatically handled by `next-themes`
- Design system: Full Tailwind config with CSS variables

### Navigation

- Edit `navItems` array in `src/components/layout/Navbar.tsx`
- Add footer links in `src/components/layout/Footer.tsx`

## Customization

1. **Brand Colors**: Update `--primary` in `src/app/globals.css`
2. **Logo**: Replace "MyApp" in navbar and footer
3. **Navigation**: Add your menu items to the navbar
4. **Content**: Build your pages in `src/app/[locale]/`
5. **API**: Add your endpoints in `src/app/api/`

## Deployment

### Vercel (Recommended)

```bash
npm i -g vercel
vercel
```

### Traditional Hosting

```bash
yarn build
# Upload the .next folder and package.json
# Run: yarn start
```

## Development Notes

This scaffold follows your preferences:
- ✅ Modern responsive design
- ✅ Dark mode support  
- ✅ Empty menu structure (ready for your content)
- ✅ YAML configuration files
- ✅ Trace logging support
- ✅ Complete TypeScript setup
- ✅ Production-ready build process

## Next Steps

1. Customize the brand colors and logo
2. Add your navigation menu items
3. Build out your pages and components  
4. Set up your API endpoints
5. Configure environment variables
6. Deploy to your preferred platform

Built with ❤️ following modern best practices.
EOF
log "README created"

# Create package-lock or yarn.lock placeholder
touch yarn.lock
log "Yarn lock placeholder created"

# Final setup
info "🎯 Installation complete!"
info ""
info "📋 Next steps:"
info "1. cd $PROJECT_NAME"
info "2. yarn install"
info "3. yarn dev"
info ""
info "🎨 Customization:"
info "- Edit src/components/layout/Navbar.tsx for navigation"
info "- Change --primary color in src/app/globals.css"
info "- Update messages/en.json and messages/fr.json"
info "- Configure config/site.yaml"
info ""
info "🚀 Your app will be available at http://localhost:3000"

warn "Remember to:"
warn "- Copy .env.template to .env.local"
warn "- Update the brand name throughout the files"
warn "- Add your actual navigation items"

# Create Motion wrapper component
cat >src/components/ui/Motion.tsx <<'EOF'
'use client';

import { motion } from 'framer-motion';

// Re-export motion for client-side use
export { motion };
EOF
log "Motion component created"

# Create layout template with empty navbar
cat >src/components/layout/LayoutTemplate.tsx <<'EOF'
'use client';

import React from 'react';
import Navbar from '@/components/layout/Navbar';
import Footer from '@/components/layout/Footer';

interface LayoutTemplateProps {
  children: React.ReactNode;
}

const LayoutTemplate: React.FC<LayoutTemplateProps> = ({
  children
}) => {
  return (
    <div className="flex flex-col min-h-screen">
      <Navbar />
      <main className="flex-grow">
        {children}
      </main>
      <Footer />
    </div>
  );
};

export default LayoutTemplate;
EOF
log "Layout template created"

# Create empty responsive navbar
cat >src/components/layout/Navbar.tsx <<'EOF'
'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { FiMenu, FiX, FiMoon, FiSun, FiGlobe } from 'react-icons/fi';
import { useTheme } from 'next-themes';
import { useTranslations, useLocale } from 'next-intl';

const Navbar: React.FC = () => {
  const [mounted, setMounted] = useState(false);
  const [isOpen, setIsOpen] = useState(false);
  const [showLangMenu, setShowLangMenu] = useState(false);
  const { theme, setTheme } = useTheme();
  const pathname = usePathname();
  const locale = useLocale();
  const t = useTranslations('navigation');

  // Empty navigation items - add your own
  const navItems = [
    // Example: { label: t('home'), path: "/" },
    // Example: { label: t('about'), path: "/about" },
    // Example: { label: t('contact'), path: "/contact" },
  ];

  // Language options
  const languages = [
    { code: 'en', name: 'English' },
    { code: 'fr', name: 'Français' }
  ];

  useEffect(() => setMounted(true), []);

  const toggleMenu = () => setIsOpen(!isOpen);
  const toggleLangMenu = () => setShowLangMenu(!showLangMenu);
  const toggleTheme = () => setTheme(theme === 'dark' ? 'light' : 'dark');

  const isLinkActive = (path: string) => {
    const currentPath = pathname.replace(/\/$/, '');
    const normalizedPath = path.replace(/\/$/, '');
    return currentPath === `/${locale}${normalizedPath}` ||
      (path === '/' && currentPath === `/${locale}`);
  };

  const currentLang = languages.find(lang => lang.code === locale) || languages[0];

  return (
    <header className="sticky top-0 z-40 w-full border-b border-border bg-background/95 backdrop-blur-sm">
      <div className="container flex h-16 items-center justify-between">
        {/* Logo */}
        <div className="flex items-center">
          <Link
            href={`/${locale}`}
            className="flex items-center space-x-2"
          >
            <span className="font-bold text-xl text-foreground">MyApp</span>
          </Link>
        </div>

        {/* Desktop Navigation */}
        <nav className="hidden md:flex items-center space-x-6">
          {navItems.map((item) => (
            <Link
              key={item.label}
              href={`/${locale}${item.path}`}
              className={`text-sm font-medium transition-colors hover:text-primary ${
                isLinkActive(item.path) ? "text-primary" : "text-foreground"
              }`}
            >
              {item.label}
            </Link>
          ))}

          {/* Language Switcher */}
          <div className="relative">
            <button
              onClick={toggleLangMenu}
              className="rounded-full p-2 bg-secondary hover:bg-secondary/80 transition-colors flex items-center"
              aria-label={t('toggle_language')}
            >
              <FiGlobe className="h-5 w-5 mr-1" />
              <span className="text-sm font-medium">{currentLang.code.toUpperCase()}</span>
            </button>

            {showLangMenu && (
              <div className="absolute right-0 mt-2 w-40 bg-background border border-border rounded-lg shadow-lg py-1 z-50">
                {languages.map((lang) => (
                  <Link
                    key={lang.code}
                    href={pathname.replace(/^\/[a-z]{2}/, `/${lang.code}`)}
                    className={`flex items-center px-3 py-2 text-sm hover:bg-secondary transition-colors ${
                      locale === lang.code ? 'bg-secondary text-primary' : 'text-foreground'
                    }`}
                    onClick={() => setShowLangMenu(false)}
                  >
                    <span className="mr-2 text-xs font-mono">{lang.code.toUpperCase()}</span>
                    {lang.name}
                  </Link>
                ))}
              </div>
            )}
          </div>

          {/* Theme Toggle */}
          <button
            onClick={toggleTheme}
            className="rounded-full p-2 bg-secondary hover:bg-secondary/80 transition-colors"
            aria-label={t('toggle_theme')}
          >
            {mounted && theme === 'dark' ? (
              <FiSun className="h-5 w-5" />
            ) : (
              <FiMoon className="h-5 w-5" />
            )}
          </button>
        </nav>

        {/* Mobile Navigation Toggle */}
        <div className="flex md:hidden items-center space-x-2">
          {/* Mobile Language Switcher */}
          <div className="relative">
            <button
              onClick={toggleLangMenu}
              className="rounded-full p-2 bg-secondary hover:bg-secondary/80 transition-colors flex items-center"
              aria-label={t('toggle_language')}
            >
              <FiGlobe className="h-5 w-5 mr-1" />
              <span className="text-xs font-medium">{currentLang.code.toUpperCase()}</span>
            </button>

            {showLangMenu && (
              <div className="absolute right-0 mt-2 w-32 bg-background border border-border rounded-lg shadow-lg py-1 z-50">
                {languages.map((lang) => (
                  <Link
                    key={lang.code}
                    href={pathname.replace(/^\/[a-z]{2}/, `/${lang.code}`)}
                    className={`flex items-center px-3 py-2 text-sm hover:bg-secondary transition-colors ${
                      locale === lang.code ? 'bg-secondary text-primary' : 'text-foreground'
                    }`}
                    onClick={() => setShowLangMenu(false)}
                  >
                    <span className="mr-2 text-xs font-mono">{lang.code.toUpperCase()}</span>
                    {lang.name}
                  </Link>
                ))}
              </div>
            )}
          </div>

          {/* Mobile Theme Toggle */}
          <button
            onClick={toggleTheme}
            className="rounded-full p-2 bg-secondary hover:bg-secondary/80 transition-colors"
            aria-label={t('toggle_theme')}
          >
            {mounted && theme === 'dark' ? (
              <FiSun className="h-5 w-5" />
            ) : (
              <FiMoon className="h-5 w-5" />
            )}
          </button>

          {/* Mobile Menu Toggle */}
          <button
            onClick={toggleMenu}
            className="p-2 rounded-md text-foreground"
            aria-label={t('toggle_menu')}
          >
            {isOpen ? (
              <FiX className="h-6 w-6" />
            ) : (
              <FiMenu className="h-6 w-6" />
            )}
          </button>
        </div>
      </div>

      {/* Mobile Navigation Menu */}
      {isOpen && (
        <div className="md:hidden">
          <div className="container py-4 space-y-3">
            {navItems.map((item) => (
              <Link
                key={item.label}
                href={`/${locale}${item.path}`}
                className={`block px-4 py-2 text-sm font-medium transition-colors hover:text-primary ${
                  isLinkActive(item.path) ? "text-primary" : "text-foreground"
                }`}
                onClick={toggleMenu}
              >
                {item.label}
              </Link>
            ))}
          </div>
        </div>
      )}
    </header>
  );
};

export default Navbar;
EOF
