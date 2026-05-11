# Local Backend Development Setup

This guide helps you set up and test the Community App backend locally.

## Prerequisites

- **Node.js** 18+ (check with `node --version`)
- **PostgreSQL** 12+ (check with `psql --version`)
- **npm** or yarn

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up PostgreSQL Database

**On macOS (with Homebrew):**
```bash
brew install postgresql
brew services start postgresql
createdb communityapp_dev
```

**On Linux (Ubuntu/Debian):**
```bash
sudo apt-get install postgresql postgresql-contrib
sudo service postgresql start
sudo -u postgres createdb communityapp_dev
```

**On Windows:**
- Download from https://www.postgresql.org/download/windows/
- During installation, set password for `postgres` user
- Run psql and create database:
  ```sql
  CREATE DATABASE communityapp_dev;
  ```

### 3. Run Database Migrations

```bash
npm run migrate
```

This creates all the necessary tables:
- `users`
- `groups`
- `group_members`
- `group_messages`
- `hangouts`
- `checkins`

### 4. Start the Dev Server

```bash
npm run dev
```

The server will start on `http://localhost:3000`

You should see:
```
Community App API running on port 3000
```

### 5. Test the Profile Creation Flow

In a **new terminal** (keep the dev server running):

```bash
node test-profile-flow.js
```

This tests:
1. ✅ User registration
2. ✅ Get current user
3. ✅ Update profile
4. ✅ Submit quiz responses
5. ✅ User login

## API Endpoints

### Authentication

```bash
# Register
POST /api/auth/register
{
  "first_name": "John",
  "email": "john@example.com",
  "password": "password123",
  "city": "Denver"
}

# Login
POST /api/auth/login
{
  "email": "john@example.com",
  "password": "password123"
}

# Get current user
GET /api/auth/me
Headers: Authorization: Bearer <token>
```

### Profile

```bash
# Update profile
PUT /api/users/profile
Headers: Authorization: Bearer <token>
{
  "neighborhood": "Downtown",
  "latitude": 39.7392,
  "longitude": -104.9903,
  "profile_photo_url": "https://example.com/photo.jpg"
}

# Submit quiz
POST /api/users/quiz
Headers: Authorization: Bearer <token>
{
  "responses": {
    "q1": "answer1",
    "q2": "answer2",
    ...
  }
}

# Upload verification video
POST /api/users/verify
Headers: Authorization: Bearer <token>
{
  "video_verification_url": "https://s3.example.com/video.mp4"
}
```

## Environment Variables

Copy `.env.example` to `.env.local`:

```bash
cp .env.example .env.local
```

Edit `.env.local` with your settings:

```env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/communityapp_dev
JWT_SECRET=your-secret-key-here
AWS_ACCESS_KEY_ID=your-aws-key
AWS_SECRET_ACCESS_KEY=your-aws-secret
S3_BUCKET_NAME=your-bucket-name
AWS_REGION=us-east-1
```

## Troubleshooting

### "Could not connect to the database"

```bash
# Check if PostgreSQL is running
psql -U postgres -c "\l"

# If not running:
# macOS: brew services start postgresql
# Linux: sudo service postgresql start
# Windows: Services → PostgreSQL
```

### "Database does not exist"

```bash
# Create it
createdb communityapp_dev

# Or via psql
psql -U postgres -c "CREATE DATABASE communityapp_dev;"
```

### "Relation 'users' does not exist"

Migrations haven't run. Fix with:

```bash
npm run migrate
```

### Port 3000 already in use

Either:
1. Kill the process using port 3000
2. Or set a different port: `PORT=4000 npm run dev`

## Testing Groups Endpoint

Once profiles are working, test group creation:

```bash
# Create a group
curl -X POST http://localhost:3000/api/groups \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Coffee Crew",
    "description": "Weekly coffee meetups",
    "city": "Denver",
    "neighborhood": "Downtown",
    "latitude": 39.7392,
    "longitude": -104.9903,
    "meeting_day": "Thursday",
    "meeting_time": "6:00 PM",
    "meeting_location_name": "Corvus Coffee",
    "meeting_location_address": "123 Main St",
    "max_members": 10
  }'
```

## Next Steps

1. ✅ Test profile creation (run `node test-profile-flow.js`)
2. ⏭️ Test group creation and discovery
3. ⏭️ Test messaging endpoints
4. ⏭️ Deploy to Railway

## Need Help?

Check the error logs in the terminal where you ran `npm run dev`.

Most issues are database-related. Make sure:
- PostgreSQL is running
- Database `communityapp_dev` exists
- Migrations have been run with `npm run migrate`
