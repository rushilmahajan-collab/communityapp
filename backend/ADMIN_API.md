# Admin Dashboard API

Admin endpoints for managing user verifications, reviewing videos, viewing stats, and monitoring activity.

**All admin endpoints require:**
- Authentication token (Bearer token)
- Admin role (first user created is automatically admin)

## Base URL

```
http://localhost:3000/api/admin
```

## Authentication

All requests must include:

```
Authorization: Bearer <jwt_token>
```

---

## Video Verification Management

### Get Pending Video Verifications

Get all pending user video verifications in order (oldest first).

```http
GET /admin/videos/pending?limit=20&offset=0
Authorization: Bearer <token>
```

**Response:**

```json
{
  "videos": [
    {
      "id": "uuid",
      "first_name": "John",
      "email": "john@example.com",
      "city": "Denver",
      "video_verification_url": "https://s3.example.com/video.mp4",
      "created_at": "2025-05-11T10:30:00Z",
      "updated_at": "2025-05-11T10:30:00Z"
    }
  ],
  "total": 42,
  "limit": 20,
  "offset": 0
}
```

### Approve User Verification

Mark a user as verified after reviewing their video.

```http
POST /admin/videos/approve/:userId
Authorization: Bearer <token>
Content-Type: application/json

{
  "notes": "Video review passed - clearly shows person saying required word"
}
```

**Response:**

```json
{
  "message": "User verified",
  "user": {
    "id": "uuid",
    "first_name": "John",
    "email": "john@example.com",
    "verification_status": "verified",
    "updated_at": "2025-05-11T10:35:00Z"
  }
}
```

### Reject User Verification

Reject a user's video verification with a reason.

```http
POST /admin/videos/reject/:userId
Authorization: Bearer <token>
Content-Type: application/json

{
  "reason": "Face not clearly visible in video - please resubmit"
}
```

**Response:**

```json
{
  "message": "Verification rejected",
  "user": {
    "id": "uuid",
    "first_name": "John",
    "email": "john@example.com",
    "verification_status": "rejected",
    "updated_at": "2025-05-11T10:35:00Z"
  }
}
```

---

## Admin Dashboard Stats

### Get Dashboard Statistics

Get comprehensive stats about users, groups, engagement, and more.

```http
GET /admin/stats
Authorization: Bearer <token>
```

**Response:**

```json
{
  "users": {
    "total": 247,
    "verified": 189,
    "pending": 42,
    "rejected": 16,
    "joinedThisWeek": 23,
    "verificationRate": "76%"
  },
  "groups": {
    "total": 31,
    "byCity": [
      { "city": "Denver", "count": 8 },
      { "city": "Boulder", "count": 5 },
      { "city": "Fort Collins", "count": 4 }
    ]
  },
  "locations": {
    "byCity": [
      { "city": "Denver", "count": 142 },
      { "city": "Boulder", "count": 67 },
      { "city": "Fort Collins", "count": 38 }
    ]
  },
  "messaging": {
    "totalMessages": 1247
  },
  "hangouts": {
    "total": 156,
    "completed": 142
  },
  "timestamp": "2025-05-11T10:40:00Z"
}
```

---

## User Management

### Get User Details (Admin View)

Get detailed information about a specific user including activity and groups.

```http
GET /admin/users/:userId
Authorization: Bearer <token>
```

**Response:**

```json
{
  "user": {
    "id": "uuid",
    "first_name": "John",
    "email": "john@example.com",
    "city": "Denver",
    "verification_status": "verified",
    "created_at": "2025-05-01T12:00:00Z"
  },
  "groups": [
    {
      "id": "group-uuid",
      "name": "Downtown Coffee Crew",
      "status": "active"
    }
  ],
  "activityStats": {
    "messages": 23,
    "groupsJoined": 2
  }
}
```

### Flag User for Review

Flag a user for manual review (e.g., suspicious activity, complaints).

```http
POST /admin/users/:userId/flag
Authorization: Bearer <token>
Content-Type: application/json

{
  "severity": "medium",
  "reason": "Multiple complaints about inappropriate messages in group chat"
}
```

**Severity levels:**
- `low` — Minor issue, monitor
- `medium` — Needs review
- `high` — Urgent, potential safety concern

**Response:**

```json
{
  "message": "User flagged for review",
  "flagged": true
}
```

---

## Activity Logs

### Get Admin Action Logs

View all admin actions (approvals, rejections, flags) for audit trail.

```http
GET /admin/logs?limit=50&offset=0
Authorization: Bearer <token>
```

**Response:**

```json
{
  "logs": [
    {
      "id": "uuid",
      "admin_id": "admin-uuid",
      "action": "approve_verification",
      "user_id": "user-uuid",
      "notes": "Video review passed",
      "created_at": "2025-05-11T10:35:00Z"
    },
    {
      "id": "uuid",
      "admin_id": "admin-uuid",
      "action": "reject_verification",
      "user_id": "user-uuid",
      "reason": "Face not clearly visible",
      "created_at": "2025-05-11T10:25:00Z"
    },
    {
      "id": "uuid",
      "admin_id": "admin-uuid",
      "action": "flag_user",
      "user_id": "user-uuid",
      "severity": "medium",
      "reason": "Suspicious activity",
      "created_at": "2025-05-11T10:15:00Z"
    }
  ],
  "limit": 50,
  "offset": 0
}
```

---

## Admin Workflow

### Daily Verification Review

1. **Check pending verifications**
   ```bash
   curl http://localhost:3000/api/admin/videos/pending \
     -H "Authorization: Bearer <token>"
   ```

2. **Review video** (external process)
   - Watch the video
   - Verify the person is real and says the required word

3. **Approve or reject**
   ```bash
   # Approve
   curl -X POST http://localhost:3000/api/admin/videos/approve/<userId> \
     -H "Authorization: Bearer <token>" \
     -H "Content-Type: application/json" \
     -d '{"notes": "Verified"}'

   # Or reject
   curl -X POST http://localhost:3000/api/admin/videos/reject/<userId> \
     -H "Authorization: Bearer <token>" \
     -H "Content-Type: application/json" \
     -d '{"reason": "Face not visible"}'
   ```

4. **Check dashboard stats**
   ```bash
   curl http://localhost:3000/api/admin/stats \
     -H "Authorization: Bearer <token>"
   ```

---

## Creating an Admin Web Dashboard

The admin API is designed to power a web-based admin dashboard. Here's what you might build:

### Dashboard Views

1. **Verification Queue**
   - Video thumbnail and player
   - User name and email
   - Approve/Reject buttons
   - Notes field
   - Shows oldest submissions first

2. **Statistics**
   - Key metrics (total users, verified %, groups)
   - Charts for users by city, group distribution
   - Engagement metrics (messages, hangouts)

3. **User Management**
   - Search/filter users
   - View detailed user profile
   - See user's group memberships and activity
   - Flag suspicious users

4. **Activity Log**
   - Audit trail of all admin actions
   - Filter by action type, date, admin
   - Search by user ID

---

## Error Codes

| Code | Meaning |
|------|---------|
| 401 | Not authenticated |
| 403 | Not an admin |
| 404 | User or resource not found |
| 400 | Invalid request data |
| 500 | Server error |

---

## Rate Limiting

Admin endpoints are not rate-limited (different from public API). This allows batch operations.

---

## Notes

- **First user created** is automatically admin
- **Admin logs** track all verification decisions for audit trail
- **Flags** appear in logs but don't automatically restrict user access
- **Stats** are calculated on-the-fly for real-time data
- All timestamps are in UTC ISO 8601 format
