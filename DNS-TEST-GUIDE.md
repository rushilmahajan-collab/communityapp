# DNS Profile Testing Guide

## Quick Start

You have two options to test the DNS profile:

### Option 1: Browser Mockup (Easiest)
```bash
# Just open the HTML file in your browser
open dns-profile-mockup.html
# or on Linux:
firefox dns-profile-mockup.html
```

This shows:
- ✅ The corrected profile structure
- ⬇️ Download button to test profile download
- 👁️ View the raw XML profile content
- 📋 Profile details and DNS server info

### Option 2: Local Test Server (Realistic)
```bash
# Start the local server
node test-dns-server.js
```

Then test in your browser or with curl:

```bash
# Download the profile
curl -v http://localhost:3000/serve-dns-profile -o Shield-DNS-Filter.mobileconfig

# Test CORS preflight
curl -X OPTIONS -v http://localhost:3000/serve-dns-profile

# View in browser
open http://localhost:3000
```

## What Was Fixed

### ❌ Before (Broken)
```xml
<key>OnDemandRules</key>
<array>
  <dict>
    <key>Action</key>
    <string>EvaluateConnection</string>
    <key>ActionParameters</key>
    <array>
      <dict>
        <key>DomainAction</key>
        <string>NeverConnect</string>
      </dict>
    </array>
  </dict>
  <dict>
    <key>Action</key>
    <string>Connect</string>
  </dict>
</array>
```

**Issue:** Invalid ActionParameters structure - DomainAction is not a valid parameter for EvaluateConnection action in Apple MDM profiles.

### ✅ After (Fixed)
Removed the entire OnDemandRules section. DNS settings now apply universally without conditional logic.

## DNS Configuration

- **Provider:** CleanBrowsing (Family Filter)
- **Protocol:** HTTPS (DNS over HTTPS / DoH)
- **IPv4 Servers:**
  - 185.228.168.168
  - 185.228.169.168
- **IPv6 Servers:**
  - 2a0d:2a00:1::1
  - 2a0d:2a00:2::1
- **DoH URL:** https://doh.cleanbrowsing.org/doh/family-filter/

## Testing Checklist

- [ ] Profile downloads without errors
- [ ] Content-Type header is `application/x-apple-aspen-config`
- [ ] Content-Disposition header includes filename
- [ ] CORS headers are present
- [ ] XML is valid (no parsing errors)
- [ ] Profile can be installed on iOS/macOS

## File Structure

```
communityapp/
├── supabase/
│   └── functions/
│       ├── serve-dns-profile/
│       │   └── index.ts          (Fixed Deno function)
│       └── _shared/
│           └── cors.ts            (CORS headers)
├── dns-profile-mockup.html        (Browser test UI)
├── test-dns-server.js             (Local Node.js server)
└── DNS-TEST-GUIDE.md              (This file)
```

## Troubleshooting

### Port 3000 Already in Use
```bash
# Change the PORT variable in test-dns-server.js
# Or kill the process using port 3000:
lsof -ti:3000 | xargs kill -9
```

### Profile Won't Install on Device
1. Check that the XML is valid
2. Verify PayloadUUIDs are unique
3. Ensure all required keys are present
4. Try viewing the raw profile content

### CORS Issues
The server includes proper CORS headers:
```
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: authorization, x-client-info, apikey, content-type
Access-Control-Allow-Methods: GET, POST, OPTIONS
```

## Next Steps

Once testing is complete:
1. Deploy the fixed `supabase/functions/serve-dns-profile/index.ts` to your Supabase Functions
2. Update your app to call the correct endpoint
3. Verify users can download and install the DNS profile
