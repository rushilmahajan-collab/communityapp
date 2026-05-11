# Community App Admin Dashboard

A web-based admin dashboard for managing user verifications, reviewing videos, and monitoring platform statistics.

## ✨ Features

- **Video Verification Review** — Queue of pending users, built-in video player, approve/reject
- **Dashboard Stats** — Real-time metrics on users, groups, engagement
- **User Management** — Search, view profiles, flag suspicious activity
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
PostgreSQL + S3
```

When users register:
1. Upload verification video
2. Video goes to AWS S3
3. S3 URL stored in database
4. Admin dashboard fetches from S3
5. Admin approves/rejects
6. Decision saved to database

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

### Video Verification Queue
- Pending verifications (oldest first)
- Video player with controls
- User name, email, city
- Approve button: Mark user as verified
- Reject button: Return video for resubmission

### Statistics Dashboard
- **Users**: Total, verified, pending, rejection rate
- **Groups**: By city, total count
- **Engagement**: Messages, hangouts completed
- **Activity**: Users joined this week

### User Management
- Search users
- View detailed profiles
- See group memberships
- View activity stats
- Flag for review (low/medium/high severity)

### Activity Log
- All admin actions logged
- Approval/rejection history
- User flags
- Timestamps and notes

## 🛠️ Environment Variables (Railway Backend)

Your Railway backend needs:

```env
DATABASE_URL=postgresql://...  # Railway Postgres
JWT_SECRET=your-secret-key      # For JWT tokens
AWS_ACCESS_KEY_ID=...           # For S3
AWS_SECRET_ACCESS_KEY=...       # For S3
S3_BUCKET_NAME=your-bucket      # Video storage
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

### Daily Verification Review (5 minutes)

1. Open admin dashboard
2. Go to **Verifications** tab
3. Watch pending videos
4. Click **Approve** or **Reject**
5. Check **Stats** to see metrics

## 🆚 Admin API Endpoints

The dashboard uses these endpoints:

```
POST   /api/auth/login                    # Login with email/password
GET    /api/admin/videos/pending          # Get pending verifications
POST   /api/admin/videos/approve/:userId  # Approve user
POST   /api/admin/videos/reject/:userId   # Reject user
GET    /api/admin/stats                   # Get dashboard stats
GET    /api/admin/logs                    # Get activity logs
```

See `backend/ADMIN_API.md` for full documentation.

## 🐛 Troubleshooting

### "Can't connect to API"
- Check API URL includes `/api` at end
- Verify Railway backend is running
- Check firewall/CORS settings

### "Can't see videos"
- Verify AWS S3 credentials
- Check bucket name is correct
- Videos must have public read access

### "Admin access required"
- Make sure you're the first user (auto admin)
- Check `is_admin` column in database

## 📝 Notes

- Dashboard is pure HTML/CSS/JS — no build step
- Edit `index.html` directly to customize
- Videos fetched directly from S3 URLs
- No video transcoding — supports MP4, WebM, etc.
- Token stored in localStorage (clears on logout)

## 📚 Learn More

- **Admin API** — See `backend/ADMIN_API.md`
- **Backend Setup** — See `backend/LOCAL_SETUP.md`
- **Database Schema** — See migrations in `backend/src/db/migrations/`

---

**Ready to review verifications?** Just open `admin-dashboard/index.html` and sign in with your admin credentials!
