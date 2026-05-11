import express from 'express';
import { authenticate } from '../middleware/auth.js';
import knex from 'knex';

const router = express.Router();

const db = knex({
  client: 'pg',
  connection: process.env.DATABASE_URL,
});

router.get('/:id/hangouts', authenticate, async (req, res) => {
  try {
    const { id } = req.params;

    const hangouts = await db('hangouts')
      .where({ group_id: id })
      .orderBy('date', 'desc');

    const hangoutsWithCheckins = await Promise.all(
      hangouts.map(async (hangout) => {
        const checkins = await db('checkins')
          .where({ hangout_id: hangout.id })
          .count('id', { as: 'count' })
          .first();

        return {
          ...hangout,
          checkin_count: checkins.count,
        };
      })
    );

    res.json(hangoutsWithCheckins);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch hangouts' });
  }
});

router.post('/:id/hangouts', authenticate, async (req, res) => {
  try {
    const { id } = req.params;
    const {
      date,
      time,
      location_name,
      location_address,
      suggested_prompts,
    } = req.body;

    const group = await db('groups').where({ id }).first();
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    const isMember = await db('group_members')
      .where({ group_id: id, user_id: req.userId, status: 'active' })
      .first();

    if (!isMember) {
      return res.status(403).json({ error: 'You must be a group member to schedule hangouts' });
    }

    const [hangout] = await db('hangouts')
      .insert({
        group_id: id,
        date,
        time,
        location_name,
        location_address,
        suggested_prompts,
      })
      .returning('*');

    res.status(201).json(hangout);
  } catch (err) {
    res.status(500).json({ error: 'Failed to schedule hangout' });
  }
});

router.post('/:id/checkin', authenticate, async (req, res) => {
  try {
    const { id } = req.params;
    const { attended, reflection } = req.body;

    const hangout = await db('hangouts').where({ id }).first();
    if (!hangout) {
      return res.status(404).json({ error: 'Hangout not found' });
    }

    const [checkin] = await db('checkins')
      .insert({
        hangout_id: id,
        user_id: req.userId,
        attended,
        reflection,
      })
      .returning('*');

    res.status(201).json(checkin);
  } catch (err) {
    res.status(500).json({ error: 'Failed to record checkin' });
  }
});

export default router;
