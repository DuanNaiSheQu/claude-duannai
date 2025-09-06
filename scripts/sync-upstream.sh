#!/bin/bash

# DuanNaiSheQu 上游智能同步脚本
# 用于手动同步 Wei-Shaw/claude-relay-service 的更新

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 检查当前是否在git仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_error "请在git仓库根目录中运行此脚本"
    exit 1
fi

# 读取配置
if [ -f ".duannai-sync-config" ]; then
    source .duannai-sync-config
    log_success "已加载同步配置"
else
    log_warning "未找到配置文件，使用默认配置"
fi

log_info "🚀 开始智能同步上游更新..."

# 确保upstream远程仓库已添加
if ! git remote get-url upstream > /dev/null 2>&1; then
    log_info "添加上游远程仓库..."
    git remote add upstream https://github.com/Wei-Shaw/claude-relay-service.git
    log_success "已添加上游远程仓库"
fi

# 获取最新的上游更新
log_info "获取上游最新更新..."
git fetch upstream

# 检查是否有新更新
CURRENT_HEAD=$(git rev-parse HEAD)
UPSTREAM_HEAD=$(git rev-parse upstream/main)

log_info "当前提交: $CURRENT_HEAD"
log_info "上游提交: $UPSTREAM_HEAD"

# 查找最后一次同步
LAST_SYNC=$(git log --grep="上游提交: upstream:" --format="%H" -n 1 2>/dev/null || echo "")
if [ -n "$LAST_SYNC" ]; then
    LAST_UPSTREAM=$(git log --format="%s" -n 1 $LAST_SYNC | grep -o 'upstream:[a-f0-9]*' | cut -d':' -f2 2>/dev/null || echo "")
    log_info "上次同步提交: $LAST_UPSTREAM"
else
    log_warning "这是首次同步"
    LAST_UPSTREAM=""
fi

if [ "$UPSTREAM_HEAD" = "$LAST_UPSTREAM" ]; then
    log_success "已是最新版本，无需同步"
    exit 0
fi

log_info "发现新的上游更新，开始同步..."

# 获取变更文件列表
if [ -n "$LAST_UPSTREAM" ]; then
    CHANGED_FILES=$(git diff --name-only $LAST_UPSTREAM..$UPSTREAM_HEAD 2>/dev/null || git diff --name-only upstream/main)
else
    CHANGED_FILES=$(git diff --name-only upstream/main 2>/dev/null || echo "")
fi

if [ -z "$CHANGED_FILES" ]; then
    log_warning "没有发现文件变更"
    exit 0
fi

log_info "发现以下文件有变更:"
echo "$CHANGED_FILES" | while read file; do
    echo "  - $file"
done

# 创建备份分支
BACKUP_BRANCH="backup-before-sync-$(date +%s)"
git checkout -b $BACKUP_BRANCH
git checkout main
log_success "已创建备份分支: $BACKUP_BRANCH"

# 创建临时工作分支
TEMP_BRANCH="temp-sync-$(date +%s)"
git checkout -b $TEMP_BRANCH
log_success "已创建临时工作分支: $TEMP_BRANCH"

# 处理每个变更文件
echo "$CHANGED_FILES" | while IFS= read -r file; do
    [ -z "$file" ] && continue
    
    log_info "处理文件: $file"
    
    # 检查是否是受保护文件
    PROTECTED=false
    case "$file" in
        ".github/workflows/auto-release-pipeline.yml"|"README.md"|"VERSION"|".duannai-sync-config")
            PROTECTED=true
            ;;
    esac
    
    if [ "$PROTECTED" = true ]; then
        log_warning "跳过受保护文件: $file"
        continue
    fi
    
    # 检查上游文件是否存在
    if git show upstream/main:$file > /dev/null 2>&1; then
        # 获取上游文件内容
        mkdir -p "$(dirname "/tmp/upstream_$file")"
        git show upstream/main:$file > "/tmp/upstream_$file"
        
        # 检查是否包含定制化内容
        HAS_CUSTOM=false
        if [ -f "$file" ]; then
            if grep -q "DuanNaiSheQu\|claude-duannai\|duannaishequ" "$file" 2>/dev/null; then
                HAS_CUSTOM=true
                log_warning "文件包含定制化内容: $file"
            fi
        fi
        
        if [ "$HAS_CUSTOM" = true ]; then
            log_info "执行智能合并: $file"
            # 创建智能合并版本
            cp "$file" "/tmp/current_$file" 2>/dev/null || touch "/tmp/current_$file"
            
            # 尝试自动合并
            if git merge-file "/tmp/current_$file" "/tmp/current_$file" "/tmp/upstream_$file" 2>/dev/null; then
                cp "/tmp/current_$file" "$file"
                log_success "自动合并成功: $file"
            else
                log_warning "合并冲突，保留当前版本: $file"
                # 添加TODO注释
                echo "# TODO: 手动合并上游更新 - $(date)" >> "$file"
            fi
        else
            log_info "直接更新文件: $file"
            # 复制上游文件并应用定制化替换
            cp "/tmp/upstream_$file" "$file"
            
            # 应用替换规则
            sed -i.bak 's/Wei-Shaw/DuanNaiSheQu/g' "$file" 2>/dev/null || true
            sed -i.bak 's/claude-relay-service/claude-duannai/g' "$file" 2>/dev/null || true
            sed -i.bak 's/weishaw/duannaishequ/g' "$file" 2>/dev/null || true
            rm -f "$file.bak" 2>/dev/null || true
        fi
        
        # 暂存文件
        git add "$file"
    else
        log_warning "文件在上游已删除: $file"
        if [ -f "$file" ] && ! grep -q "DuanNaiSheQu\|claude-duannai\|duannaishequ" "$file" 2>/dev/null; then
            git rm "$file" 2>/dev/null || rm -f "$file"
            log_success "已删除文件: $file"
        else
            log_warning "保留定制化文件: $file"
        fi
    fi
done

# 检查是否有变更需要提交
if git diff --staged --quiet; then
    log_warning "没有需要同步的变更"
    git checkout main
    git branch -D $TEMP_BRANCH
    git branch -D $BACKUP_BRANCH
    exit 0
fi

# 提交变更
COMMIT_MSG="🔄 智能同步上游更新

📦 同步来源: Wei-Shaw/claude-relay-service  
🔗 上游提交: upstream:$UPSTREAM_HEAD
📅 同步时间: $(date -u '+%Y-%m-%d %H:%M:%S UTC')

✨ 更新内容:
$(echo "$CHANGED_FILES" | sed 's/^/- /')

🛡️ 已保护定制化内容:
- DuanNaiSheQu 品牌标识
- claude-duannai 项目名称
- 专属工作流配置  
- 版本号管理

🤖 Generated by DuanNaiSheQu Sync Script"

git commit -m "$COMMIT_MSG"
log_success "已提交同步更改"

# 合并到主分支
git checkout main
git merge $TEMP_BRANCH --no-ff -m "Merge upstream sync: $(date '+%Y-%m-%d %H:%M:%S')"
log_success "已合并到主分支"

# 清理临时分支
git branch -D $TEMP_BRANCH
log_success "已清理临时分支"

# 询问是否推送
echo
read -p "是否要推送更新到远程仓库? (y/N): " push_confirm
if [[ $push_confirm =~ ^[Yy]$ ]]; then
    git push origin main
    log_success "✅ 同步完成并已推送到远程仓库！"
else
    log_info "同步完成，请手动推送: git push origin main"
fi

# 清理备份分支
read -p "是否删除备份分支 $BACKUP_BRANCH? (y/N): " cleanup_confirm
if [[ $cleanup_confirm =~ ^[Yy]$ ]]; then
    git branch -D $BACKUP_BRANCH
    log_success "已清理备份分支"
else
    log_info "备份分支保留为: $BACKUP_BRANCH"
fi

log_success "🎉 智能同步完成！"
log_info "🔗 您的仓库地址: https://github.com/DuanNaiSheQu/claude-duannai"
log_info "✅ 您的定制化内容已得到保护"