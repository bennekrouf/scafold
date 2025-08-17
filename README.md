# Complete App Scaffold Generator

A production-ready Next.js scaffold with all modern features, based on the mayorana.ch architecture. Perfect for creating multiple projects with consistent, professional setup.

## 🚀 Quick Start

```bash
# Make executable
chmod +x scaffold.sh

# Create new project
./scaffold.sh my-project-name

# Setup and run
cd my-project-name
yarn install
cp .env.template .env.local
yarn dev
```

## ✨ What You Get

**🏗️ Infrastructure**
- Next.js 15 with App Router & TypeScript
- Tailwind CSS with complete design system
- ESLint + Production-ready config

**🎨 Design & UX**
- Dark/light mode (next-themes)
- Responsive mobile-first design
- Empty navigation (ready for your content)
- Complete CSS variables system

**🌍 Internationalization**
- next-intl with EN/FR support
- Locale-based routing (/en, /fr)
- Language switcher in navbar

**⚡ Developer Experience**
- YAML configuration files
- API route structure
- Complete TypeScript types
- Framer Motion animations

**📦 Production Ready**
- SEO optimized
- Security headers
- Error handling
- Environment template

## 📁 Project Structure

```
my-project/
├── src/
│   ├── app/[locale]/          # i18n routes
│   ├── components/layout/     # Navbar, Footer
│   ├── lib/                   # Utilities
│   └── types/                 # TypeScript
├── messages/                  # Translations
├── config/                    # YAML configs
└── public/                    # Assets
```

## 🔧 Customization

1. **Brand**: Update `--primary` color in `globals.css`
2. **Logo**: Replace "MyApp" in navbar/footer
3. **Navigation**: Add menu items to `Navbar.tsx`
4. **Content**: Build pages in `src/app/[locale]/`
5. **API**: Add endpoints in `src/app/api/`

## 🎯 Perfect For

- SaaS applications
- Landing pages
- Business websites
- Lead dashboards
- E-commerce platforms
- Any modern web app

## 📝 Example Usage

```bash
./scaffold.sh lead-dashboard    # CRM system
./scaffold.sh saas-landing     # Marketing site
./scaffold.sh e-commerce       # Online store
./scaffold.sh portfolio        # Personal site
```

Each project gets the same professional foundation - just add your specific business logic!

---

**Built with ❤️ following modern best practices**