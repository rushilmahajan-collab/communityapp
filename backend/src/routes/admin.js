import express from 'express';
import { authenticate } from '../middleware/auth.js';
import knex from 'knex';

const router = express.Router();

const db = knex({
  client: 'pg',
  connection: process.env.DATABASE_URL,
});

// Middleware: Check if user is admin
async function isAdmin(req, res, next) {
  try {
    const user = await db('users').where({ id: req.userId }).first();

    // For now, mark first user as admin (in production, use a proper role system)
    const isFirstUser = await db('users').count('id').first();

    if (!user || (isFirstUser.count > 1 && !user.is_admin)) {
      return res.status(403).json({ error: 'Admin access required' });
    }

    req.user = user;
    next();
  } catch (err) {
    res.status(500).json({ error: 'Auth check failed' });
  }
}

router.use(authenticate);
router.use(isAdmin);

// Get pending video verifications
router.get('/videos/pending', async (req, res) => {
  try {
    const { limit = 20, offset = 0 } = req.query;

    const videos = await db('users')
      .where({ verification_status: 'pending' })
      .whereNotNull('video_verification_url')
      .select(
        'id',
        'first_name',
        'email',
        'city',
        'video_verification_url',
        'created_at',
        'updated_at'
      )
      .orderBy('created_at', 'asc')
      .limit(limit)
      .offset(offset);

    const total = await db('users')
      .where({ verification_status: 'pending' })
      .whereNotNull('video_verification_url')
      .count('id', { as: 'count' })
      .first();

    res.json({
      videos,
      total: total.count,
      limit,
      offset,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch pending videos' });
  }
});

// Approve user verification
router.post('/videos/approve/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { notes } = req.body;

    const user = await db('users').where({ id: userId }).first();
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const [updated] = await db('users')
      .where({ id: userId })
      .update({
        verification_status: 'verified',
        updated_at: db.fn.now(),
      })
      .returning('*');

    // Log the action
    await db('admin_logs').insert({
      admin_id: req.userId,
      action: 'approve_verification',
      user_id: userId,
      notes: notes || null,
      created_at: db.fn.now(),
    }).catch(() => {}); // Ignore if admin_logs table doesn't exist yet

    res.json({
      message: 'User verified',
      user: updated,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to approve verification' });
  }
});

// Reject user verification
router.post('/videos/reject/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { reason } = req.body;

    if (!reason) {
      return res.status(400).json({ error: 'Rejection reason required' });
    }

    const user = await db('users').where({ id: userId }).first();
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const [updated] = await db('users')
      .where({ id: userId })
      .update({
        verification_status: 'rejected',
        updated_at: db.fn.now(),
      })
      .returning('*');

    // Log the action
    await db('admin_logs').insert({
      admin_id: req.userId,
      action: 'reject_verification',
      user_id: userId,
      reason: reason,
      created_at: db.fn.now(),
    }).catch(() => {}); // Ignore if table doesn't exist

    res.json({
      message: 'Verification rejected',
      user: updated,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to reject verification' });
  }
});

// Get admin dashboard stats
router.get('/stats', async (req, res) => {
  try {
    // Total users
    const totalUsers = await db('users')
      .count('id', { as: 'count' })
      .first();

    // Verified users
    const verifiedUsers = await db('users')
      .where({ verification_status: 'verified' })
      .count('id', { as: 'count' })
      .first();

    // Pending verifications
    const pendingVerifications = await db('users')
      .where({ verification_status: 'pending' })
      .whereNotNull('video_verification_url')
      .count('id', { as: 'count' })
      .first();

    // Rejected verifications
    const rejectedVerifications = await db('users')
      .where({ verification_status: 'rejected' })
      .count('id', { as: 'count' })
      .first();

    // Total groups
    const totalGroups = await db('groups')
      .count('id', { as: 'count' })
      .first();

    // Groups by city (top 10)
    const groupsByCity = await db('groups')
      .select('city')
      .count('id', { as: 'count' })
      .groupBy('city')
      .orderBy('count', 'desc')
      .limit(10);

    // Users by city (top 10)
    const usersByCity = await db('users')
      .select('city')
      .count('id', { as: 'count' })
      .groupBy('city')
      .orderBy('count', 'desc')
      .limit(10);

    // Total messages
    const totalMessages = await db('group_messages')
      .count('id', { as: 'count' })
      .first();

    // Total hangouts
    const totalHangouts = await db('hangouts')
      .count('id', { as: 'count' })
      .first();

    // Completed hangouts
    const completedHangouts = await db('hangouts')
      .where({ status: 'completed' })
      .count('id', { as: 'count' })
      .first();

    // Users joined this week
    const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const usersThisWeek = await db('users')
      .where('created_at', '>=', weekAgo)
      .count('id', { as: 'count' })
      .first();

    // Verification completion rate
    const verificationRate = totalUsers.count > 0
      ? Math.round((verifiedUsers.count / totalUsers.count) * 100)
      : 0;

    res.json({
      users: {
        total: totalUsers.count,
        verified: verifiedUsers.count,
        pending: pendingVerifications.count,
        rejected: rejectedVerifications.count,
        joinedThisWeek: usersThisWeek.count,
        verificationRate: `${verificationRate}%`,
      },
      groups: {
        total: totalGroups.count,
        byCity: groupsByCity,
      },
      locations: {
        byCity: usersByCity,
      },
      messaging: {
        totalMessages: totalMessages.count,
      },
      hangouts: {
        total: totalHangouts.count,
        completed: completedHangouts.count,
      },
      timestamp: new Date().toISOString(),
    });
  } catch (err) {
    console.error('Stats error:', err);
    res.status(500).json({ error: 'Failed to fetch stats' });
  }
});

// Get user details (admin view)
router.get('/users/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

    const user = await db('users').where({ id: userId }).first();
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const groups = await db('group_members')
      .join('groups', 'group_members.group_id', 'groups.id')
      .where({ user_id: userId })
      .select('groups.id', 'groups.name', 'group_members.status')
      .count('id', { as: 'memberCount' });

    const messages = await db('group_messages')
      .where({ user_id: userId })
      .count('id', { as: 'count' })
      .first();

    res.json({
      user,
      groups,
      activityStats: {
        messages: messages.count,
        groupsJoined: groups.length,
      },
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch user details' });
  }
});

// Flag user for review
router.post('/users/:userId/flag', async (req, res) => {
  try {
    const { userId } = req.params;
    const { reason, severity } = req.body;

    if (!reason || !['low', 'medium', 'high'].includes(severity)) {
      return res.status(400).json({ error: 'Invalid flag data' });
    }

    // Log the flag
    await db('admin_logs').insert({
      admin_id: req.userId,
      action: 'flag_user',
      user_id: userId,
      severity,
      reason,
      created_at: db.fn.now(),
    }).catch(() => {}); // Ignore if table doesn't exist

    res.json({
      message: 'User flagged for review',
      flagged: true,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to flag user' });
  }
});

// Get admin action logs
router.get('/logs', async (req, res) => {
  try {
    const { limit = 50, offset = 0 } = req.query;

    const logs = await db('admin_logs')
      .select('*')
      .orderBy('created_at', 'desc')
      .limit(limit)
      .offset(offset)
      .catch(() => []); // Table might not exist yet

    res.json({
      logs,
      limit,
      offset,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch logs' });
  }
});

export default router;
