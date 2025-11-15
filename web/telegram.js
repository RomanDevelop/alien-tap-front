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
  return window.Telegram?.WebApp?.initData || null;
};

// Helper to parse initData string and extract user
window.Telegram.WebApp.parseInitDataUser = window.Telegram.WebApp.parseInitDataUser || function() {
  try {
    const initDataString = window.Telegram?.WebApp?.initData;
    if (!initDataString) return null;
    
    // Parse URL-encoded string: "hash=...&user=%7B%22id%22%3A123%7D&auth_date=..."
    const params = new URLSearchParams(initDataString);
    const userParam = params.get('user');
    if (userParam) {
      return JSON.parse(decodeURIComponent(userParam));
    }
  } catch (e) {
    console.warn('Failed to parse initData user:', e);
  }
  return null;
};

// Diagnostic function to log all available Telegram WebApp data
window.Telegram.WebApp.diagnose = window.Telegram.WebApp.diagnose || function() {
  const result = {
    version: window.Telegram?.WebApp?.version || null,
    platform: window.Telegram?.WebApp?.platform || null,
    initData: window.Telegram?.WebApp?.initData || null,
    initDataUnsafe: window.Telegram?.WebApp?.initDataUnsafe || null,
    initDataUnsafeKeys: null,
    userFromUnsafe: null,
    userFromParsed: null,
  };
  
  if (result.initDataUnsafe) {
    result.initDataUnsafeKeys = Object.keys(result.initDataUnsafe);
    result.userFromUnsafe = result.initDataUnsafe.user || null;
  }
  
  result.userFromParsed = window.Telegram.WebApp.parseInitDataUser();
  
  console.log('🔍 Telegram WebApp Diagnostics:', result);
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

