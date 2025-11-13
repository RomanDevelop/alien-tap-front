// Test script to verify Telegram mock creation logic
// Run with: node test_mock.js

// Simulate browser environment
global.window = {
  Telegram: {},
};

// Copy the logic from telegram.js
function isRunningInTelegram() {
  try {
    const initData = global.window.Telegram?.WebApp?.initDataUnsafe;
    if (initData && initData.hash && typeof initData.hash === 'string' && initData.hash.length > 0) {
      if (initData.hash.length > 40 && !initData.hash.startsWith('mock_hash_for_development_')) {
        return true;
      }
      if (initData.hash.startsWith('mock_')) {
        return false;
      }
    }
  } catch (e) {
    console.log('Cannot check Telegram WebApp:', e);
  }
  return false;
}

function ensureTelegramMock() {
  console.log('🔧 ensureTelegramMock() called');
  
  if (!global.window.Telegram || !global.window.Telegram.WebApp) {
    global.window.Telegram = global.window.Telegram || {};
    global.window.Telegram.WebApp = global.window.Telegram.WebApp || {};
    console.log('🔧 Created Telegram.WebApp structure');
  }
  
  if (!global.window.Telegram.WebApp.initDataUnsafe) {
    console.log('🔧 Creating mock initDataUnsafe...');
    
    const mockUser = {
      id: 1111,
      username: 'dev_user',
      first_name: 'Dev',
      last_name: 'User'
    };
    
    const authDate = Math.floor(Date.now() / 1000);
    const mockHash = 'mock_hash_for_development_' + Math.random().toString(36).substring(2, 15) + '_' + Date.now();
    
    const mockInitData = {
      user: mockUser,
      auth_date: authDate,
      hash: mockHash
    };
    
    try {
      Object.defineProperty(global.window.Telegram.WebApp, 'initDataUnsafe', {
        value: mockInitData,
        writable: true,
        enumerable: true,
        configurable: true
      });
      console.log('✅ Mock created via Object.defineProperty');
    } catch (e) {
      global.window.Telegram.WebApp.initDataUnsafe = mockInitData;
      console.log('✅ Mock created via direct assignment');
    }
    
    // Verify
    console.log('✅ Mock verification:', {
      hash: global.window.Telegram.WebApp.initDataUnsafe.hash,
      hashType: typeof global.window.Telegram.WebApp.initDataUnsafe.hash,
      hashLength: global.window.Telegram.WebApp.initDataUnsafe.hash?.length
    });
  } else {
    console.log('✅ Mock already exists');
  }
  
  return global.window.Telegram.WebApp.initDataUnsafe;
}

// Test
console.log('🧪 Testing Telegram mock creation...\n');

// Step 1: Initialize structure
global.window.Telegram = global.window.Telegram || {};
global.window.Telegram.WebApp = global.window.Telegram.WebApp || {};
console.log('✅ Step 1: Telegram.WebApp structure initialized');

// Step 2: Check if running in Telegram
const isInTelegram = isRunningInTelegram();
console.log(`📋 Step 2: isRunningInTelegram() = ${isInTelegram}`);

// Step 3: Create mock
if (!isInTelegram) {
  console.log('📋 Step 3: Not in Telegram, creating mock...');
  ensureTelegramMock();
} else {
  console.log('📋 Step 3: In Telegram, skipping mock');
}

// Step 4: Verify mock
console.log('\n📋 Step 4: Verifying mock...');
if (global.window.Telegram.WebApp.initDataUnsafe) {
  const mock = global.window.Telegram.WebApp.initDataUnsafe;
  console.log('✅ initDataUnsafe exists');
  console.log(`   hash: ${mock.hash}`);
  console.log(`   hash type: ${typeof mock.hash}`);
  console.log(`   hash length: ${mock.hash?.length || 0}`);
  console.log(`   auth_date: ${mock.auth_date}`);
  console.log(`   user: ${JSON.stringify(mock.user)}`);
  
  // Test property access
  console.log('\n📋 Step 5: Testing property access...');
  console.log(`   Direct access: mock.hash = ${mock.hash}`);
  console.log(`   Direct access: mock['hash'] = ${mock['hash']}`);
  console.log(`   Object.keys: ${Object.keys(mock).join(', ')}`);
  
  // Test getInitDataProperty function
  global.window.Telegram.WebApp.getInitDataProperty = function(key) {
    const data = global.window.Telegram.WebApp.initDataUnsafe;
    if (!data) return null;
    return data[key];
  };
  
  const hashViaFunction = global.window.Telegram.WebApp.getInitDataProperty('hash');
  console.log(`   getInitDataProperty('hash'): ${hashViaFunction}`);
  
  if (hashViaFunction && hashViaFunction.toString().length > 0) {
    console.log('\n✅ SUCCESS: Mock is working correctly!');
    process.exit(0);
  } else {
    console.log('\n❌ FAILED: getInitDataProperty returned null or empty');
    process.exit(1);
  }
} else {
  console.log('❌ FAILED: initDataUnsafe is null/undefined');
  process.exit(1);
}

