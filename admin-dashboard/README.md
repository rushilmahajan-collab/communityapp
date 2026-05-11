# Community App Admin Dashboard

A web-based admin dashboard for managing user verifications, reviewing videos, and monitoring platform statistics.

## ✨ Features

- **Dashboard Stats** — Real-time metrics on users, groups, engagement
- **User Management** — Search and view user profiles
- **Activity Logs** — Audit trail of all admin actions

## 🚀 Quick Start (Works with Railway Backend)

### 1. Open the Dashboard

Simply open `admin-dashboard/index.html` in your browser (or deploy to Vercel/Netlify).

### 2. Sign In

When your backend is on Railway:

```
API URL:  https://yourapp-abc123.railway.app/api
Email:    your@email.com
Password: your-password
```

The dashboard will connect to your live Railway backend.

### 3. Start Reviewing

- **Videos Tab** — Watch user submissions, approve/reject
- **Stats Tab** — See platform metrics in real-time
- **Users Tab** — Manage user accounts
- **Logs Tab** — Track all admin actions

## 🔄 How It Works with Railway

```
Admin Dashboard (HTML/JS)
        ↓
    HTTPS API
        ↓
Railway Backend
        ↓
PostgreSQL Database
```

When users register:
1. User creates profile with quiz responses
2. Data stored in PostgreSQL database
3. Admin can view user profiles and statistics
4. Admin can track community engagement

## 🌐 Deploy Admin Dashboard

Since it's pure HTML/JavaScript (no build step):

### Option 1: Vercel (Recommended)

```bash
vercel admin-dashboard/
```

### Option 2: Netlify

Drag and drop `admin-dashboard/` folder to Netlify.

### Option 3: GitHub Pages

```bash
git subtree push --prefix admin-dashboard/ origin gh-pages
```

## 🔐 Authentication

The dashboard uses JWT tokens:

1. Sign in with email/password
2. Gets 7-day token from backend
3. Token stored in browser localStorage
4. All requests include: `Authorization: Bearer <token>`
5. Sign out clears token

## 📊 Admin Features

### Statistics Dashboard
- **Users**: Total user count
- **Groups**: Total groups created
- **Engagement**: Messages and hangouts completed
- **Community Growth**: Real-time metrics

### User Management
- Search users by name or email
- View user profiles with registration info
- See location and city information
- Track user joining dates

### Activity Log
- All admin actions logged
- Timestamps on all activities
- Action audit trail

## 🛠️ Environment Variables (Railway Backend)

Your Railway backend needs:

```env
DATABASE_URL=postgresql://...  # Railway Postgres
JWT_SECRET=your-secret-key      # For JWT tokens
```

## 📱 Mobile-Friendly

Dashboard is responsive:
- Desktop: Sidebar navigation
- Mobile: Full-width, easy thumb access
- Touch-friendly buttons

## 🔒 Security

✅ **JWT Authentication** — 7-day tokens
✅ **Admin Role** — First user is admin, controlled by is_admin flag
✅ **Audit Logging** — Every admin action tracked
✅ **CORS Enabled** — Works with Railway backend
✅ **Rate Limiting** — Admin endpoints not limited (batch operations)

## 🚧 Admin Workflow

### Daily Community Management (5 minutes)

1. Open admin dashboard
2. Check **Statistics** for community growth
3. View **Users** tab to see new registrations
4. Review **Activity Log** for engagement metrics

## 🆚 Admin API Endpoints

The dashboard uses these endpoints:

```
POST   /api/auth/login         # Login with email/password
GET    /api/admin/stats        # Get dashboard statistics
GET    /api/users              # Get all users
GET    /api/admin/logs         # Get activity logs
```

See `backend/ADMIN_API.md` for full documentation.

## 🐛 Troubleshooting

### "Can't connect to API"
- Check API URL includes `/api` at end
- Verify Railway backend is running
- Check firewall/CORS settings

### "Invalid credentials"
- Make sure you created an admin user on the backend
- Check email and password are correct
- The first registered user is automatically an admin

### "No users showing up"
- Wait a few minutes for data to load
- Verify users have registered on the iOS app
- Check Railway backend is connected to PostgreSQL

## 📝 Notes

- Dashboard is pure HTML/CSS/JS — no build step
- Edit `index.html` directly to customize
- No external dependencies needed
- Token stored in localStorage (clears on logout)
- All data pulled directly from PostgreSQL via backend API

## 📚 Learn More

- **Admin API** — See `backend/ADMIN_API.md`
- **Backend Setup** — See `backend/LOCAL_SETUP.md`
- **Database Schema** — See migrations in `backend/src/db/migrations/`

---

**Ready to review verifications?** Just open `admin-dashboard/index.html` and sign in with your admin credentials!
