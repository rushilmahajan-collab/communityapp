import { corsHeaders } from '../_shared/cors.ts';

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

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    return new Response(DNS_PROFILE, {
      status: 200,
      headers: {
        'Content-Type': 'application/x-apple-aspen-config',
        'Content-Disposition': 'attachment; filename="Shield-DNS-Filter.mobileconfig"',
        ...corsHeaders,
      },
    });
  } catch (error) {
    console.error('Error serving DNS profile:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to generate DNS profile' }),
      { status: 500, headers: { 'Content-Type': 'application/json', ...corsHeaders } }
    );
  }
});
