// Telegram WebApp helper functions
// In production, this only provides helper functions - no mocks are created
// The real Telegram.WebApp.initDataUnsafe comes from telegram-web-app.js

window.Telegram = window.Telegram || {};
window.Telegram.WebApp = window.Telegram.WebApp || {};

// Helper function to check if running inside Telegram
function isRunningInTelegram() {
  try {
    const initData = window.Telegram?.WebApp?.initDataUnsafe;
    if (initData && initData.hash && typeof initData.hash === 'string' && initData.hash.length > 0) {
      // Real Telegram hash is usually 64+ characters, hex string
      // Mock hashes start with "mock_" - reject those
      if (initData.hash.length > 40 && !initData.hash.startsWith('mock_')) {
        return true; // Real Telegram
      }
    }
  } catch (e) {
    // Silent fail
  }
  return false;
}

// Check if we're in production (no mocks in production)
const isProduction = window.location.hostname !== 'localhost' && 
                     !window.location.hostname.includes('127.0.0.1') &&
                     !window.location.hostname.includes('.ngrok-free.dev') &&
                     !window.location.hostname.includes('.ngrok.io');

// Only create mocks in development (localhost/ngrok)
if (!isProduction && !isRunningInTelegram()) {
  console.warn('⚠️ Development mode: Running outside Telegram. Mock data will NOT be created in production builds.');
  // In development, you can manually test, but mocks are disabled for production safety
}

// Helper functions for accessing Telegram WebApp data
window.Telegram.WebApp.getInitDataJSON = window.Telegram.WebApp.getInitDataJSON || function() {
  const data = window.Telegram.WebApp.initDataUnsafe || {};
  return JSON.stringify(data);
};

window.Telegram.WebApp.getInitDataProperty = window.Telegram.WebApp.getInitDataProperty || function(key) {
  const data = window.Telegram.WebApp.initDataUnsafe;
  if (!data) {
    return null;
  }
  return data[key];
};

// Helper to get initData as string (URL-encoded) - alternative way to get user data
window.Telegram.WebApp.getInitData = window.Telegram.WebApp.getInitData || function() {
  // Try multiple ways to get initData string
  if (window.Telegram?.WebApp?.initData) {
    return window.Telegram.WebApp.initData;
  }
  // Sometimes it's available as a property directly
  if (window.Telegram?.WebApp?.initDataRaw) {
    return window.Telegram.WebApp.initDataRaw;
  }
  // Check if it's in the URL (for debugging)
  try {
    const urlParams = new URLSearchParams(window.location.search);
    const tgWebAppData = urlParams.get('tgWebAppData');
    if (tgWebAppData) {
      console.log('📋 Found tgWebAppData in URL params');
      return tgWebAppData;
    }
  } catch (e) {
    // Ignore
  }
  return null;
};

// Helper to parse initData string and extract user
window.Telegram.WebApp.parseInitDataUser = window.Telegram.WebApp.parseInitDataUser || function() {
  try {
    // Use getInitData() to get the string (handles multiple sources)
    const initDataString = window.Telegram.WebApp.getInitData();
    if (!initDataString) {
      console.warn('⚠️ parseInitDataUser: initData string is not available');
      return null;
    }
    
    console.log('📋 parseInitDataUser: initData string length:', initDataString.length);
    console.log('📋 parseInitDataUser: initData string preview:', initDataString.substring(0, 100) + '...');
    
    // Parse URL-encoded string: "hash=...&user=%7B%22id%22%3A123%7D&auth_date=..."
    const params = new URLSearchParams(initDataString);
    const userParam = params.get('user');
    
    if (userParam) {
      console.log('✅ parseInitDataUser: found user param, length:', userParam.length);
      const decoded = decodeURIComponent(userParam);
      console.log('📋 parseInitDataUser: decoded user:', decoded);
      const userObj = JSON.parse(decoded);
      console.log('✅ parseInitDataUser: successfully parsed user object');
      return userObj;
    } else {
      console.warn('⚠️ parseInitDataUser: user param not found in initData string');
      console.log('📋 Available params:', Array.from(params.keys()));
    }
  } catch (e) {
    console.error('❌ Failed to parse initData user:', e);
  }
  return null;
};

// Diagnostic function to log all available Telegram WebApp data
window.Telegram.WebApp.diagnose = window.Telegram.WebApp.diagnose || function() {
  const result = {
    version: window.Telegram?.WebApp?.version || null,
    platform: window.Telegram?.WebApp?.platform || null,
    initData: null,
    initDataViaGetInitData: null,
    initDataUnsafe: window.Telegram?.WebApp?.initDataUnsafe || null,
    initDataUnsafeKeys: null,
    userFromUnsafe: null,
    userFromParsed: null,
  };
  
  // Check initData property directly
  result.initData = window.Telegram?.WebApp?.initData || null;
  
  // Check via getInitData() function (handles multiple sources)
  if (window.Telegram.WebApp.getInitData) {
    result.initDataViaGetInitData = window.Telegram.WebApp.getInitData();
  }
  
  if (result.initDataUnsafe) {
    result.initDataUnsafeKeys = Object.keys(result.initDataUnsafe);
    result.userFromUnsafe = result.initDataUnsafe.user || null;
  }
  
  // Try to parse user from initData string
  if (window.Telegram.WebApp.parseInitDataUser) {
    result.userFromParsed = window.Telegram.WebApp.parseInitDataUser();
  }
  
  console.log('🔍 Telegram WebApp Diagnostics:', result);
  console.log('📋 Detailed info:');
  console.log('   - initData (direct):', result.initData ? `available (${result.initData.length} chars)` : 'not available');
  console.log('   - initData (via getInitData):', result.initDataViaGetInitData ? `available (${result.initDataViaGetInitData.length} chars)` : 'not available');
  console.log('   - initDataUnsafe:', result.initDataUnsafe ? 'available' : 'not available');
  console.log('   - initDataUnsafe keys:', result.initDataUnsafeKeys || 'N/A');
  console.log('   - user from initDataUnsafe:', result.userFromUnsafe ? 'available' : 'not available');
  console.log('   - user from parsed initData:', result.userFromParsed ? 'available' : 'not available');
  
  return result;
};

// Initialize Telegram WebApp (if not already initialized)
if (window.Telegram.WebApp.ready && typeof window.Telegram.WebApp.ready === 'function') {
  window.Telegram.WebApp.ready();
}

if (window.Telegram.WebApp.expand && typeof window.Telegram.WebApp.expand === 'function') {
  window.Telegram.WebApp.expand();
}

if (window.Telegram.WebApp.enableClosingConfirmation && typeof window.Telegram.WebApp.enableClosingConfirmation === 'function') {
  window.Telegram.WebApp.enableClosingConfirmation();
}

