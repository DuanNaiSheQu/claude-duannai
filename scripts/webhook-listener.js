#!/usr/bin/env node

/**
 * DuanNaiSheQu 实时代码同步 Webhook 监听器
 * 监听上游仓库的推送事件并触发实时同步
 */

const http = require('http');
const crypto = require('crypto');
const { execSync } = require('child_process');

// 配置
const CONFIG = {
  port: process.env.WEBHOOK_PORT || 8080,
  secret: process.env.WEBHOOK_SECRET || 'duannai-sync-secret-2024',
  upstreamRepo: 'Wei-Shaw/claude-relay-service',
  targetRepo: 'DuanNaiSheQu/claude-duannai',
  githubToken: process.env.GITHUB_TOKEN,
};

// 日志函数
const log = {
  info: (msg) => console.log(`[INFO ${new Date().toISOString()}] ${msg}`),
  warn: (msg) => console.warn(`[WARN ${new Date().toISOString()}] ${msg}`),
  error: (msg) => console.error(`[ERROR ${new Date().toISOString()}] ${msg}`),
  success: (msg) => console.log(`[SUCCESS ${new Date().toISOString()}] ${msg}`),
};

/**
 * 验证GitHub webhook签名
 */
function verifySignature(payload, signature) {
  const hmac = crypto.createHmac('sha256', CONFIG.secret);
  const digest = Buffer.from(`sha256=${hmac.update(payload).digest('hex')}`, 'utf8');
  const checksum = Buffer.from(signature, 'utf8');
  
  if (digest.length !== checksum.length || !crypto.timingSafeEqual(digest, checksum)) {
    return false;
  }
  return true;
}

/**
 * 触发GitHub Actions工作流
 */
async function triggerRealtimeSync(commitSha, commitMessage, changedFiles) {
  try {
    log.info(`触发实时同步: ${commitSha}`);
    
    const payload = {
      event_type: 'upstream_push',
      client_payload: {
        upstream_commit: commitSha,
        commit_message: commitMessage,
        changed_files: changedFiles,
        timestamp: new Date().toISOString(),
        trigger_source: 'webhook'
      }
    };
    
    // 使用GitHub CLI或curl触发repository_dispatch
    if (CONFIG.githubToken) {
      const curlCommand = `curl -X POST \\
        -H "Accept: application/vnd.github.v3+json" \\
        -H "Authorization: token ${CONFIG.githubToken}" \\
        https://api.github.com/repos/${CONFIG.targetRepo}/dispatches \\
        -d '${JSON.stringify(payload)}'`;
      
      const result = execSync(curlCommand, { encoding: 'utf8' });
      log.success(`实时同步已触发: ${commitSha}`);
      return true;
    } else {
      log.error('缺少 GITHUB_TOKEN，无法触发同步');
      return false;
    }
  } catch (error) {
    log.error(`触发同步失败: ${error.message}`);
    return false;
  }
}

/**
 * 分析代码变更详情
 */
function analyzeChanges(commits) {
  let totalChanges = {
    added: 0,
    modified: 0,
    removed: 0
  };
  
  let changeTypes = {
    features: 0,
    bugfixes: 0,
    docs: 0,
    config: 0,
    other: 0
  };
  
  let allChangedFiles = new Set();
  
  commits.forEach(commit => {
    // 分析提交类型
    const message = commit.message.toLowerCase();
    if (message.includes('feat') || message.includes('feature') || message.includes('add') || message.includes('新增')) {
      changeTypes.features++;
    } else if (message.includes('fix') || message.includes('bug') || message.includes('修复')) {
      changeTypes.bugfixes++;
    } else if (message.includes('doc') || message.includes('readme') || message.includes('文档')) {
      changeTypes.docs++;
    } else if (message.includes('config') || message.includes('配置')) {
      changeTypes.config++;
    } else {
      changeTypes.other++;
    }
    
    // 收集变更文件
    if (commit.added) commit.added.forEach(f => allChangedFiles.add(f));
    if (commit.modified) commit.modified.forEach(f => allChangedFiles.add(f));
    if (commit.removed) commit.removed.forEach(f => allChangedFiles.add(f));
    
    // 统计变更数量
    totalChanges.added += commit.added ? commit.added.length : 0;
    totalChanges.modified += commit.modified ? commit.modified.length : 0;
    totalChanges.removed += commit.removed ? commit.removed.length : 0;
  });
  
  return {
    totalChanges,
    changeTypes,
    changedFiles: Array.from(allChangedFiles),
    commitCount: commits.length
  };
}

/**
 * 处理推送事件
 */
async function handlePushEvent(payload) {
  log.info('收到上游推送事件');
  
  // 验证是否是目标仓库
  if (payload.repository.full_name !== CONFIG.upstreamRepo) {
    log.warn(`忽略非目标仓库的推送: ${payload.repository.full_name}`);
    return;
  }
  
  // 验证是否是main分支
  if (payload.ref !== 'refs/heads/main') {
    log.warn(`忽略非main分支的推送: ${payload.ref}`);
    return;
  }
  
  const commits = payload.commits;
  if (!commits || commits.length === 0) {
    log.warn('推送事件中没有提交');
    return;
  }
  
  // 分析变更
  const analysis = analyzeChanges(commits);
  
  log.info(`检测到代码变更:`);
  log.info(`  - 提交数量: ${analysis.commitCount}`);
  log.info(`  - 变更文件: ${analysis.changedFiles.length}个`);
  log.info(`  - 新增: ${analysis.totalChanges.added}, 修改: ${analysis.totalChanges.modified}, 删除: ${analysis.totalChanges.removed}`);
  log.info(`  - 功能: ${analysis.changeTypes.features}, 修复: ${analysis.changeTypes.bugfixes}, 文档: ${analysis.changeTypes.docs}`);
  
  // 获取最新提交信息
  const latestCommit = commits[commits.length - 1];
  const commitSha = latestCommit.id;
  const commitMessage = latestCommit.message;
  
  log.info(`最新提交: ${commitSha.substring(0, 8)} - ${commitMessage}`);
  
  // 触发实时同步
  const success = await triggerRealtimeSync(commitSha, commitMessage, analysis.changedFiles);
  
  if (success) {
    log.success(`✅ 实时同步已触发！`);
    log.success(`🔄 GitHub Actions 工作流正在处理上游变更`);
    log.success(`🎯 目标提交: ${commitSha}`);
    log.success(`📂 影响文件: ${analysis.changedFiles.length}个`);
  } else {
    log.error(`❌ 实时同步触发失败`);
  }
}

/**
 * 创建HTTP服务器
 */
const server = http.createServer(async (req, res) => {
  if (req.method !== 'POST') {
    res.writeHead(405, { 'Content-Type': 'text/plain' });
    res.end('Method Not Allowed');
    return;
  }
  
  let body = '';
  req.on('data', chunk => {
    body += chunk.toString();
  });
  
  req.on('end', async () => {
    try {
      // 验证签名
      const signature = req.headers['x-hub-signature-256'];
      if (!signature || !verifySignature(body, signature)) {
        log.error('Webhook签名验证失败');
        res.writeHead(401, { 'Content-Type': 'text/plain' });
        res.end('Unauthorized');
        return;
      }
      
      // 解析payload
      const payload = JSON.parse(body);
      const event = req.headers['x-github-event'];
      
      log.info(`收到GitHub事件: ${event}`);
      
      // 处理推送事件
      if (event === 'push') {
        await handlePushEvent(payload);
        
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
          success: true,
          message: '实时同步已触发',
          timestamp: new Date().toISOString()
        }));
      } else {
        log.info(`忽略事件类型: ${event}`);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('Event ignored');
      }
      
    } catch (error) {
      log.error(`处理webhook失败: ${error.message}`);
      res.writeHead(500, { 'Content-Type': 'text/plain' });
      res.end('Internal Server Error');
    }
  });
});

// 启动服务器
server.listen(CONFIG.port, () => {
  log.success('🚀 DuanNaiSheQu 实时同步监听器已启动');
  log.info(`📡 监听端口: ${CONFIG.port}`);
  log.info(`🎯 目标仓库: ${CONFIG.upstreamRepo}`);
  log.info(`🔄 同步仓库: ${CONFIG.targetRepo}`);
  log.info(`🔑 Webhook Secret: ${CONFIG.secret ? '已配置' : '未配置'}`);
  log.info(`🔐 GitHub Token: ${CONFIG.githubToken ? '已配置' : '未配置'}`);
  log.info('');
  log.info('📋 配置说明:');
  log.info('1. 在上游仓库设置 Webhook URL: http://your-domain:8080');
  log.info('2. 设置 Secret: duannai-sync-secret-2024');
  log.info('3. 选择事件: push');
  log.info('4. 设置环境变量 GITHUB_TOKEN');
  log.info('');
  log.success('✅ 准备接收上游代码变更推送！');
});

// 优雅关闭
process.on('SIGINT', () => {
  log.info('收到关闭信号，正在停止服务器...');
  server.close(() => {
    log.success('✅ 服务器已停止');
    process.exit(0);
  });
});

process.on('SIGTERM', () => {
  log.info('收到终止信号，正在停止服务器...');
  server.close(() => {
    log.success('✅ 服务器已停止');
    process.exit(0);
  });
});