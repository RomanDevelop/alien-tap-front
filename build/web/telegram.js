// Telegram WebApp initialization
// In development mode, this mocks the Telegram.WebApp object
// In production, it uses the real Telegram.WebApp from telegram-web-app.js

window.Telegram = window.Telegram || {};
window.Telegram.WebApp = window.Telegram.WebApp || {};

// Helper function to check if running inside Telegram
function isRunningInTelegram() {
  // Check if Telegram WebApp is available and has valid initData
  try {
    // In Telegram, initDataUnsafe should be available and have a hash
    const initData = window.Telegram?.WebApp?.initDataUnsafe;
    if (initData && initData.hash && typeof initData.hash === 'string' && initData.hash.length > 0) {
      // Check if hash looks like a real Telegram hash (hex string, usually 64 chars)
      // Real hash from Telegram is much longer than our mock (64+ chars, hex only)
      // Our mock hash starts with "mock_hash_for_development_"
      if (initData.hash.length > 40 && !initData.hash.startsWith('mock_hash_for_development_')) {
        return true; // Likely real Telegram
      }
      // If hash starts with "mock_", it's our mock - we're not in Telegram
      if (initData.hash.startsWith('mock_')) {
        return false; // It's our mock
      }
    }
  } catch (e) {
    // If we can't access it, assume we're not in Telegram
    console.log('Cannot check Telegram WebApp:', e);
  }
  return false; // Default: not in Telegram
}

// Create or update mock for development (when not running inside Telegram)
const isInTelegram = isRunningInTelegram();

console.log('🔍 isRunningInTelegram():', isInTelegram);
console.log('🔍 window.Telegram.WebApp.initDataUnsafe exists:', !!window.Telegram.WebApp.initDataUnsafe);

// Always create mock in development (unless we're really in Telegram)
// Use a function to create mock so it can be called multiple times
function createMockInitData() {
  const mockUser = {
    id: 1111,
    username: 'dev_user',
    first_name: 'Dev',
    last_name: 'User'
  };
  
  const authDate = Math.floor(Date.now() / 1000);
  const mockHash = 'mock_hash_for_development_' + Math.random().toString(36).substring(2, 15) + '_' + Date.now();
  
  return {
    user: mockUser,
    auth_date: authDate,
    hash: mockHash
  };
}

if (!isInTelegram) {
  console.log('🔧 Development mode: Creating mock Telegram.WebApp.initDataUnsafe');
  
  const mockInitData = createMockInitData();
  console.log('📋 Creating mockInitData:', mockInitData);
  
  // Set initDataUnsafe with proper object structure
  // Use Object.defineProperty with configurable: true so it can be overwritten if needed
  try {
    Object.defineProperty(window.Telegram.WebApp, 'initDataUnsafe', {
      value: mockInitData,
      writable: true,
      enumerable: true,
      configurable: true
    });
    console.log('✅ Set initDataUnsafe via Object.defineProperty');
  } catch (e) {
    // Fallback: direct assignment
    console.warn('⚠️ Object.defineProperty failed, using direct assignment:', e);
    window.Telegram.WebApp.initDataUnsafe = mockInitData;
    console.log('✅ Set initDataUnsafe via direct assignment');
  }
  
  // Immediately verify
  console.log('🔍 Verification after creation:');
  console.log('  - window.Telegram.WebApp.initDataUnsafe:', window.Telegram.WebApp.initDataUnsafe);
  console.log('  - hash:', window.Telegram.WebApp.initDataUnsafe?.hash);
  console.log('  - hash type:', typeof window.Telegram.WebApp.initDataUnsafe?.hash);
  console.log('  - hash length:', window.Telegram.WebApp.initDataUnsafe?.hash?.length);
  
  // Re-verify after a short delay (in case telegram-web-app.js overwrites it)
  setTimeout(() => {
    if (!window.Telegram.WebApp.initDataUnsafe || !window.Telegram.WebApp.initDataUnsafe.hash) {
      console.warn('⚠️ Mock was overwritten, recreating...');
      const newMock = createMockInitData();
      window.Telegram.WebApp.initDataUnsafe = newMock;
      console.log('✅ Mock recreated:', newMock);
    }
  }, 100);
  
} else if (!window.Telegram.WebApp.initDataUnsafe) {
  // Edge case: isRunningInTelegram returned true but initDataUnsafe doesn't exist
  console.warn('⚠️ isRunningInTelegram=true but initDataUnsafe not found, creating mock anyway');
  
  const mockUser = {
    id: 1111,
    username: 'dev_user',
    first_name: 'Dev',
    last_name: 'User'
  };
  
  const authDate = Math.floor(Date.now() / 1000);
  const mockHash = 'mock_hash_for_development_' + Math.random().toString(36).substring(2, 15) + '_' + Date.now();
  
  window.Telegram.WebApp.initDataUnsafe = {
    user: mockUser,
    auth_date: authDate,
    hash: mockHash
  };
  
  console.log('✅ Created fallback mock');
}

// Verify the mock was created correctly (after both branches)
if (window.Telegram.WebApp.initDataUnsafe) {
  console.log('✅ Mock Telegram.WebApp.initDataUnsafe verified');
  console.log('📋 Mock data:', {
    user: window.Telegram.WebApp.initDataUnsafe.user,
    auth_date: window.Telegram.WebApp.initDataUnsafe.auth_date,
    hash: window.Telegram.WebApp.initDataUnsafe.hash,
    hashLength: window.Telegram.WebApp.initDataUnsafe.hash?.length || 0
  });
  console.log('🔑 Hash value:', window.Telegram.WebApp.initDataUnsafe.hash);
  console.log('🔑 Hash type:', typeof window.Telegram.WebApp.initDataUnsafe.hash);
  
  const verification = {
    hasUser: !!window.Telegram.WebApp.initDataUnsafe.user,
    hasAuthDate: !!window.Telegram.WebApp.initDataUnsafe.auth_date,
    hasHash: !!window.Telegram.WebApp.initDataUnsafe.hash,
    hashIsString: typeof window.Telegram.WebApp.initDataUnsafe.hash === 'string',
    hashLength: window.Telegram.WebApp.initDataUnsafe.hash?.length || 0
  };
  console.log('✅ Verification:', verification);
  
  if (!verification.hasHash || !verification.hashIsString || verification.hashLength === 0) {
    console.error('❌ ERROR: Mock hash was not created correctly!', verification);
  }
}

// Create helper functions AFTER mock is created
window.Telegram.WebApp.getInitDataJSON = window.Telegram.WebApp.getInitDataJSON || function() {
  const data = window.Telegram.WebApp.initDataUnsafe || {};
  const json = JSON.stringify(data);
  console.log('📦 getInitDataJSON returns:', json);
  return json;
};

window.Telegram.WebApp.getInitDataProperty = window.Telegram.WebApp.getInitDataProperty || function(key) {
  // Always get fresh reference to initDataUnsafe
  const data = window.Telegram.WebApp.initDataUnsafe;
  
  if (!data) {
    console.error(`❌ getInitDataProperty('${key}'): initDataUnsafe is null or undefined!`);
    return null;
  }
  
  const value = data[key];
  console.log(`🔍 getInitDataProperty('${key}'):`, value, typeof value);
  
  // Double check - log the full data structure if hash is missing
  if (!value && key === 'hash') {
    console.error('❌ CRITICAL: hash not found in initDataUnsafe!');
    console.error('Full initDataUnsafe:', data);
    console.error('Keys in initDataUnsafe:', Object.keys(data));
    console.error('Type of initDataUnsafe:', typeof data);
    console.error('Hash directly:', data.hash);
    console.error('Hash type:', typeof data.hash);
  }
  
  return value;
};

// Test the functions immediately after creation
if (window.Telegram.WebApp.initDataUnsafe) {
  console.log('🧪 Testing getInitDataProperty("hash"):', window.Telegram.WebApp.getInitDataProperty('hash'));
  console.log('🧪 Testing getInitDataProperty("auth_date"):', window.Telegram.WebApp.getInitDataProperty('auth_date'));
  console.log('🧪 Testing getInitDataProperty("user"):', window.Telegram.WebApp.getInitDataProperty('user'));
}

window.Telegram.WebApp.ready = window.Telegram.WebApp.ready || function(){};
window.Telegram.WebApp.ready();

window.Telegram.WebApp.expand = window.Telegram.WebApp.expand || function(){};
window.Telegram.WebApp.expand();

window.Telegram.WebApp.enableClosingConfirmation = window.Telegram.WebApp.enableClosingConfirmation || function(){};
window.Telegram.WebApp.enableClosingConfirmation();

// Global function to ensure mock is created (can be called from Dart)
window.ensureTelegramMock = function() {
  console.log('🔧 ensureTelegramMock() called');
  
  if (!window.Telegram || !window.Telegram.WebApp) {
    window.Telegram = window.Telegram || {};
    window.Telegram.WebApp = window.Telegram.WebApp || {};
    console.log('🔧 Created Telegram.WebApp structure');
  }
  
  // Always recreate mock to ensure it exists (even if it was overwritten)
  console.log('🔧 Creating/updating mock initDataUnsafe...');
  
  const mockInitData = createMockInitData();
  
  // Force set using direct assignment (most reliable)
  window.Telegram.WebApp.initDataUnsafe = mockInitData;
  console.log('✅ Mock set via direct assignment');
  
  // Verify immediately
  const mock = window.Telegram.WebApp.initDataUnsafe;
  if (mock && mock.hash) {
    console.log('✅ Mock verification:', {
      hash: mock.hash,
      hashType: typeof mock.hash,
      hashLength: mock.hash?.length,
      auth_date: mock.auth_date,
      hasUser: !!mock.user
    });
  } else {
    console.error('❌ CRITICAL: Mock was set but verification failed!');
    console.error('Mock object:', mock);
  }
  
  return window.Telegram.WebApp.initDataUnsafe;
};

