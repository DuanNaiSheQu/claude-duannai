#!/usr/bin/env node
/**
 * Gemini CLI 问题诊断工具
 * 帮助识别不同CLI环境的差异
 */

console.log('🔍 Gemini CLI 环境诊断工具\n');

// 1. 基础环境信息
console.log('📊 基础环境信息:');
console.log(`   Node.js版本: ${process.version}`);
console.log(`   操作系统: ${process.platform} ${process.arch}`);
console.log(`   内存: ${Math.round(process.memoryUsage().rss / 1024 / 1024)}MB`);

// 2. HTTP客户端测试
const https = require('https');
const { URL } = require('url');

async function testHTTPClient() {
  console.log('\n🌐 HTTP客户端测试:');
  
  const testUrl = 'https://ai.jikexingtu.com/gemini/v1internal:countTokens';
  const postData = JSON.stringify({
    "request": {
      "model": "models/gemini-2.5-pro",
      "contents": [{"role": "user", "parts": [{"text": "test"}]}]
    }
  });
  
  return new Promise((resolve, reject) => {
    const url = new URL(testUrl);
    const options = {
      hostname: url.hostname,
      port: 443,
      path: url.pathname + url.search,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData),
        'Authorization': 'Bearer cr_5ef1dc0cc346299db9e6c35e6184470d7bc619613b82415f12c0eb1d822e6d52',
        'User-Agent': `GeminiDebug/1.0 (${process.platform}; ${process.arch}) Node.js/${process.version}`
      },
      timeout: 30000
    };
    
    console.log(`   请求URL: ${testUrl}`);
    console.log(`   User-Agent: ${options.headers['User-Agent']}`);
    
    const startTime = Date.now();
    const req = https.request(options, (res) => {
      const duration = Date.now() - startTime;
      console.log(`   响应状态: ${res.statusCode}`);
      console.log(`   响应时间: ${duration}ms`);
      console.log(`   响应头: ${JSON.stringify(res.headers, null, 2)}`);
      
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      
      res.on('end', () => {
        console.log(`   响应长度: ${data.length}字节`);
        if (res.statusCode === 200) {
          console.log('   ✅ HTTP客户端工作正常');
        } else {
          console.log('   ❌ HTTP客户端有问题');
          console.log(`   响应内容: ${data.substring(0, 200)}...`);
        }
        resolve();
      });
    });
    
    req.on('error', (error) => {
      const duration = Date.now() - startTime;
      console.log(`   ❌ 请求失败 (${duration}ms):`, error.message);
      console.log(`   错误代码: ${error.code}`);
      resolve();
    });
    
    req.on('timeout', () => {
      console.log('   ⏰ 请求超时 (30秒)');
      req.destroy();
      resolve();
    });
    
    req.write(postData);
    req.end();
  });
}

// 3. 流式连接测试
async function testStreamConnection() {
  console.log('\n🌊 流式连接测试:');
  
  const testUrl = 'https://ai.jikexingtu.com/gemini/v1internal:streamGenerateContent?alt=sse';
  const postData = JSON.stringify({
    "model": "gemini-2.5-pro",
    "request": {
      "contents": [{"role": "user", "parts": [{"text": "Hello"}]}]
    }
  });
  
  return new Promise((resolve, reject) => {
    const url = new URL(testUrl);
    const options = {
      hostname: url.hostname,
      port: 443,
      path: url.pathname + url.search,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData),
        'Authorization': 'Bearer cr_5ef1dc0cc346299db9e6c35e6184470d7bc619613b82415f12c0eb1d822e6d52',
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache'
      },
      timeout: 60000
    };
    
    let chunks = 0;
    let dataReceived = 0;
    let doneReceived = false;
    const startTime = Date.now();
    
    const req = https.request(options, (res) => {
      console.log(`   流式响应状态: ${res.statusCode}`);
      
      res.on('data', (chunk) => {
        chunks++;
        dataReceived += chunk.length;
        const chunkStr = chunk.toString();
        
        if (chunkStr.includes('[DONE]')) {
          doneReceived = true;
          console.log('   ✅ 收到结束信号 [DONE]');
        }
        
        // 每收到10个chunk打印一次进度
        if (chunks % 10 === 0) {
          console.log(`   📦 已收到 ${chunks} 个数据块，${dataReceived} 字节`);
        }
      });
      
      res.on('end', () => {
        const duration = Date.now() - startTime;
        console.log(`   🏁 流式传输结束 (${duration}ms)`);
        console.log(`   📊 总计: ${chunks} 个块, ${dataReceived} 字节`);
        
        if (doneReceived) {
          console.log('   ✅ 流式连接完全正常');
        } else {
          console.log('   ⚠️  未收到 [DONE] 信号，可能有问题');
        }
        resolve();
      });
      
      res.on('close', () => {
        console.log('   🔌 连接已关闭');
      });
    });
    
    req.on('error', (error) => {
      const duration = Date.now() - startTime;
      console.log(`   ❌ 流式请求失败 (${duration}ms):`, error.message);
      console.log(`   错误代码: ${error.code}`);
      
      if (error.code === 'ECONNRESET') {
        console.log('   🚨 这是 ECONNRESET 错误！');
      }
      resolve();
    });
    
    req.on('timeout', () => {
      console.log('   ⏰ 流式请求超时 (60秒)');
      req.destroy();
      resolve();
    });
    
    req.write(postData);
    req.end();
  });
}

// 4. 网络配置检测
function checkNetworkConfig() {
  console.log('\n🔧 网络配置检测:');
  
  // DNS配置
  const dns = require('dns');
  dns.lookup('ai.jikexingtu.com', (err, address, family) => {
    if (err) {
      console.log(`   ❌ DNS解析失败: ${err.message}`);
    } else {
      console.log(`   🌐 DNS解析: ai.jikexingtu.com -> ${address} (IPv${family})`);
    }
  });
  
  // 代理检测
  console.log(`   HTTP_PROXY: ${process.env.HTTP_PROXY || '未设置'}`);
  console.log(`   HTTPS_PROXY: ${process.env.HTTPS_PROXY || '未设置'}`);
  console.log(`   NO_PROXY: ${process.env.NO_PROXY || '未设置'}`);
}

// 执行诊断
async function runDiagnostics() {
  try {
    await testHTTPClient();
    await testStreamConnection();
    checkNetworkConfig();
    
    console.log('\n📋 诊断建议:');
    console.log('   1. 将此诊断结果与工作正常的CLI环境对比');
    console.log('   2. 检查Node.js版本差异');
    console.log('   3. 检查网络环境和代理设置');
    console.log('   4. 如果流式连接失败，问题在客户端');
    console.log('   5. 如果流式连接成功，问题在CLI的响应解析');
    
  } catch (error) {
    console.error('❌ 诊断过程出错:', error);
  }
}

runDiagnostics();