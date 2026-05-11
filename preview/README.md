# Community App — Web Preview

An interactive web preview of the Community App design and user flows.

## About

This is a static Next.js web app that showcases the iOS app's design, screens, and user flows without being the actual native application. It's perfect for:

- Reviewing the UI/UX design
- Demonstrating the user flow to stakeholders
- Testing navigation and interactions
- Getting feedback on the design

## Getting Started

### Install dependencies

```bash
npm install
```

### Run the development server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Features

- **Interactive iPhone mockup** showing the app screens
- **Full user flow** from welcome → registration → groups → chat
- **Real-time navigation** between screens
- **Design system** with the app's color palette and typography
- **Responsive layout** (desktop preview of mobile app)

## Screens Included

1. **Welcome** — "Close the app. Open your world."
2. **Registration** — Multi-step onboarding (name, email, city)
3. **Login** — Sign in screen
4. **Explore** — Discover nearby groups (map/list view)
5. **Group Detail** — View group info and members
6. **Create Group** — Form to start a new group
7. **Group Chat** — Real-time group messaging
8. **My Groups** — List of joined groups
9. **Profile** — User profile and settings
10. **Edit Profile** — Update profile information

## Deploying to Vercel

### Option 1: Connect GitHub

1. Push this folder to a GitHub repository
2. Go to [vercel.com](https://vercel.com)
3. Click "New Project"
4. Select your repository
5. Set the root directory to `preview/`
6. Deploy

### Option 2: Deploy with Vercel CLI

```bash
npm i -g vercel
vercel
```

Follow the prompts to deploy.

## Tech Stack

- **Next.js** — React framework
- **React** — UI components
- **TypeScript** — Type safety
- **CSS** — Custom styling (no frameworks)

## Notes

- This is a design preview, not the actual iOS app
- To build the real iOS app, see `/ios/CommunityApp`
- To run the backend API, see `/backend`

## The Mission

This app exists to bring people back to being human. Every design decision prioritizes genuine human connection over screen time.

**Core Values:**
- People over profit
- Safety and trust first
- No feeds, no likes, no engagement tricks
- Real people, real connection

See the main [README.md](../README.md) for more details.
