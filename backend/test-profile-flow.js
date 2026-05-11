#!/usr/bin/env node

/**
 * Test script for the profile creation flow
 *
 * This tests:
 * 1. User registration
 * 2. User login
 * 3. Profile update
 * 4. Get current user
 *
 * Run with: node test-profile-flow.js
 */

const BASE_URL = 'http://localhost:3000/api';

let authToken = '';

async function makeRequest(method, endpoint, body = null) {
  const options = {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(authToken && { Authorization: `Bearer ${authToken}` }),
    },
  };

  if (body) {
    options.body = JSON.stringify(body);
  }

  try {
    const response = await fetch(`${BASE_URL}${endpoint}`, options);
    const data = await response.json();

    return {
      status: response.status,
      ok: response.ok,
      data,
    };
  } catch (error) {
    return {
      status: 0,
      ok: false,
      error: error.message,
    };
  }
}

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function testProfileFlow() {
  console.log('🧪 Testing Community App Backend - Profile Creation Flow\n');
  console.log('⚠️  Make sure:');
  console.log('   1. PostgreSQL is running');
  console.log('   2. Backend server is running (npm run dev)');
  console.log('   3. Database migrations have been run (npm run migrate)\n');

  // Test 1: Register a new user
  console.log('TEST 1: Register new user');
  console.log('─'.repeat(50));
  const registerRes = await makeRequest('POST', '/auth/register', {
    first_name: 'John',
    email: 'john@example.com',
    password: 'password123',
    city: 'Denver',
  });

  if (!registerRes.ok) {
    console.log('❌ FAILED:', registerRes.data?.error || 'Unknown error');
    console.log('Response:', registerRes.data);
    return;
  }

  console.log('✅ PASSED');
  console.log('User created:', {
    id: registerRes.data.user.id,
    firstName: registerRes.data.user.first_name,
    email: registerRes.data.user.email,
    city: registerRes.data.user.city,
  });

  authToken = registerRes.data.token;
  const userId = registerRes.data.user.id;
  console.log('Token received:', authToken.substring(0, 20) + '...\n');

  // Test 2: Get current user
  console.log('TEST 2: Get current user (authenticated)');
  console.log('─'.repeat(50));
  const meRes = await makeRequest('GET', '/auth/me');

  if (!meRes.ok) {
    console.log('❌ FAILED:', meRes.data?.error);
    console.log('Response:', meRes.data);
    return;
  }

  console.log('✅ PASSED');
  console.log('Current user:', {
    id: meRes.data.id,
    firstName: meRes.data.first_name,
    email: meRes.data.email,
    city: meRes.data.city,
    verificationStatus: meRes.data.verification_status,
  });
  console.log();

  // Test 3: Update user profile
  console.log('TEST 3: Update user profile');
  console.log('─'.repeat(50));
  const updateRes = await makeRequest('PUT', '/users/profile', {
    neighborhood: 'Downtown',
    latitude: 39.7392,
    longitude: -104.9903,
    profile_photo_url: 'https://example.com/photo.jpg',
  });

  if (!updateRes.ok) {
    console.log('❌ FAILED:', updateRes.data?.error);
    console.log('Response:', updateRes.data);
    return;
  }

  console.log('✅ PASSED');
  console.log('Profile updated:', {
    id: updateRes.data.id,
    firstName: updateRes.data.first_name,
    city: updateRes.data.city,
    neighborhood: updateRes.data.neighborhood,
    profilePhotoUrl: updateRes.data.profile_photo_url,
  });
  console.log();

  // Test 4: Submit quiz responses
  console.log('TEST 4: Submit quiz responses');
  console.log('─'.repeat(50));
  const quizRes = await makeRequest('POST', '/users/quiz', {
    responses: {
      q1: 'I want to meet new people',
      q2: 'Real connection and growth',
      q3: 'Someone to be real with',
      q4: 'Hiking and coffee',
      q5: 'Technology and community',
      q6: 'Yes, new to the city',
      q7: 'Weekly',
      q8: 'Evenings',
      q9: 'I am thoughtful and curious',
      q10: 'Showing up means being present',
    },
  });

  if (!quizRes.ok) {
    console.log('❌ FAILED:', quizRes.data?.error);
    console.log('Response:', quizRes.data);
    return;
  }

  console.log('✅ PASSED');
  console.log('Quiz responses saved\n');

  // Test 5: Verify current user again
  console.log('TEST 5: Get current user (verify updates)');
  console.log('─'.repeat(50));
  const verifyRes = await makeRequest('GET', '/auth/me');

  if (!verifyRes.ok) {
    console.log('❌ FAILED:', verifyRes.data?.error);
    return;
  }

  console.log('✅ PASSED');
  console.log('Final user profile:', {
    firstName: verifyRes.data.first_name,
    email: verifyRes.data.email,
    city: verifyRes.data.city,
    neighborhood: verifyRes.data.neighborhood,
    profilePhotoUrl: verifyRes.data.profile_photo_url,
    verificationStatus: verifyRes.data.verification_status,
  });
  console.log();

  // Test 6: Login with same credentials
  console.log('TEST 6: Login with registered credentials');
  console.log('─'.repeat(50));
  const loginRes = await makeRequest('POST', '/auth/login', {
    email: 'john@example.com',
    password: 'password123',
  });

  if (!loginRes.ok) {
    console.log('❌ FAILED:', loginRes.data?.error);
    console.log('Response:', loginRes.data);
    return;
  }

  console.log('✅ PASSED');
  console.log('Login successful:', {
    firstName: loginRes.data.user.first_name,
    email: loginRes.data.user.email,
    verificationStatus: loginRes.data.user.verification_status,
  });
  console.log('New token received:', loginRes.data.token.substring(0, 20) + '...\n');

  console.log('═'.repeat(50));
  console.log('✅ ALL TESTS PASSED!');
  console.log('═'.repeat(50));
  console.log('\nProfile creation flow is working correctly.\n');
}

testProfileFlow().catch(console.error);
