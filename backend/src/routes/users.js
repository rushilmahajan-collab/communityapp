import express from 'express';
import { authenticate } from '../middleware/auth.js';
import knex from 'knex';

const router = express.Router();

const db = knex({
  client: 'pg',
  connection: process.env.DATABASE_URL,
});

router.put('/profile', authenticate, async (req, res) => {
  try {
    const { neighborhood, latitude, longitude, profile_photo_url } = req.body;

    const [user] = await db('users')
      .where({ id: req.userId })
      .update({
        neighborhood,
        latitude,
        longitude,
        profile_photo_url,
        updated_at: db.fn.now(),
      })
      .returning('*');

    res.json({
      id: user.id,
      first_name: user.first_name,
      city: user.city,
      neighborhood: user.neighborhood,
      profile_photo_url: user.profile_photo_url,
      verification_status: user.verification_status,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

router.post('/verify', authenticate, async (req, res) => {
  try {
    const { video_verification_url } = req.body;

    const [user] = await db('users')
      .where({ id: req.userId })
      .update({
        video_verification_url,
        verification_status: 'pending',
        updated_at: db.fn.now(),
      })
      .returning('*');

    res.json({
      id: user.id,
      verification_status: user.verification_status,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to upload verification video' });
  }
});

router.post('/quiz', authenticate, async (req, res) => {
  try {
    const { responses } = req.body;

    const [user] = await db('users')
      .where({ id: req.userId })
      .update({
        quiz_responses: responses,
        updated_at: db.fn.now(),
      })
      .returning('*');

    res.json({
      id: user.id,
      quiz_responses: user.quiz_responses,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to save quiz responses' });
  }
});

export default router;
