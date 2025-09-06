#!/bin/bash

# DuanNaiSheQu 实时同步管理器
# 用于管理实时代码同步系统

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置
WEBHOOK_PORT=${WEBHOOK_PORT:-8080}
WEBHOOK_SECRET=${WEBHOOK_SECRET:-"duannai-sync-secret-2024"}
LOG_FILE="logs/realtime-sync.log"

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

log_header() {
    echo -e "${PURPLE}🚀 $1${NC}"
    echo -e "${PURPLE}$(printf '=%.0s' {1..50})${NC}"
}

# 显示帮助信息
show_help() {
    echo -e "${CYAN}DuanNaiSheQu 实时代码同步管理器${NC}"
    echo
    echo "用法: $0 [命令]"
    echo
    echo "命令:"
    echo "  setup       - 初始化实时同步系统"
    echo "  start       - 启动webhook监听服务"
    echo "  stop        - 停止webhook监听服务"  
    echo "  status      - 查看系统状态"
    echo "  test        - 测试同步功能"
    echo "  trigger     - 手动触发实时同步"
    echo "  logs        - 查看同步日志"
    echo "  monitor     - 实时监控同步状态"
    echo "  config      - 配置系统参数"
    echo "  help        - 显示此帮助信息"
    echo
    echo "示例:"
    echo "  $0 setup                    # 初始化系统"
    echo "  $0 start                    # 启动服务"
    echo "  $0 trigger abc123           # 触发指定提交的同步"
    echo "  $0 logs --tail 50           # 查看最近50行日志"
}

# 检查依赖
check_dependencies() {
    log_info "检查系统依赖..."
    
    local missing_deps=()
    
    if ! command -v node &> /dev/null; then
        missing_deps+=("node.js")
    fi
    
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "缺少以下依赖："
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        exit 1
    fi
    
    log_success "所有依赖已满足"
}

# 初始化系统
setup_system() {
    log_header "初始化实时同步系统"
    
    check_dependencies
    
    # 创建日志目录
    mkdir -p logs
    log_success "创建日志目录"
    
    # 检查GitHub token
    if [ -z "$GITHUB_TOKEN" ]; then
        log_warning "未设置 GITHUB_TOKEN 环境变量"
        echo "请设置 GITHUB_TOKEN 以启用自动触发功能："
        echo "export GITHUB_TOKEN=your_github_token"
        echo
    else
        log_success "GitHub Token 已配置"
    fi
    
    # 检查上游连接
    log_info "检查上游仓库连接..."
    if git remote get-url upstream &> /dev/null; then
        log_success "上游仓库连接正常"
    else
        log_warning "添加上游远程仓库..."
        git remote add upstream https://github.com/Wei-Shaw/claude-relay-service.git
        log_success "上游仓库已添加"
    fi
    
    # 获取最新上游信息
    log_info "获取上游最新信息..."
    git fetch upstream
    log_success "上游信息已更新"
    
    # 创建配置文件
    if [ ! -f ".realtime-sync-config" ]; then
        cat > .realtime-sync-config << EOF
# DuanNaiSheQu 实时同步配置
WEBHOOK_PORT=$WEBHOOK_PORT
WEBHOOK_SECRET=$WEBHOOK_SECRET
UPSTREAM_REPO=Wei-Shaw/claude-relay-service
TARGET_REPO=DuanNaiSheQu/claude-duannai
LOG_LEVEL=info
AUTO_TRIGGER=true
NOTIFICATION_ENABLED=true
EOF
        log_success "配置文件已创建"
    fi
    
    log_success "🎉 实时同步系统初始化完成！"
    echo
    echo "下一步："
    echo "1. 设置 GitHub Token: export GITHUB_TOKEN=your_token"
    echo "2. 启动服务: $0 start"
    echo "3. 配置上游仓库 webhook (可选)"
}

# 启动服务
start_service() {
    log_header "启动实时同步服务"
    
    # 检查服务是否已运行
    if pgrep -f "webhook-listener.js" > /dev/null; then
        log_warning "服务已在运行中"
        show_status
        return
    fi
    
    log_info "启动webhook监听服务..."
    
    # 确保脚本可执行
    chmod +x scripts/webhook-listener.js
    
    # 启动服务（后台运行）
    nohup node scripts/webhook-listener.js > $LOG_FILE 2>&1 &
    local PID=$!
    
    # 等待服务启动
    sleep 2
    
    if kill -0 $PID 2>/dev/null; then
        echo $PID > .webhook-listener.pid
        log_success "服务已启动 (PID: $PID)"
        log_success "监听端口: $WEBHOOK_PORT"
        log_success "日志文件: $LOG_FILE"
        
        echo
        echo "🔗 Webhook 配置信息："
        echo "URL: http://your-domain:$WEBHOOK_PORT"
        echo "Secret: $WEBHOOK_SECRET"
        echo "Events: push"
    else
        log_error "服务启动失败"
        return 1
    fi
}

# 停止服务
stop_service() {
    log_header "停止实时同步服务"
    
    if [ -f ".webhook-listener.pid" ]; then
        local PID=$(cat .webhook-listener.pid)
        if kill -0 $PID 2>/dev/null; then
            kill $PID
            rm -f .webhook-listener.pid
            log_success "服务已停止 (PID: $PID)"
        else
            log_warning "PID文件存在但进程未运行，清理PID文件"
            rm -f .webhook-listener.pid
        fi
    else
        # 查找并停止所有相关进程
        local PIDS=$(pgrep -f "webhook-listener.js" || true)
        if [ -n "$PIDS" ]; then
            echo $PIDS | xargs kill
            log_success "已停止所有webhook监听进程"
        else
            log_warning "没有找到运行中的服务"
        fi
    fi
}

# 显示状态
show_status() {
    log_header "实时同步系统状态"
    
    # 服务状态
    if pgrep -f "webhook-listener.js" > /dev/null; then
        local PID=$(pgrep -f "webhook-listener.js")
        log_success "Webhook服务: 运行中 (PID: $PID)"
        echo "  端口: $WEBHOOK_PORT"
        echo "  日志: $LOG_FILE"
    else
        log_warning "Webhook服务: 未运行"
    fi
    
    # 上游连接状态
    if git remote get-url upstream &> /dev/null; then
        log_success "上游连接: 已配置"
        echo "  仓库: $(git remote get-url upstream)"
    else
        log_warning "上游连接: 未配置"
    fi
    
    # GitHub Actions 状态
    log_info "GitHub Actions 工作流:"
    if [ -f ".github/workflows/realtime-sync.yml" ]; then
        log_success "  实时同步工作流: 已配置"
    else
        log_warning "  实时同步工作流: 未找到"
    fi
    
    if [ -f ".github/workflows/sync-upstream.yml" ]; then
        log_success "  定时同步工作流: 已配置"
    else
        log_warning "  定时同步工作流: 未找到"
    fi
    
    # 环境变量
    echo
    echo "环境配置:"
    if [ -n "$GITHUB_TOKEN" ]; then
        log_success "  GITHUB_TOKEN: 已设置"
    else
        log_warning "  GITHUB_TOKEN: 未设置"
    fi
    
    # 最近同步记录
    echo
    echo "最近同步记录:"
    local recent_syncs=$(git log --grep="实时精确同步\|智能同步上游" --oneline -5 2>/dev/null || echo "")
    if [ -n "$recent_syncs" ]; then
        echo "$recent_syncs" | while IFS= read -r line; do
            echo "  $line"
        done
    else
        echo "  无同步记录"
    fi
}

# 测试同步功能
test_sync() {
    log_header "测试同步功能"
    
    log_info "获取上游最新信息..."
    git fetch upstream
    
    local current_head=$(git rev-parse HEAD)
    local upstream_head=$(git rev-parse upstream/main)
    
    echo "当前提交: $current_head"
    echo "上游提交: $upstream_head"
    
    if [ "$current_head" = "$upstream_head" ]; then
        log_success "代码已是最新，无需同步"
    else
        log_info "检测到代码差异，可以测试同步功能"
        
        echo "变更文件:"
        git diff --name-only HEAD upstream/main | head -10 | while read file; do
            echo "  - $file"
        done
        
        echo
        read -p "是否要执行实际同步测试? (y/N): " test_confirm
        if [[ $test_confirm =~ ^[Yy]$ ]]; then
            trigger_sync "$upstream_head"
        fi
    fi
}

# 手动触发同步
trigger_sync() {
    local commit_sha=${1:-$(git rev-parse upstream/main)}
    
    log_header "手动触发实时同步"
    log_info "目标提交: $commit_sha"
    
    if [ -z "$GITHUB_TOKEN" ]; then
        log_error "需要设置 GITHUB_TOKEN 环境变量"
        return 1
    fi
    
    log_info "触发 GitHub Actions 工作流..."
    
    local payload='{
      "event_type": "upstream_push",
      "client_payload": {
        "upstream_commit": "'$commit_sha'",
        "commit_message": "手动触发的实时同步",
        "changed_files": [],
        "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
        "trigger_source": "manual"
      }
    }'
    
    local response=$(curl -s -X POST \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: token $GITHUB_TOKEN" \
      https://api.github.com/repos/DuanNaiSheQu/claude-duannai/dispatches \
      -d "$payload")
    
    if [ $? -eq 0 ]; then
        log_success "实时同步已触发！"
        log_info "查看进度: https://github.com/DuanNaiSheQu/claude-duannai/actions"
    else
        log_error "触发同步失败"
        echo "响应: $response"
    fi
}

# 查看日志
show_logs() {
    local tail_lines=${2:-20}
    
    log_header "实时同步日志"
    
    if [ -f "$LOG_FILE" ]; then
        if [ "$2" = "--tail" ] && [ -n "$3" ]; then
            tail_lines=$3
        fi
        
        echo "显示最近 $tail_lines 行日志："
        echo "----------------------------------------"
        tail -n $tail_lines "$LOG_FILE"
    else
        log_warning "日志文件不存在: $LOG_FILE"
    fi
}

# 实时监控
monitor_sync() {
    log_header "实时同步监控"
    
    log_info "开始监控同步状态 (Ctrl+C 退出)..."
    echo "----------------------------------------"
    
    while true; do
        clear
        echo -e "${CYAN}DuanNaiSheQu 实时同步监控 - $(date)${NC}"
        echo "========================================"
        
        # 服务状态
        if pgrep -f "webhook-listener.js" > /dev/null; then
            echo -e "${GREEN}✅ Webhook服务: 运行中${NC}"
        else
            echo -e "${RED}❌ Webhook服务: 停止${NC}"
        fi
        
        # 最新日志
        if [ -f "$LOG_FILE" ]; then
            echo -e "${BLUE}📋 最新日志 (最后5行):${NC}"
            tail -n 5 "$LOG_FILE" | while IFS= read -r line; do
                echo "  $line"
            done
        fi
        
        # 等待刷新
        sleep 5
    done
}

# 配置系统
configure_system() {
    log_header "系统配置"
    
    echo "当前配置:"
    if [ -f ".realtime-sync-config" ]; then
        cat .realtime-sync-config | while IFS= read -r line; do
            echo "  $line"
        done
    else
        log_warning "配置文件不存在，将创建默认配置"
        setup_system
        return
    fi
    
    echo
    read -p "是否要修改配置? (y/N): " config_confirm
    if [[ $config_confirm =~ ^[Yy]$ ]]; then
        ${EDITOR:-nano} .realtime-sync-config
        log_success "配置已更新"
    fi
}

# 主函数
main() {
    case "${1:-help}" in
        "setup")
            setup_system
            ;;
        "start")
            start_service
            ;;
        "stop")
            stop_service
            ;;
        "status")
            show_status
            ;;
        "test")
            test_sync
            ;;
        "trigger")
            trigger_sync "$2"
            ;;
        "logs")
            show_logs "$@"
            ;;
        "monitor")
            monitor_sync
            ;;
        "config")
            configure_system
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            log_error "未知命令: $1"
            echo
            show_help
            exit 1
            ;;
    esac
}

# 检查是否在git仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_error "请在git仓库根目录中运行此脚本"
    exit 1
fi

# 执行主函数
main "$@"