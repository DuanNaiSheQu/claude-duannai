# 🔄 DuanNaiSheQu 智能同步指南

本文档介绍如何使用智能同步功能来保持您的仓库与上游项目 [Wei-Shaw/claude-relay-service](https://github.com/Wei-Shaw/claude-relay-service) 同步，同时完美保护您的定制化内容。

## 📋 功能特性

### ✨ 智能同步能力
- 🔄 **实时监听**: 每小时自动检查上游更新
- 🧠 **智能合并**: 自动识别和处理代码冲突
- 🛡️ **内容保护**: 完美保护您的定制化品牌内容
- 📦 **功能同步**: 及时获取上游的新功能和bug修复

### 🛡️ 保护机制
- **品牌标识保护**: DuanNaiSheQu、claude-duannai 等标识符
- **工作流保护**: 您的专属 GitHub Actions 工作流
- **版本控制**: 独立的版本号管理
- **配置保护**: 重要配置文件不被覆盖

## 🚀 使用方法

### 方法一：自动同步（推荐）
系统已配置自动同步，每小时检查一次上游更新：

1. **无需任何操作** - 系统自动运行
2. **查看同步日志** - 在 GitHub Actions 中查看运行结果
3. **接收通知** - 有更新时会自动提交到您的仓库

### 方法二：手动触发同步
如果想要立即同步，可以手动触发：

#### GitHub 网页操作
1. 访问您的仓库：https://github.com/DuanNaiSheQu/claude-duannai
2. 点击 "Actions" 标签页
3. 选择 "🔄 智能同步上游更新" 工作流
4. 点击 "Run workflow" 按钮
5. 等待同步完成

#### 本地脚本操作
```bash
# 在项目根目录执行
./scripts/sync-upstream.sh
```

### 方法三：手动同步（高级用户）
```bash
# 1. 获取上游更新
git fetch upstream

# 2. 查看有哪些更新
git log --oneline HEAD..upstream/main

# 3. 手动合并（需要处理冲突）  
git merge upstream/main

# 4. 推送更新
git push origin main
```

## ⚙️ 配置说明

### 同步配置文件
编辑 `.duannai-sync-config` 文件可以自定义同步行为：

```bash
# 完全跳过的文件
PROTECTED_FILES=(
  ".github/workflows/auto-release-pipeline.yml"
  "README.md" 
  "VERSION"
)

# 智能合并的文件
SMART_MERGE_FILES=(
  "docker-compose.yml"
  "package.json"
)

# 定制化内容标识符
CUSTOM_MARKERS=(
  "DuanNaiSheQu"
  "claude-duannai"
  "duannaishequ"
)
```

### 修改同步频率
编辑 `.github/workflows/sync-upstream.yml` 文件：

```yaml
# 每小时检查 (默认)
- cron: '0 * * * *'

# 每天检查
- cron: '0 0 * * *'  

# 每周检查
- cron: '0 0 * * 0'
```

## 🔍 同步原理

### 智能合并算法
1. **文件分类**: 自动识别保护文件、智能合并文件、普通文件
2. **内容检测**: 检测文件中是否包含定制化标识符
3. **策略应用**: 
   - 保护文件：完全跳过
   - 定制化文件：智能三路合并
   - 普通文件：直接更新并应用替换规则
4. **冲突处理**: 无法自动合并时保留当前版本并添加TODO标记

### 替换规则
同步时自动应用以下替换：
- `Wei-Shaw` → `DuanNaiSheQu`
- `claude-relay-service` → `claude-duannai`
- `weishaw` → `duannaishequ`
- `Claude Relay Service` → `DuanNaiSheQu Claude Service`

## 📊 同步监控

### 查看同步状态
1. **GitHub Actions**: 查看工作流运行历史
2. **提交历史**: 查找包含 "智能同步上游更新" 的提交
3. **分支状态**: 检查 main 分支是否领先于上游

### 同步失败处理
如果自动同步失败：

1. **查看错误日志**: 在 GitHub Actions 中查看详细错误
2. **手动解决冲突**: 使用本地脚本进行手动同步
3. **重置同步状态**: 必要时可以重新设置上游关系

```bash
# 重新设置上游
git remote remove upstream
git remote add upstream https://github.com/Wei-Shaw/claude-relay-service.git
```

## 🛠️ 故障排除

### 常见问题

**Q: 同步后某些定制化内容消失了怎么办？**
A: 检查 `.duannai-sync-config` 文件，确保相关标识符在 `CUSTOM_MARKERS` 中。

**Q: 如何临时禁用自动同步？**  
A: 在 GitHub 仓库设置中禁用 "🔄 智能同步上游更新" 工作流。

**Q: 同步频率太高/太低怎么调整？**
A: 修改 `.github/workflows/sync-upstream.yml` 文件中的 cron 表达式。

**Q: 如何查看具体同步了哪些内容？**
A: 查看提交历史中包含 "智能同步上游更新" 的提交详情。

### 紧急恢复
如果同步导致问题，可以快速恢复：

```bash
# 查找同步前的提交
git log --oneline

# 恢复到同步前状态  
git reset --hard <同步前的提交ID>

# 强制推送（慎用）
git push origin main --force
```

## 📈 最佳实践

1. **定期检查**: 定期查看 GitHub Actions 确保同步正常
2. **测试更新**: 重要更新后先在本地测试功能是否正常
3. **备份重要**: 重大同步前建议手动备份重要配置
4. **配置维护**: 及时更新同步配置以适应项目变化

## 🎯 高级用法

### 选择性同步
只同步特定文件或目录：

```bash
# 只同步src目录
git checkout upstream/main -- src/

# 只同步特定文件
git checkout upstream/main -- package.json
```

### 自定义同步脚本
可以基于提供的脚本创建自己的同步逻辑：

```bash
# 复制并修改同步脚本
cp scripts/sync-upstream.sh scripts/my-sync.sh
# 编辑脚本添加自定义逻辑
```

---

通过这套智能同步系统，您可以轻松保持与上游项目的功能同步，同时完美保护您的定制化内容！ 🚀