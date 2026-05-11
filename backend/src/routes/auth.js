import express from 'express';
import Joi from 'joi';
import { hashPassword, comparePassword, generateToken } from '../utils/auth.js';
import { authenticate } from '../middleware/auth.js';
import knex from 'knex';

const router = express.Router();

const db = knex({
  client: 'pg',
  connection: process.env.DATABASE_URL,
});

const registerSchema = Joi.object({
  first_name: Joi.string().required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(8).required(),
  city: Joi.string().required(),
});

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

router.post('/register', async (req, res) => {
  try {
    const { error, value } = registerSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const existingUser = await db('users').where({ email: value.email }).first();
    if (existingUser) {
      return res.status(409).json({ error: 'Email already registered' });
    }

    const passwordHash = await hashPassword(value.password);

    const [user] = await db('users')
      .insert({
        first_name: value.first_name,
        email: value.email,
        password_hash: passwordHash,
        city: value.city,
        latitude: 0,
        longitude: 0,
      })
      .returning('*');

    const token = generateToken(user.id);

    res.status(201).json({
      user: {
        id: user.id,
        first_name: user.first_name,
        email: user.email,
        city: user.city,
      },
      token,
    });
  } catch (err) {
    res.status(500).json({ error: 'Registration failed' });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { error, value } = loginSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const user = await db('users').where({ email: value.email }).first();
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const passwordMatch = await comparePassword(value.password, user.password_hash);
    if (!passwordMatch) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = generateToken(user.id);

    res.json({
      user: {
        id: user.id,
        first_name: user.first_name,
        email: user.email,
        city: user.city,
      },
      token,
    });
  } catch (err) {
    res.status(500).json({ error: 'Login failed' });
  }
});

router.get('/me', authenticate, async (req, res) => {
  try {
    const user = await db('users').where({ id: req.userId }).first();
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({
      id: user.id,
      first_name: user.first_name,
      email: user.email,
      city: user.city,
      neighborhood: user.neighborhood,
      profile_photo_url: user.profile_photo_url,
      latitude: user.latitude,
      longitude: user.longitude,
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch user' });
  }
});

export default router;
