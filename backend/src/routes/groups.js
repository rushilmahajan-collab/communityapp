import express from 'express';
import { authenticate } from '../middleware/auth.js';
import knex from 'knex';

const router = express.Router();

const db = knex({
  client: 'pg',
  connection: process.env.DATABASE_URL,
});

router.get('/nearby', authenticate, async (req, res) => {
  try {
    const { lat, lng, radius = 10 } = req.query;

    if (!lat || !lng) {
      return res.status(400).json({ error: 'Missing latitude or longitude' });
    }

    const groups = await db('groups')
      .select('groups.*')
      .select(
        db.raw(
          `ST_DistanceSphere(
            ST_MakePoint(?, ?),
            ST_MakePoint(longitude, latitude)
          ) / 1609.34 as distance`,
          [lng, lat]
        )
      )
      .whereRaw(
        `ST_DistanceSphere(
          ST_MakePoint(?, ?),
          ST_MakePoint(longitude, latitude)
        ) / 1609.34 <= ?`,
        [lng, lat, radius]
      )
      .orderBy('distance');

    const groupsWithMembers = await Promise.all(
      groups.map(async (group) => {
        const memberCount = await db('group_members')
          .where({ group_id: group.id, status: 'active' })
          .count('id', { as: 'count' })
          .first();

        return {
          ...group,
          member_count: memberCount.count,
        };
      })
    );

    res.json(groupsWithMembers);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch nearby groups' });
  }
});

router.get('/:id', authenticate, async (req, res) => {
  try {
    const { id } = req.params;

    const group = await db('groups').where({ id }).first();
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    const members = await db('group_members')
      .join('users', 'group_members.user_id', 'users.id')
      .where({ group_id: id, status: 'active' })
      .select('users.id', 'users.first_name', 'users.profile_photo_url');

    res.json({
      ...group,
      members,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch group' });
  }
});

router.post('/', authenticate, async (req, res) => {
  try {
    const {
      name,
      description,
      city,
      neighborhood,
      latitude,
      longitude,
      meeting_day,
      meeting_time,
      meeting_location_name,
      meeting_location_address,
      max_members,
    } = req.body;

    const [group] = await db('groups')
      .insert({
        name,
        description,
        city,
        neighborhood,
        latitude,
        longitude,
        meeting_day,
        meeting_time,
        meeting_location_name,
        meeting_location_address,
        max_members,
        created_by: req.userId,
      })
      .returning('*');

    await db('group_members').insert({
      group_id: group.id,
      user_id: req.userId,
      status: 'active',
    });

    res.status(201).json(group);
  } catch (err) {
    res.status(500).json({ error: 'Failed to create group' });
  }
});

router.post('/:id/join', authenticate, async (req, res) => {
  try {
    const { id } = req.params;

    const group = await db('groups').where({ id }).first();
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    const existing = await db('group_members')
      .where({ group_id: id, user_id: req.userId })
      .first();

    if (existing) {
      return res.status(409).json({ error: 'Already a member or has pending request' });
    }

    const [member] = await db('group_members')
      .insert({
        group_id: id,
        user_id: req.userId,
        status: 'requested',
      })
      .returning('*');

    res.status(201).json(member);
  } catch (err) {
    res.status(500).json({ error: 'Failed to join group' });
  }
});

router.post('/:id/approve/:userId', authenticate, async (req, res) => {
  try {
    const { id, userId } = req.params;

    const group = await db('groups').where({ id }).first();
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }

    if (group.created_by !== req.userId) {
      return res.status(403).json({ error: 'Only group creator can approve members' });
    }

    const [member] = await db('group_members')
      .where({ group_id: id, user_id: userId })
      .update({ status: 'active' })
      .returning('*');

    res.json(member);
  } catch (err) {
    res.status(500).json({ error: 'Failed to approve member' });
  }
});

router.delete('/:id/leave', authenticate, async (req, res) => {
  try {
    const { id } = req.params;

    await db('group_members')
      .where({ group_id: id, user_id: req.userId })
      .delete();

    res.json({ message: 'Left group successfully' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to leave group' });
  }
});

export default router;
