# Deployment Guide

Complete step-by-step guide for deploying Community App to Railway and Vercel **without using terminal**.

---

## 🚀 STEP 1: Deploy Backend to Railway

### 1.1 Sign Up / Log In to Railway

1. Go to https://railway.app
2. Click **"Sign Up"** or **"Login"**
3. Sign in with **GitHub** (easiest)

### 1.2 Create New Project

1. In Railway dashboard, click **"New Project"**
2. Click **"Deploy from GitHub repo"**
3. Select your repository: `rushilmahajan-collab/communityapp`
4. Click **"Deploy"**

Railway will:
- Detect `Dockerfile` in `backend/` folder
- Build and deploy automatically
- Takes **2-5 minutes**

### 1.3 Wait for Deployment

You'll see a green checkmark ✅ when deployment succeeds.

### 1.4 Get Your API URL

1. Click on your deployed service
2. Look for **"Domains"** section
3. You'll see: `https://communityapp-xxxx.railway.app`
4. **Copy and save this URL** — you need it later

### 1.5 Set Environment Variables

Railway should auto-create `DATABASE_URL`. Set this manually:

1. In your service, go to **"Variables"** tab
2. Add this variable:

```
JWT_SECRET = my-secret-key-123456
```

That's it! No storage service needed for now.

### 1.6 Test Your Backend

1. Open in browser: `https://communityapp-xxxx.railway.app/health`
2. You should see: `{"status":"ok"}`

**✅ Backend deployed!**

---

## 🎨 STEP 2: Deploy Admin Dashboard to Vercel

### 2.1 Go to Vercel

1. Open https://vercel.com
2. Click **"Sign Up"** or **"Login"**
3. Sign in with **GitHub** (easiest)

### 2.2 Import Your Repository

1. Click **"New Project"**
2. Click **"Import Git Repository"**
3. Select: `rushilmahajan-collab/communityapp`
4. Click **"Import"**

### 2.3 Configure Project Settings

When the import dialog appears:

1. **Framework Preset**: Select **"Other"** (it's static HTML)
2. **Root Directory**: Change to `admin-dashboard`
3. **Leave everything else default**
4. Click **"Deploy"**

Vercel will deploy. Takes **1-2 minutes**.

### 2.4 Get Your Dashboard URL

After deployment completes:
1. You'll see: `https://admin-dashboard-xxxx.vercel.app`
2. **Copy and save this URL**

**✅ Admin dashboard deployed!**

---

## 👤 STEP 3: Create Your First Admin User

You need to create an admin user to sign in to the dashboard.

### Option A: Using cURL (If you have a terminal)

```bash
curl -X POST https://communityapp-xxxx.railway.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "Admin",
    "email": "admin@example.com",
    "password": "YourSecurePassword123!",
    "city": "Denver"
  }'
```

You'll get back a response with a `token` field.

### Option B: Without Terminal (Using Admin Dashboard)

Can't use terminal? You can create the user through the app once it's running:

1. For now, **create a test user** through the iOS app (when built)
2. Or **manually insert** via Railway database console

---

## 🔐 STEP 4: Sign Into Admin Dashboard

### 4.1 Open Dashboard

1. Go to: `https://admin-dashboard-xxxx.vercel.app`
2. You should see login form

### 4.2 Sign In

Enter these credentials:

```
API URL:  https://communityapp-xxxx.railway.app/api
Email:    admin@example.com
Password: YourSecurePassword123!
```

(Use the credentials from Step 3)

### 4.3 You're In! 🎉

You should now see:
- **Verifications** tab
- **Statistics** tab
- **Users** tab
- **Activity Log** tab

---

## 📋 Quick Reference

Save these URLs:

| What | URL |
|------|-----|
| **Railway Dashboard** | https://railway.app |
| **Vercel Dashboard** | https://vercel.com |
| **Your API** | `https://communityapp-xxxx.railway.app/api` |
| **Your Admin Dashboard** | `https://admin-dashboard-xxxx.vercel.app` |
| **Health Check** | `https://communityapp-xxxx.railway.app/health` |

---

## 🔧 Environment Variables Checklist

### On Railway (Backend)

Must be set in Railway Variables:

- ✅ `DATABASE_URL` — Auto-created by Railway
- ✅ `JWT_SECRET` — Set to any random string

### On Vercel (Dashboard)

**No environment variables needed!** The dashboard is pure HTML/JavaScript and connects to your Railway API directly.

---

## 🧪 Test Your Deployment

### Test 1: Backend Health

1. Open in browser: `https://communityapp-xxxx.railway.app/health`
2. Should see: `{"status":"ok"}`

### Test 2: Admin Dashboard

1. Open: `https://admin-dashboard-xxxx.vercel.app`
2. You should see login form
3. Sign in with admin credentials

### Test 3: View Stats

1. After signing in, click **"Statistics"** tab
2. Should show:
   - Total Users: 1 (your admin account)
   - Verified Users: 0 (not verified yet)
   - Groups: 0
   - Messages: 0

**✅ Everything working!**

---

## 🚨 Troubleshooting

### "API connection error"

**Problem**: Dashboard says "Network error" on login

**Solution**:
1. Double-check API URL (includes `/api` at end)
2. Make sure it's the full URL: `https://communityapp-xxxx.railway.app/api`
3. Wait 2 minutes after Railway deployment
4. Check Railway deployment is green ✅

### "Invalid credentials"

**Problem**: Login says email/password wrong

**Solution**:
1. Make sure you created the admin user (Step 3)
2. Check exact email and password
3. If you don't have terminal, manually create user via:
   - Railway database console, or
   - iOS app (once built)

### "Vercel deployment stuck"

**Problem**: Vercel shows "Building..." for too long

**Solution**:
1. Go to Vercel dashboard
2. Click on your project
3. Click **"Redeploy"** button
4. Wait 2-3 minutes

### "Railway deployment failed"

**Problem**: Red ❌ on Railway

**Solution**:
1. Click on your service
2. Go to **"Logs"** tab
3. Read the error message
4. Common issue: Missing environment variables
5. Add them in **"Variables"** tab

---

## 📱 Next Steps After Deployment

### Step 1: Build iOS App

```
Location: /home/user/communityapp/ios/
- Open CommunityApp.xcodeproj in Xcode
- Build and run in simulator
- Test profile creation flow
```

### Step 2: Invite Admins

To add more admin users:

1. Create user account normally
2. In Railway database console:
   - Find user by email
   - Set `is_admin = true`
3. They can now sign into admin dashboard

---

## 🎯 Summary

| Step | Status | URL |
|------|--------|-----|
| 1. Deploy Backend | ✅ | https://railway.app |
| 2. Deploy Dashboard | ✅ | https://vercel.com |
| 3. Create Admin User | ✅ | Manual or via terminal |
| 4. Sign In to Dashboard | ✅ | `admin-dashboard-xxxx.vercel.app` |
| 5. View Statistics | ✅ | See real-time metrics |

**You're now ready to:**
- Review user video verifications
- Manage admin operations
- Monitor platform statistics
- Build and deploy iOS app

---

## 💬 Need Help?

If you get stuck:

1. Check the troubleshooting section above
2. Go to Railway **"Logs"** tab to see what went wrong
3. Go to Vercel **"Build Logs"** to see what went wrong
4. Check all environment variables are set correctly

---

## 📚 Learn More

- **Backend API Docs**: See `backend/ADMIN_API.md`
- **Local Development**: See `backend/LOCAL_SETUP.md`
- **Admin Dashboard Guide**: See `admin-dashboard/README.md`
- **Project README**: See `README.md`

---

**🎉 Congratulations!** Your platform is live on Railway + Vercel!
