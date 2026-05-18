// Local DNS Profile Server for Testing
// Run with: node test-dns-server.js

const http = require('http');
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
};

const DNS_PROFILE = `<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>PayloadContent</key>
  <array>
    <dict>
      <key>DNSSettings</key>
      <dict>
        <key>DNSProtocol</key>
        <string>HTTPS</string>
        <key>ServerURL</key>
        <string>https://doh.cleanbrowsing.org/doh/family-filter/</string>
        <key>ServerAddresses</key>
        <array>
          <string>185.228.168.168</string>
          <string>185.228.169.168</string>
          <string>2a0d:2a00:1::1</string>
          <string>2a0d:2a00:2::1</string>
        </array>
      </dict>
      <key>PayloadDescription</key>
      <string>Shield DNS Filter - Blocks explicit and adult content across all apps and browsers using CleanBrowsing Family Filter.</string>
      <key>PayloadDisplayName</key>
      <string>Shield DNS Filter</string>
      <key>PayloadIdentifier</key>
      <string>com.shieldapp.dns-filter</string>
      <key>PayloadType</key>
      <string>com.apple.dnsSettings.managed</string>
      <key>PayloadUUID</key>
      <string>A1B2C3D4-E5F6-7890-ABCD-EF1234567890</string>
      <key>PayloadVersion</key>
      <integer>1</integer>
      <key>ProhibitDisablement</key>
      <false/>
    </dict>
  </array>
  <key>PayloadDescription</key>
  <string>Shield blocks pornographic and explicit websites across every app on your device by filtering DNS requests through CleanBrowsing Family Filter. 100% private. No browsing data is collected.</string>
  <key>PayloadDisplayName</key>
  <string>Shield Content Blocker</string>
  <key>PayloadIdentifier</key>
  <string>com.shieldapp.content-blocker-profile</string>
  <key>PayloadOrganization</key>
  <string>Shield App</string>
  <key>PayloadRemovalDisallowed</key>
  <false/>
  <key>PayloadType</key>
  <string>Configuration</string>
  <key>PayloadUUID</key>
  <string>F1E2D3C4-B5A6-7890-FEDC-BA0987654321</string>
  <key>PayloadVersion</key>
  <integer>1</integer>
  <key>ConsentText</key>
  <dict>
    <key>default</key>
    <string>This profile configures your device to use Shield DNS filtering, which blocks adult and explicit content across all apps. Your browsing data is never collected or transmitted. You can remove this profile at any time from Settings.</string>
  </dict>
</dict>
</plist>`;

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  console.log(`\n[${new Date().toISOString()}] ${req.method} ${url.pathname}`);
  console.log(`Headers:`, req.headers);

  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    console.log('✓ CORS preflight request handled');
    res.writeHead(200, corsHeaders);
    res.end('ok');
    return;
  }

  // Serve DNS profile
  if (url.pathname === '/serve-dns-profile' || url.pathname === '/') {
    console.log('✓ Serving DNS profile');
    res.writeHead(200, {
      'Content-Type': 'application/x-apple-aspen-config',
      'Content-Disposition': 'attachment; filename="Shield-DNS-Filter.mobileconfig"',
      ...corsHeaders,
    });
    res.end(DNS_PROFILE);
    return;
  }

  // 404
  console.log('✗ Route not found');
  res.writeHead(404, { 'Content-Type': 'application/json', ...corsHeaders });
  res.end(JSON.stringify({ error: 'Route not found' }));
});

const PORT = 3000;
server.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════╗
║   🛡️  DNS Profile Test Server Started      ║
╚════════════════════════════════════════════╝

📍 Server running at: http://localhost:${PORT}

🧪 Test endpoints:
  • Download profile: http://localhost:${PORT}/serve-dns-profile
  • CORS test: http://localhost:${PORT}/ (via browser)

📝 To test with curl:
  curl -v http://localhost:${PORT}/serve-dns-profile

🔍 To test CORS preflight:
  curl -X OPTIONS -v http://localhost:${PORT}/serve-dns-profile

💡 Profile will be served with:
  • Content-Type: application/x-apple-aspen-config
  • Proper CORS headers
  • Correct filename for mobileconfig

Press Ctrl+C to stop the server.
  `);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`❌ Port ${PORT} is already in use. Try a different port.`);
  } else {
    console.error('❌ Server error:', err);
  }
  process.exit(1);
});
