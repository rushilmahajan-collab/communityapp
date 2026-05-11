import express from 'express';
import { authenticate } from '../middleware/auth.js';
import knex from 'knex';

const router = express.Router();

const db = knex({
  client: 'pg',
  connection: process.env.DATABASE_URL,
});

router.get('/:id/messages', authenticate, async (req, res) => {
  try {
    const { id } = req.params;
    const { limit = 50, offset = 0 } = req.query;

    const messages = await db('group_messages')
      .join('users', 'group_messages.user_id', 'users.id')
      .where({ group_id: id })
      .select(
        'group_messages.id',
        'group_messages.message_text',
        'group_messages.sent_at',
        'users.first_name',
        'users.profile_photo_url'
      )
      .orderBy('group_messages.sent_at', 'desc')
      .limit(limit)
      .offset(offset);

    res.json(messages);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch messages' });
  }
});

router.post('/:id/messages', authenticate, async (req, res) => {
  try {
    const { id } = req.params;
    const { message_text } = req.body;

    if (!message_text || message_text.trim().length === 0) {
      return res.status(400).json({ error: 'Message cannot be empty' });
    }

    const group = await db('groups').where({ id }).first();
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    const isMember = await db('group_members')
      .where({ group_id: id, user_id: req.userId, status: 'active' })
      .first();

    if (!isMember) {
      return res.status(403).json({ error: 'You must be a group member to send messages' });
    }

    const [message] = await db('group_messages')
      .insert({
        group_id: id,
        user_id: req.userId,
        message_text,
      })
      .returning('*');

    res.status(201).json(message);
  } catch (err) {
    res.status(500).json({ error: 'Failed to send message' });
  }
});

export default router;
