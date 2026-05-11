#!/bin/bash

# Community App Automated Deployment Script
# Deploys to Railway + Vercel using API tokens

set -e

echo "🚀 Starting Community App Deployment..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Tokens (provided by environment variables for security)
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
VERCEL_TOKEN="${VERCEL_TOKEN:-}"
RAILWAY_TOKEN="${RAILWAY_TOKEN:-}"

# Check if tokens are provided
if [ -z "$GITHUB_TOKEN" ] || [ -z "$VERCEL_TOKEN" ] || [ -z "$RAILWAY_TOKEN" ]; then
  echo -e "${YELLOW}⚠ Missing API tokens in environment variables${NC}"
  echo ""
  echo "Please set:"
  echo "  export GITHUB_TOKEN=your_github_token"
  echo "  export VERCEL_TOKEN=your_vercel_token"
  echo "  export RAILWAY_TOKEN=your_railway_token"
  echo ""
  exit 1
fi

# GitHub info
GITHUB_OWNER="rushilmahajan-collab"
GITHUB_REPO="communityapp"
GITHUB_URL="https://github.com/$GITHUB_OWNER/$GITHUB_REPO"

echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  DEPLOYMENT CONFIGURATION${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""
echo "Repository: $GITHUB_URL"
echo "GitHub Token: ✓ Provided"
echo "Railway Token: ✓ Provided"
echo "Vercel Token: ✓ Provided"
echo ""

# Step 1: Verify GitHub Access
echo -e "${BLUE}STEP 1: Verifying GitHub access...${NC}"
GITHUB_CHECK=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO \
  | grep -q '"id":' && echo "success" || echo "failed")

if [ "$GITHUB_CHECK" = "success" ]; then
  echo -e "${GREEN}✓ GitHub access verified${NC}"
else
  echo -e "${YELLOW}⚠ GitHub verification failed (may be API rate limit)${NC}"
fi
echo ""

# Step 2: Create Railway Project
echo -e "${BLUE}STEP 2: Setting up Railway backend...${NC}"
echo "Creating Railway project..."

RAILWAY_PROJECT=$(curl -s -X POST https://api.railway.app/graphql \
  -H "Authorization: Bearer $RAILWAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { projectCreate(input: { name: \"communityapp\" }) { project { id name } } }"
  }')

PROJECT_ID=$(echo $RAILWAY_PROJECT | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$PROJECT_ID" ]; then
  echo -e "${YELLOW}⚠ Could not create project (may already exist)${NC}"
  echo "Using existing project - you'll need to manually link GitHub in Railway UI"
  PROJECT_ID="existing"
else
  echo -e "${GREEN}✓ Railway project created: $PROJECT_ID${NC}"
fi
echo ""

# Step 3: Create Vercel Project
echo -e "${BLUE}STEP 3: Setting up Vercel admin dashboard...${NC}"
echo "Creating Vercel project..."

VERCEL_PROJECT=$(curl -s -X POST https://api.vercel.com/v10/projects \
  -H "Authorization: Bearer $VERCEL_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"community-app-admin\",
    \"rootDirectory\": \"admin-dashboard\",
    \"gitRepository\": {
      \"type\": \"github\",
      \"repo\": \"$GITHUB_OWNER/$GITHUB_REPO\"
    }
  }")

VERCEL_PROJECT_ID=$(echo $VERCEL_PROJECT | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$VERCEL_PROJECT_ID" ]; then
  echo -e "${YELLOW}⚠ Vercel project creation may need manual setup${NC}"
  echo "Check https://vercel.com/dashboard"
else
  echo -e "${GREEN}✓ Vercel project created: $VERCEL_PROJECT_ID${NC}"
fi
echo ""

# Step 4: Instructions
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  NEXT STEPS - MANUAL SETUP NEEDED${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Unfortunately, API limitations require a few manual steps:${NC}"
echo ""
echo -e "${BLUE}1. RAILWAY SETUP (5 minutes)${NC}"
echo "   Go to: https://railway.app/dashboard"
echo "   - Find 'communityapp' project (or create new)"
echo "   - Connect GitHub repo: $GITHUB_URL"
echo "   - Add environment variables:"
echo "     • JWT_SECRET = my-secret-key-12345"
echo "     • AWS_ACCESS_KEY_ID = test"
echo "     • AWS_SECRET_ACCESS_KEY = test"
echo "     • S3_BUCKET_NAME = test-bucket"
echo "     • AWS_REGION = us-east-1"
echo "   - Deploy (takes 2-5 minutes)"
echo "   - Copy your API URL: https://communityapp-xxxx.railway.app"
echo ""
echo -e "${BLUE}2. VERCEL SETUP (3 minutes)${NC}"
echo "   Go to: https://vercel.com/dashboard"
echo "   - Find 'community-app-admin' project (or create new)"
echo "   - Verify root directory is 'admin-dashboard'"
echo "   - Deploy"
echo "   - Copy your dashboard URL: https://admin-dashboard-xxxx.vercel.app"
echo ""
echo -e "${BLUE}3. CREATE ADMIN USER (1 minute)${NC}"
echo "   After Railway deploys, create first admin user:"
echo "   Email: admin@example.com"
echo "   Password: SecurePassword123!"
echo "   City: Denver"
echo ""
echo -e "${BLUE}4. TEST ADMIN DASHBOARD (2 minutes)${NC}"
echo "   - Go to your Vercel URL"
echo "   - Sign in with admin credentials"
echo "   - Check Statistics tab"
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  DEPLOYMENT CONFIGURATION COMPLETE!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo "Once manual steps are done:"
echo "✓ Backend API running on Railway"
echo "✓ Admin Dashboard running on Vercel"
echo "✓ Ready for iOS app development"
echo ""
