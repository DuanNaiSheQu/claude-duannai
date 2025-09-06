<template>
  <div
    class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-blue-900"
  >
    <!-- 主要内容容器 -->
    <div class="container mx-auto px-4 py-8 lg:px-8">
      <!-- 顶部导航栏 -->
      <nav class="animate-fade-in-up mb-8 flex items-center justify-between sm:mb-12">
        <div class="flex min-w-0 flex-1 items-center space-x-2 sm:space-x-3">
          <div
            :class="[
              'animate-glow flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-xl sm:h-10 sm:w-10',
              oemSettings.siteIconData ? '' : 'bg-gradient-to-br from-blue-500 to-purple-600'
            ]"
          >
            <img
              v-if="oemSettings.siteIconData"
              :alt="oemSettings.siteName || 'Claude Relay Service'"
              class="h-8 w-8 rounded-lg object-cover sm:h-10 sm:w-10"
              :src="oemSettings.siteIconData"
            />
            <i
              v-else
              class="fas fa-project-diagram animate-pulse text-sm text-white sm:text-lg"
            ></i>
          </div>
          <span
            class="animate-slide-in-left animation-delay-200 truncate text-lg font-bold text-gray-900 dark:text-white sm:text-xl"
          >
            {{ oemSettings.siteName || 'Claude Relay Service' }}
          </span>
        </div>
        <ThemeToggle
          class="animate-slide-in-right animation-delay-300 flex-shrink-0"
          mode="compact"
        />
      </nav>

      <!-- 主要内容区域 -->
      <div class="grid items-center gap-6 sm:gap-8 md:gap-12 lg:grid-cols-4">
        <!-- 左侧内容区域 -->
        <div class="space-y-6 sm:space-y-8 lg:col-span-2">
          <div class="space-y-4 sm:space-y-6">
            <h1
              class="animate-fade-in-up text-2xl font-bold leading-tight sm:text-3xl md:text-4xl lg:text-5xl xl:text-6xl"
            >
              <span class="animate-slide-in-left block text-gray-900 dark:text-white sm:inline">{{
                oemSettings.siteName || 'Claude Relay Service'
              }}</span>
              <span
                class="animate-slide-in-right animate-gradient-x mt-1 block bg-gradient-to-r from-blue-500 to-purple-600 bg-clip-text text-transparent sm:mt-0"
              >
                智能 AI 编程新平台
              </span>
            </h1>
            <p
              class="animate-fade-in-up animation-delay-200 max-w-full text-base leading-relaxed text-gray-600 dark:text-gray-300 sm:text-lg lg:max-w-lg"
            >
              整合 Claude、Gemini、OpenAI
              等顶尖技术，打造专属中转服务，让中国开发者用更低成本，享受同等优质的 AI 编程能力
            </p>
          </div>

          <!-- 特性列表 -->
          <div class="space-y-3 sm:space-y-4">
            <div class="animate-fade-in-up animation-delay-300 flex items-center space-x-3">
              <div
                class="animate-bounce-slow flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-lg bg-blue-100 dark:bg-blue-900/50"
              >
                <i class="fas fa-chart-bar text-sm text-blue-600 dark:text-blue-400"></i>
              </div>
              <span class="text-sm text-gray-700 dark:text-gray-300 sm:text-base"
                >智能 AI 代码生成和优化建议</span
              >
            </div>
            <div class="animate-fade-in-up animation-delay-400 flex items-center space-x-3">
              <div
                class="flex h-8 w-8 flex-shrink-0 animate-float items-center justify-center rounded-lg bg-purple-100 dark:bg-purple-900/50"
              >
                <i class="fas fa-shield-alt text-sm text-purple-600 dark:text-purple-400"></i>
              </div>
              <span class="text-sm text-gray-700 dark:text-gray-300 sm:text-base"
                >成本降低高达 50% 的数据中转服务</span
              >
            </div>
            <div class="animate-fade-in-up animation-delay-500 flex items-center space-x-3">
              <div
                class="animate-glow flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-lg bg-green-100 dark:bg-green-900/50"
              >
                <i class="fas fa-cog text-sm text-green-600 dark:text-green-400"></i>
              </div>
              <span class="text-sm text-gray-700 dark:text-gray-300 sm:text-base"
                >多平台支持和统一管理</span
              >
            </div>
            <div class="animate-fade-in-up animation-delay-600 flex items-center space-x-3">
              <div
                class="flex h-8 w-8 flex-shrink-0 animate-pulse items-center justify-center rounded-lg bg-orange-100 dark:bg-orange-900/50"
              >
                <i class="fas fa-rocket text-sm text-orange-600 dark:text-orange-400"></i>
              </div>
              <span class="text-sm text-gray-700 dark:text-gray-300 sm:text-base"
                >专业级的安全和稳定性保障</span
              >
            </div>
          </div>

          <!-- 行动按钮 -->
          <div class="flex flex-col gap-3 pt-4 sm:flex-row sm:gap-4">
            <button
              class="animate-fade-in-up animation-delay-700 group relative transform overflow-hidden rounded-2xl bg-gradient-to-r from-blue-500 to-purple-600 px-6 py-3 text-sm font-semibold text-white transition-all duration-300 hover:-translate-y-1 hover:shadow-2xl hover:shadow-blue-500/25 sm:px-8 sm:py-4 sm:text-base"
              @click="currentTab = 'stats'"
            >
              <span class="relative z-10 flex items-center justify-center space-x-2">
                <i class="fas fa-chart-line animate-pulse"></i>
                <span>查询编程用量</span>
              </span>
              <div
                class="absolute inset-0 bg-gradient-to-r from-blue-600 to-purple-700 opacity-0 transition-opacity duration-300 group-hover:opacity-100"
              ></div>
            </button>
            <button
              class="animate-fade-in-up animation-delay-800 group transform rounded-2xl border-2 border-gray-300 bg-white px-6 py-3 text-sm font-semibold text-gray-700 transition-all duration-300 hover:-translate-y-1 hover:border-blue-400 hover:bg-blue-50 dark:border-gray-600 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-blue-900/50 sm:px-8 sm:py-4 sm:text-base"
              @click="currentTab = 'tutorial'"
            >
              <span class="flex items-center justify-center space-x-2">
                <i class="fas fa-graduation-cap animate-bounce"></i>
                <span>查看教程</span>
              </span>
            </button>
          </div>
        </div>

        <!-- 右侧演示区域 -->
        <div class="animate-fade-in-up animation-delay-400 relative mt-8 lg:col-span-2 lg:mt-0">
          <!-- 代码演示窗口 -->
          <div
            class="relative max-w-full transform animate-float overflow-hidden rounded-2xl bg-gray-900 shadow-2xl transition-transform duration-500 sm:rounded-3xl lg:rotate-1 lg:hover:rotate-0"
          >
            <!-- 窗口标题栏 -->
            <div class="flex items-center justify-between bg-gray-800 px-3 py-2 sm:px-6 sm:py-4">
              <div class="flex space-x-1 sm:space-x-2">
                <div
                  class="animation-delay-100 h-2 w-2 animate-pulse rounded-full bg-red-500 sm:h-3 sm:w-3"
                ></div>
                <div
                  class="animation-delay-200 h-2 w-2 animate-pulse rounded-full bg-yellow-500 sm:h-3 sm:w-3"
                ></div>
                <div
                  class="animation-delay-300 h-2 w-2 animate-pulse rounded-full bg-green-500 sm:h-3 sm:w-3"
                ></div>
              </div>
              <div
                class="animate-slide-in-right animation-delay-600 ml-2 truncate text-xs text-gray-400 sm:text-xs"
              >
                支持语言: JAVA • Python • Go
              </div>
            </div>

            <!-- 代码内容 -->
            <div class="overflow-hidden p-3 text-sm leading-relaxed sm:p-6 sm:text-base">
              <div
                class="animate-slide-in-left animation-delay-700 mb-2 text-xs text-blue-300 sm:mb-3 sm:text-sm"
              >
                🚀 正在调用 AI 编程助手服务...
              </div>

              <!-- 简化的代码块 -->
              <div
                class="animate-fade-in-up animation-delay-800 overflow-x-auto rounded-lg bg-gray-800/50 p-2 sm:p-4"
              >
                <pre
                  class="whitespace-pre-wrap break-words text-xs sm:text-sm"
                ><code class="text-cyan-300"><span class="text-yellow-300">getCodingAssistant</span>(<span class="text-orange-300">prompt</span>) {
  <span class="text-purple-400">fetch</span>(<span class="text-green-300">'/api/v1/messages'</span>, {
    <span class="text-orange-300">method</span>: <span class="text-green-300">'POST'</span>,
    <span class="text-orange-300">body</span>: <span class="text-yellow-300">JSON</span>.stringify({
      <span class="text-orange-300">model</span>: <span class="text-green-300">'claude-sonnet-4'</span>,
      <span class="text-orange-300">messages</span>: [{ 
        <span class="text-orange-300">content</span>: prompt 
      }]
    })
  })
}</code></pre>
              </div>

              <div
                class="animate-slide-in-left animation-delay-900 mt-2 text-xs text-green-400 sm:mt-4 sm:text-sm"
              >
                ✨ AI 编程助手响应完成！节省 60% 成本
              </div>
            </div>
          </div>

          <!-- 装饰元素 -->
          <div
            class="animation-delay-500 absolute -right-2 -top-2 hidden h-16 w-16 animate-float rounded-full bg-gradient-to-br from-blue-400/20 to-purple-400/20 blur-xl sm:-right-4 sm:-top-4 sm:block sm:h-24 sm:w-24"
          ></div>
          <div
            class="animate-bounce-slow animation-delay-800 absolute -bottom-4 -left-2 hidden h-20 w-20 rounded-full bg-gradient-to-br from-purple-400/20 to-pink-400/20 blur-xl sm:-bottom-8 sm:-left-4 sm:block sm:h-32 sm:w-32"
          ></div>
        </div>
      </div>

      <!-- 套餐推荐卡片 -->
      <div class="mt-20">
        <div class="mb-8 text-center">
          <h2 class="mb-3 text-3xl font-bold text-gray-900 dark:text-white lg:text-4xl">
            AI 套餐推荐
          </h2>
          <p class="mx-auto max-w-2xl text-gray-600 dark:text-gray-300">
            根据你的使用场景选择最合适的模型套餐，支持一键接入与统一统计
          </p>
        </div>

        <div class="grid grid-cols-1 gap-6 md:grid-cols-3 xl:gap-8">
          <!-- Service Plan Cards -->
          <div
            v-for="plan in servicePlans"
            :key="plan.id"
            class="group transform transition-all duration-300 hover:-translate-y-2"
          >
            <div
              class="relative flex h-full flex-col rounded-3xl bg-white p-8 shadow-lg dark:bg-gray-800"
            >
              <div
                class="absolute right-6 top-6 rounded-full px-3 py-1 text-xs font-semibold text-white"
                :class="plan.tagClass"
              >
                {{ plan.tag }}
              </div>
              <div
                class="mb-6 flex h-16 w-16 items-center justify-center rounded-2xl"
                :class="plan.iconBg"
              >
                <i class="text-2xl text-white" :class="plan.icon"></i>
              </div>
              <h3 class="mb-1 text-xl font-bold text-gray-900 dark:text-white">{{ plan.name }}</h3>
              <p class="mb-4 text-sm text-gray-500 dark:text-gray-400">
                {{ plan.description }}
              </p>
              <ul class="mb-6 space-y-2 text-sm text-gray-700 dark:text-gray-300">
                <li v-for="feature in plan.features" :key="feature" class="flex items-center gap-2">
                  <i class="fas fa-check" :class="plan.featureIconClass"></i>
                  {{ feature }}
                </li>
              </ul>
              <div class="mt-auto flex items-end justify-end">
                <span
                  class="rounded-xl bg-gray-200 px-4 py-2 text-sm font-semibold text-gray-700 dark:bg-gray-700 dark:text-gray-300"
                  >介绍</span
                >
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 为什么选择我们 -->
      <div class="mt-20">
        <div class="mb-12 text-center">
          <h2 class="mb-4 text-3xl font-bold text-gray-900 dark:text-white lg:text-4xl">
            为什么选择我们的AI中转服务？
          </h2>
          <p class="mx-auto max-w-2xl text-gray-600 dark:text-gray-300">
            整合全球顶尖AI模型，为您提供稳定、高效、低成本的统一API接入服务。
          </p>
        </div>

        <!-- 特性网格 -->
        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-6 lg:grid-cols-3 xl:gap-8">
          <!-- 智能代码生成 -->
          <div
            class="group transform transition-all duration-300 hover:-translate-y-2 hover:shadow-xl"
          >
            <div
              class="flex h-full flex-col rounded-2xl bg-white p-4 shadow-lg dark:bg-gray-800 sm:rounded-3xl sm:p-6 lg:p-8"
            >
              <div
                class="mb-4 flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-blue-500 to-purple-600 sm:mb-6 sm:h-16 sm:w-16 sm:rounded-2xl"
              >
                <i class="fas fa-code text-lg text-white sm:text-2xl"></i>
              </div>
              <h3 class="mb-3 text-lg font-bold text-gray-900 dark:text-white sm:mb-4 sm:text-xl">
                智能代码生成
              </h3>
              <p class="text-sm leading-relaxed text-gray-600 dark:text-gray-300 sm:text-base">
                基于Claude，gemini，openai技术，自动生成高质量的代码片段，提升开发效率
              </p>
            </div>
          </div>

          <!-- 错误诊断修复 -->
          <div
            class="group transform transition-all duration-300 hover:-translate-y-2 hover:shadow-xl"
          >
            <div
              class="flex h-full flex-col rounded-2xl bg-white p-4 shadow-lg dark:bg-gray-800 sm:rounded-3xl sm:p-6 lg:p-8"
            >
              <div
                class="mb-4 flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-red-500 to-orange-500 sm:mb-6 sm:h-16 sm:w-16 sm:rounded-2xl"
              >
                <i class="fas fa-bug text-lg text-white sm:text-2xl"></i>
              </div>
              <h3 class="mb-3 text-lg font-bold text-gray-900 dark:text-white sm:mb-4 sm:text-xl">
                错误诊断修复
              </h3>
              <p class="text-sm leading-relaxed text-gray-600 dark:text-gray-300 sm:text-base">
                智能识别代码错误，提供精准的修复建议和优化方案
              </p>
            </div>
          </div>

          <!-- 代码重构优化 -->
          <div
            class="group transform transition-all duration-300 hover:-translate-y-2 hover:shadow-xl"
          >
            <div
              class="flex h-full flex-col rounded-2xl bg-white p-4 shadow-lg dark:bg-gray-800 sm:rounded-3xl sm:p-6 lg:p-8"
            >
              <div
                class="mb-4 flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-green-500 to-teal-500 sm:mb-6 sm:h-16 sm:w-16 sm:rounded-2xl"
              >
                <i class="fas fa-sync-alt text-lg text-white sm:text-2xl"></i>
              </div>
              <h3 class="mb-3 text-lg font-bold text-gray-900 dark:text-white sm:mb-4 sm:text-xl">
                代码重构优化
              </h3>
              <p class="text-sm leading-relaxed text-gray-600 dark:text-gray-300 sm:text-base">
                分析现有代码结构，提供最佳实践的重构建议
              </p>
            </div>
          </div>

          <!-- 多语言支持 -->
          <div
            class="group transform transition-all duration-300 hover:-translate-y-2 hover:shadow-xl"
          >
            <div
              class="flex h-full flex-col rounded-2xl bg-white p-4 shadow-lg dark:bg-gray-800 sm:rounded-3xl sm:p-6 lg:p-8"
            >
              <div
                class="mb-4 flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-purple-500 to-pink-500 sm:mb-6 sm:h-16 sm:w-16 sm:rounded-2xl"
              >
                <i class="fas fa-globe text-lg text-white sm:text-2xl"></i>
              </div>
              <h3 class="mb-3 text-lg font-bold text-gray-900 dark:text-white sm:mb-4 sm:text-xl">
                多语言支持
              </h3>
              <p class="text-sm leading-relaxed text-gray-600 dark:text-gray-300 sm:text-base">
                支持20+主流编程语言，满足不同开发场景需求
              </p>
            </div>
          </div>

          <!-- Git集成 -->
          <div
            class="group transform transition-all duration-300 hover:-translate-y-2 hover:shadow-xl"
          >
            <div
              class="flex h-full flex-col rounded-2xl bg-white p-4 shadow-lg dark:bg-gray-800 sm:rounded-3xl sm:p-6 lg:p-8"
            >
              <div
                class="mb-4 flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-gray-700 to-gray-900 sm:mb-6 sm:h-16 sm:w-16 sm:rounded-2xl"
              >
                <i class="fab fa-git-alt text-lg text-white sm:text-2xl"></i>
              </div>
              <h3 class="mb-3 text-lg font-bold text-gray-900 dark:text-white sm:mb-4 sm:text-xl">
                Git集成
              </h3>
              <p class="text-sm leading-relaxed text-gray-600 dark:text-gray-300 sm:text-base">
                无缝集成Git工作流，智能生成提交信息和分支管理
              </p>
            </div>
          </div>

          <!-- 项目理解 -->
          <div
            class="group transform transition-all duration-300 hover:-translate-y-2 hover:shadow-xl"
          >
            <div
              class="flex h-full flex-col rounded-2xl bg-white p-4 shadow-lg dark:bg-gray-800 sm:rounded-3xl sm:p-6 lg:p-8"
            >
              <div
                class="mb-4 flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-500 to-blue-600 sm:mb-6 sm:h-16 sm:w-16 sm:rounded-2xl"
              >
                <i class="fas fa-brain text-lg text-white sm:text-2xl"></i>
              </div>
              <h3 class="mb-3 text-lg font-bold text-gray-900 dark:text-white sm:mb-4 sm:text-xl">
                项目理解
              </h3>
              <p class="text-sm leading-relaxed text-gray-600 dark:text-gray-300 sm:text-base">
                深度理解项目架构，提供上下文感知的代码建议
              </p>
            </div>
          </div>
        </div>

        <!-- 统计数据展示 -->
        <div class="mt-16 text-center lg:mt-20">
          <div class="grid grid-cols-2 gap-6 sm:gap-8 md:grid-cols-4">
            <div class="space-y-2">
              <div class="text-3xl font-bold text-blue-600 dark:text-blue-400 sm:text-4xl">
                1000+
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-300 sm:text-base">活跃开发者</div>
            </div>
            <div class="space-y-2">
              <div class="text-3xl font-bold text-purple-600 dark:text-purple-400 sm:text-4xl">
                20+
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-300 sm:text-base">编程语言</div>
            </div>
            <div class="space-y-2">
              <div class="text-3xl font-bold text-green-600 dark:text-green-400 sm:text-4xl">
                99.9%
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-300 sm:text-base">服务可用性</div>
            </div>
            <div class="space-y-2">
              <div class="text-3xl font-bold text-orange-600 dark:text-orange-400 sm:text-4xl">
                24/7
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-300 sm:text-base">技术支持</div>
            </div>
          </div>
        </div>

        <!-- 用户评价区域 -->
        <div class="mt-20 lg:mt-24">
          <div class="mb-12 text-center">
            <h2 class="mb-4 text-3xl font-bold text-gray-900 dark:text-white lg:text-4xl">
              用户怎么说
            </h2>
            <p class="mx-auto max-w-2xl text-gray-600 dark:text-gray-300">
              已有1000+开发者选择{{
                oemSettings.siteName || 'Claude Relay Service'
              }}，听听他们的真实体验
            </p>
          </div>

          <!-- 用户类型分布 -->
          <div class="mb-12 text-center">
            <div class="flex flex-wrap items-center justify-center gap-8">
              <div class="text-center">
                <div class="text-3xl font-bold text-blue-600 dark:text-blue-400">45%</div>
                <div class="text-sm text-gray-600 dark:text-gray-300">企业用户</div>
              </div>
              <div class="text-center">
                <div class="text-3xl font-bold text-cyan-500 dark:text-cyan-400">35%</div>
                <div class="text-sm text-gray-600 dark:text-gray-300">个人开发者</div>
              </div>
              <div class="text-center">
                <div class="text-3xl font-bold text-orange-500 dark:text-orange-400">20%</div>
                <div class="text-sm text-gray-600 dark:text-gray-300">学生用户</div>
              </div>
            </div>
          </div>

          <!-- 用户评价卡片 -->
          <div class="grid grid-cols-1 gap-6 lg:grid-cols-3 xl:gap-8">
            <!-- 企业用户评价 -->
            <div class="group transform transition-all duration-300 hover:-translate-y-2">
              <div
                class="flex h-full flex-col rounded-3xl bg-white p-6 shadow-lg dark:bg-gray-800 lg:p-8"
              >
                <div class="mb-4 flex items-center gap-4">
                  <div
                    class="flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br from-blue-500 to-blue-600"
                  >
                    <i class="fas fa-building text-xl text-white"></i>
                  </div>
                  <div>
                    <h4 class="font-semibold text-gray-900 dark:text-white">星辰科技</h4>
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                      技术团队 • 50-100人 • 企业版
                    </p>
                  </div>
                </div>
                <blockquote class="mb-6 text-gray-600 dark:text-gray-300">
                  "使用{{
                    oemSettings.siteName || 'Claude Relay Service'
                  }}后，我们团队的代码审查效率提升了60%，bug发现率提高了40%。特别是在重构老旧代码时，AI给出的建议非常精准。"
                </blockquote>
                <div class="grid grid-cols-2 gap-4 text-center">
                  <div>
                    <div class="text-2xl font-bold text-blue-600 dark:text-blue-400">60%</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">效率提升</div>
                  </div>
                  <div>
                    <div class="text-2xl font-bold text-red-500 dark:text-red-400">40%</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">Bug减少</div>
                  </div>
                  <div class="col-span-2">
                    <div class="text-2xl font-bold text-green-600 dark:text-green-400">95%</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">满意度</div>
                  </div>
                </div>
                <div class="mt-4 text-sm text-gray-400 dark:text-gray-500">— 技术总监 陈智辉</div>
              </div>
            </div>

            <!-- 个人开发者评价 -->
            <div class="group transform transition-all duration-300 hover:-translate-y-2">
              <div
                class="flex h-full flex-col rounded-3xl bg-white p-6 shadow-lg dark:bg-gray-800 lg:p-8"
              >
                <div class="mb-4 flex items-center gap-4">
                  <div
                    class="flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br from-cyan-500 to-cyan-600"
                  >
                    <i class="fas fa-user-cog text-xl text-white"></i>
                  </div>
                  <div>
                    <h4 class="font-semibold text-gray-900 dark:text-white">独立开发者</h4>
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                      个人开发 • 全栈开发 • 专业版
                    </p>
                  </div>
                </div>
                <blockquote class="mb-6 text-gray-600 dark:text-gray-300">
                  "作为个人开发者，{{
                    oemSettings.siteName || 'Claude Relay Service'
                  }}就像我的编程伙伴。无论是新技术学习还是项目开发，都能提供很好的帮助，大大节省了我的开发时间。"
                </blockquote>
                <div class="grid grid-cols-2 gap-4 text-center">
                  <div>
                    <div class="text-2xl font-bold text-cyan-500 dark:text-cyan-400">50%</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">时间节省</div>
                  </div>
                  <div>
                    <div class="text-2xl font-bold text-purple-600 dark:text-purple-400">80%</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">生产力提升</div>
                  </div>
                  <div class="col-span-2">
                    <div class="text-2xl font-bold text-blue-600 dark:text-blue-400">快速</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">学习速度</div>
                  </div>
                </div>
                <div class="mt-4 text-sm text-gray-400 dark:text-gray-500">— 全栈工程师 李智慧</div>
              </div>
            </div>

            <!-- 学生用户评价 -->
            <div class="group transform transition-all duration-300 hover:-translate-y-2">
              <div
                class="flex h-full flex-col rounded-3xl bg-white p-6 shadow-lg dark:bg-gray-800 lg:p-8"
              >
                <div class="mb-4 flex items-center gap-4">
                  <div
                    class="flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br from-orange-500 to-orange-600"
                  >
                    <i class="fas fa-graduation-cap text-xl text-white"></i>
                  </div>
                  <div>
                    <h4 class="font-semibold text-gray-900 dark:text-white">金星科技</h4>
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                      金融科技 • 100-200人 • 企业版
                    </p>
                  </div>
                </div>
                <blockquote class="mb-6 text-gray-600 dark:text-gray-300">
                  "在金融级的代码质量要求下，{{
                    oemSettings.siteName || 'Claude Relay Service'
                  }}帮助我们保持了高标准的代码规范，同时显著提升了开发效率。安全性和准确性都让我们很满意。"
                </blockquote>
                <div class="grid grid-cols-2 gap-4 text-center">
                  <div>
                    <div class="text-2xl font-bold text-orange-600 dark:text-orange-400">95%</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">代码质量</div>
                  </div>
                  <div>
                    <div class="text-2xl font-bold text-green-600 dark:text-green-400">100%</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">合规性</div>
                  </div>
                  <div class="col-span-2">
                    <div class="text-2xl font-bold text-blue-600 dark:text-blue-400">45%</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">效率提升</div>
                  </div>
                </div>
                <div class="mt-4 text-sm text-gray-400 dark:text-gray-500">— 架构师 王智强</div>
              </div>
            </div>
          </div>
        </div>

        <!-- 准备开始区域 -->
        <div class="mt-20 lg:mt-24">
          <div
            class="rounded-3xl bg-gradient-to-r from-blue-600 via-purple-600 to-blue-700 p-8 text-center text-white lg:p-12"
          >
            <h2 class="mb-4 text-3xl font-bold lg:text-4xl">准备开始您的AI编程之旅？</h2>
            <p class="mb-8 text-lg opacity-90 lg:text-xl">专业客服团队随时为您提供咨询和技术支持</p>
            <div class="flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
              <button
                class="group relative overflow-hidden rounded-2xl bg-white bg-opacity-20 px-8 py-4 font-semibold text-white backdrop-blur-sm transition-all duration-300 hover:bg-opacity-30 hover:shadow-2xl"
              >
                <span class="flex items-center gap-2">
                  <i class="fas fa-headset"></i>
                  联系下方客服
                </span>
              </button>
              <button
                class="group relative overflow-hidden rounded-2xl border-2 border-white border-opacity-30 px-8 py-4 font-semibold text-white transition-all duration-300 hover:bg-white hover:bg-opacity-10 hover:shadow-2xl"
                @click="currentTab = 'tutorial'"
              >
                <span class="flex items-center gap-2">
                  <i class="fas fa-book-open"></i>
                  查看安装教程
                </span>
              </button>
            </div>

            <!-- 服务信息 -->
            <div class="mt-12 grid grid-cols-1 gap-8 md:grid-cols-2">
              <div class="flex items-center justify-center gap-3">
                <div
                  class="flex h-12 w-12 items-center justify-center rounded-full bg-white bg-opacity-20"
                >
                  <i class="fas fa-comments text-xl"></i>
                </div>
                <div class="text-left">
                  <div class="font-semibold">在线客服</div>
                  <div class="text-sm opacity-80">微信服务号搜：Geek星途</div>
                </div>
              </div>
              <div class="flex items-center justify-center gap-3">
                <div
                  class="flex h-12 w-12 items-center justify-center rounded-full bg-white bg-opacity-20"
                >
                  <i class="fas fa-clock text-xl"></i>
                </div>
                <div class="text-left">
                  <div class="font-semibold">服务时间</div>
                  <div class="text-sm opacity-80">周一至周五 9:00-18:00</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 页脚 -->
    <footer class="mt-20 bg-gray-900 text-gray-300">
      <div class="container mx-auto px-4 py-12 lg:px-8">
        <div class="grid grid-cols-1 gap-8 md:grid-cols-4">
          <!-- 公司信息 -->
          <div class="md:col-span-2">
            <div class="mb-6 flex items-center space-x-3">
              <div
                :class="[
                  'flex h-10 w-10 items-center justify-center rounded-xl',
                  oemSettings.siteIconData ? '' : 'bg-gradient-to-br from-blue-500 to-purple-600'
                ]"
              >
                <img
                  v-if="oemSettings.siteIconData"
                  :alt="oemSettings.siteName || 'Claude Relay Service'"
                  class="h-10 w-10 rounded-lg object-cover"
                  :src="oemSettings.siteIconData"
                />
                <i v-else class="fas fa-project-diagram text-lg text-white"></i>
              </div>
              <span class="text-xl font-bold text-white">
                {{ oemSettings.siteName || 'Claude Relay Service' }}
              </span>
            </div>
            <p class="mb-6 max-w-md text-gray-400">
              基于最先进的Claude，gemini，openai技术，为中国开发者提供专业级的API使用统计分析平台，让您的开发工作更加高效、智能。
            </p>
            <div class="flex space-x-4">
              <a class="text-gray-400 transition-colors hover:text-blue-400" href="#">
                <i class="fab fa-github text-xl"></i>
              </a>
              <a class="text-gray-400 transition-colors hover:text-blue-400" href="#">
                <i class="fab fa-twitter text-xl"></i>
              </a>
              <a class="text-gray-400 transition-colors hover:text-blue-400" href="#">
                <i class="fab fa-discord text-xl"></i>
              </a>
            </div>
          </div>

          <!-- 产品 -->
          <div>
            <h3 class="mb-4 text-lg font-semibold text-white">产品</h3>
            <ul class="space-y-2 text-sm">
              <li><a class="transition-colors hover:text-blue-400" href="#">API统计</a></li>
              <li><a class="transition-colors hover:text-blue-400" href="#">代码分析</a></li>
              <li><a class="transition-colors hover:text-blue-400" href="#">性能监控</a></li>
              <li><a class="transition-colors hover:text-blue-400" href="#">团队协作</a></li>
            </ul>
          </div>

          <!-- 支持 -->
          <div>
            <h3 class="mb-4 text-lg font-semibold text-white">支持</h3>
            <ul class="space-y-2 text-sm">
              <li><a class="transition-colors hover:text-blue-400" href="#">帮助中心</a></li>
              <li><a class="transition-colors hover:text-blue-400" href="#">API文档</a></li>
              <li><a class="transition-colors hover:text-blue-400" href="#">社区论坛</a></li>
              <li><a class="transition-colors hover:text-blue-400" href="#">联系我们</a></li>
            </ul>
          </div>
        </div>

        <hr class="my-8 border-gray-800" />

        <div class="flex flex-col items-center justify-between gap-4 md:flex-row">
          <div class="text-sm text-gray-400">
            Copyright © 2025 {{ oemSettings.siteName || 'Claude Relay Service' }}. All rights
            reserved.
          </div>
          <div class="flex gap-6 text-sm">
            <a class="text-gray-400 transition-colors hover:text-blue-400" href="#">隐私政策</a>
            <a class="text-gray-400 transition-colors hover:text-blue-400" href="#">服务条款</a>
            <a class="text-gray-400 transition-colors hover:text-blue-400" href="#">法律声明</a>
          </div>
        </div>
      </div>
    </footer>

    <!-- 统计内容面板 -->
    <div
      v-if="currentTab === 'stats'"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4"
      @click.self="currentTab = null"
    >
      <div
        class="max-h-[90vh] w-full max-w-4xl overflow-auto rounded-3xl bg-white shadow-2xl dark:bg-gray-800"
      >
        <div
          class="sticky top-0 rounded-t-3xl border-b border-gray-200 bg-white p-6 dark:border-gray-700 dark:bg-gray-800"
        >
          <div class="flex items-center justify-between">
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white">🚀 AI 编程用量查询</h2>
            <button
              class="text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
              @click="currentTab = null"
            >
              <i class="fas fa-times text-xl"></i>
            </button>
          </div>
          <p class="mt-2 text-gray-600 dark:text-gray-300">
            查询您的 API Key 在 AI 编程服务中的用量统计和成本分析
          </p>
        </div>

        <div class="p-6">
          <!-- API Key 输入区域 -->
          <div class="mb-6">
            <ApiKeyInput />
          </div>

          <!-- 错误提示 -->
          <div v-if="error" class="mb-6">
            <div
              class="animate-shake rounded-2xl border border-red-200 bg-red-50 p-4 text-red-800 dark:border-red-800 dark:bg-red-900/20 dark:text-red-200"
            >
              <i class="fas fa-exclamation-triangle mr-2" />
              {{ error }}
            </div>
          </div>

          <!-- 统计数据展示区域 -->
          <div v-if="statsData" class="fade-in">
            <div class="space-y-6">
              <!-- 时间范围选择器 -->
              <div class="border-b border-gray-200 pb-6 dark:border-gray-700">
                <div
                  class="flex flex-col items-start justify-between gap-4 lg:flex-row lg:items-center"
                >
                  <div class="flex items-center gap-3">
                    <i class="fas fa-clock text-lg text-blue-500" />
                    <span class="text-lg font-medium text-gray-700 dark:text-gray-200"
                      >编程用量时间范围</span
                    >
                  </div>
                  <div class="flex flex-wrap gap-2">
                    <button
                      v-for="range in timeRanges"
                      :key="range.value"
                      class="rounded-xl px-4 py-2 text-sm font-medium transition-all duration-200 hover:scale-105"
                      :class="
                        selectedTimeRange === range.value
                          ? 'bg-blue-500 text-white shadow-lg'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600'
                      "
                      @click="selectTimeRange(range.value)"
                    >
                      {{ range.label }}
                    </button>
                  </div>
                </div>
              </div>

              <!-- 统计概览 -->
              <StatsOverview class="mb-6 rounded-2xl bg-gray-50 p-6 dark:bg-gray-900/50" />

              <!-- 统计图表展示 -->
              <div class="mb-6 grid grid-cols-1 gap-6 lg:grid-cols-2">
                <TokenDistribution class="rounded-2xl bg-gray-50 p-6 dark:bg-gray-900/50" />
                <LimitConfig class="rounded-2xl bg-gray-50 p-6 dark:bg-gray-900/50" />
              </div>

              <!-- 模型使用统计 -->
              <ModelUsageStats class="rounded-2xl bg-gray-50 p-6 dark:bg-gray-900/50" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 教程内容面板 -->
    <div
      v-if="currentTab === 'tutorial'"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4"
      @click.self="currentTab = null"
    >
      <div
        class="max-h-[90vh] w-full max-w-4xl overflow-auto rounded-3xl bg-white shadow-2xl dark:bg-gray-800"
      >
        <div
          class="sticky top-0 rounded-t-3xl border-b border-gray-200 bg-white p-6 dark:border-gray-700 dark:bg-gray-800"
        >
          <div class="flex items-center justify-between">
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white">🎓 使用教程</h2>
            <button
              class="text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
              @click="currentTab = null"
            >
              <i class="fas fa-times text-xl"></i>
            </button>
          </div>
          <p class="mt-2 text-gray-600 dark:text-gray-300">详细了解如何使用我们的服务</p>
        </div>
        <div class="p-6">
          <TutorialView />
        </div>
      </div>
    </div>

    <!-- 加载状态 -->
    <div v-if="loading" class="fixed inset-0 z-50 flex items-center justify-center bg-black/5">
      <div class="flex items-center gap-3 rounded-2xl bg-white p-6 shadow-2xl dark:bg-gray-800">
        <div class="h-8 w-8 animate-spin rounded-full border-b-2 border-blue-500"></div>
        <span class="font-medium text-gray-700 dark:text-gray-200">加载中...</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watchEffect } from 'vue'
import { useSettingsStore } from '@/stores/settings'
import { useApiStatsStore } from '@/stores/apistats'
import ThemeToggle from '@/components/common/ThemeToggle.vue'
import TutorialView from '@/views/TutorialView.vue'
import ApiKeyInput from '@/components/apistats/ApiKeyInput.vue'
import TokenDistribution from '@/components/apistats/TokenDistribution.vue'
import LimitConfig from '@/components/apistats/LimitConfig.vue'
import ModelUsageStats from '@/components/apistats/ModelUsageStats.vue'
import StatsOverview from '@/components/apistats/StatsOverview.vue'

// Stores
const settingsStore = useSettingsStore()
const apiStatsStore = useApiStatsStore()

// Data
const currentTab = ref(null)
const selectedTimeRange = ref('7d')

// Computed
const oemSettings = computed(() => settingsStore.oemSettings)
const statsData = computed(() => apiStatsStore.statsData)
const error = computed(() => apiStatsStore.error)
const loading = computed(() => settingsStore.loading || apiStatsStore.loading)

const timeRanges = [
  { label: '今天', value: '1d' },
  { label: '最近7天', value: '7d' },
  { label: '最近30天', value: '30d' },
  { label: '最近90天', value: '90d' }
]

// Methods
const selectTimeRange = (range) => {
  selectedTimeRange.value = range
  // 这里可以添加重新获取数据的逻辑
}

// 动态更新页面标题
watchEffect(() => {
  const siteName = oemSettings.value.siteName || 'Claude Relay Service'
  document.title = `${siteName} - API统计分析`
})

// Lifecycle
onMounted(async () => {
  await settingsStore.loadOemSettings()
  // 初始化 OEM 设置到 apistats store
  await apiStatsStore.loadOemSettings()
})

const servicePlans = ref([
  {
    id: 'claude',
    name: 'ClaudeCode 套餐',
    tag: '推荐',
    tagClass: 'bg-blue-600',
    icon: 'fas fa-code',
    iconBg: 'bg-gradient-to-br from-blue-500 to-purple-600',
    description: '专业级代码理解与重构，最适合 IDE 编程场景',
    features: ['Sonnet 4 级推理与工具调用', '大型代码上下文与文件感知', '代码审查与重构建议'],
    featureIconClass: 'text-blue-600'
  },
  {
    id: 'gpt',
    name: 'GPT‑5 套餐',
    tag: '全能',
    tagClass: 'bg-purple-600',
    icon: 'fas fa-brain',
    iconBg: 'bg-gradient-to-br from-purple-500 to-pink-500',
    description: '通用智能推理与多模态理解，适合 Agent 与产品化',
    features: ['高精准长链路推理', '高质量文本与结构化输出', '多模态理解与工具集成'],
    featureIconClass: 'text-purple-600'
  },
  {
    id: 'gemini',
    name: 'Gemini 套餐',
    tag: '性价比',
    tagClass: 'bg-emerald-600',
    icon: 'fas fa-star',
    iconBg: 'bg-gradient-to-br from-green-500 to-teal-500',
    description: '原生多模态与低延迟响应，适合检索、问答与内容生成',
    features: ['图片/视频/文本多模态', '低延迟、成本友好', '适配检索增强场景'],
    featureIconClass: 'text-emerald-600'
  }
])
</script>

<style scoped>
/* 动画样式 */
@keyframes shake {
  0%,
  100% {
    transform: translateX(0);
  }
  10%,
  30%,
  50%,
  70%,
  90% {
    transform: translateX(-5px);
  }
  20%,
  40%,
  60%,
  80% {
    transform: translateX(5px);
  }
}

.animate-shake {
  animation: shake 0.6s cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn 0.5s ease-out;
}

/* 新增动画 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideInLeft {
  from {
    opacity: 0;
    transform: translateX(-50px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes slideInRight {
  from {
    opacity: 0;
    transform: translateX(50px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes gradientX {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

@keyframes bounceSmooth {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-8px);
  }
}

@keyframes glow {
  0%,
  100% {
    box-shadow: 0 0 5px rgba(34, 197, 94, 0.5);
  }
  50% {
    box-shadow: 0 0 20px rgba(34, 197, 94, 0.8);
  }
}

@keyframes typewriter {
  from {
    width: 0;
  }
  to {
    width: 100%;
  }
}

/* 动画类 - 优化缓动函数 */
.animate-fade-in-up {
  animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.animate-slide-in-left {
  animation: slideInLeft 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.animate-slide-in-right {
  animation: slideInRight 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.animate-gradient-x {
  background-size: 200% 200%;
  animation: gradientX 4s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-bounce-slow {
  animation: bounceSmooth 3s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-float {
  animation: float 4s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-glow {
  animation: glow 3s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-type-writer {
  animation: typewriter 1.5s steps(20, end) both;
  white-space: nowrap;
  overflow: hidden;
}

/* 动画延迟 - 优化为更短延迟 */
.animation-delay-100 {
  animation-delay: 50ms;
}

.animation-delay-200 {
  animation-delay: 100ms;
}

.animation-delay-300 {
  animation-delay: 150ms;
}

.animation-delay-400 {
  animation-delay: 200ms;
}

.animation-delay-500 {
  animation-delay: 250ms;
}

.animation-delay-600 {
  animation-delay: 300ms;
}

.animation-delay-700 {
  animation-delay: 350ms;
}

.animation-delay-800 {
  animation-delay: 400ms;
}

.animation-delay-900 {
  animation-delay: 450ms;
}

.animation-delay-1000 {
  animation-delay: 500ms;
}

/* 特殊效果 */
.text-shimmer {
  background: linear-gradient(
    90deg,
    rgba(255, 255, 255, 0) 0%,
    rgba(255, 255, 255, 0.3) 50%,
    rgba(255, 255, 255, 0) 100%
  );
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
}

@keyframes shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

/* 悬停效果增强 */
.group:hover .animate-pulse {
  animation-duration: 0.5s;
}

.group:hover .animate-bounce {
  animation-duration: 0.8s;
}

/* 响应式动画优化 */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* 性能优化 */
.animate-fade-in-up,
.animate-slide-in-left,
.animate-slide-in-right,
.animate-float,
.animate-bounce-slow,
.animate-glow {
  will-change: transform, opacity;
  backface-visibility: hidden;
  transform: translateZ(0);
}

/* 移动端优化 */
@media (max-width: 640px) {
  .container {
    padding-left: 1rem;
    padding-right: 1rem;
  }

  /* 减少移动端的动画强度 */
  .animate-float {
    animation: float 6s ease-in-out infinite;
  }

  .animate-bounce-slow {
    animation: bounceSmooth 4s ease-in-out infinite;
  }

  .animate-glow {
    animation: glow 4s ease-in-out infinite;
  }

  /* 优化特性卡片在移动端的间距 */
  .group {
    margin-bottom: 0.5rem;
  }

  /* 降低移动端动画复杂度 */
  .animate-gradient-x {
    animation: gradientX 6s ease-in-out infinite;
  }
}

/* 平板端优化 */
@media (min-width: 641px) and (max-width: 1024px) {
  /* 在平板端保持适中的动画效果 */
  .animate-glow {
    animation: glow 2.5s ease-in-out infinite;
  }
}

/* 大屏幕优化 */
@media (min-width: 1440px) {
  .container {
    max-width: 1280px;
  }

  /* 增强大屏幕的动画效果 */
  .animate-float {
    animation: float 2s ease-in-out infinite;
  }

  .animate-bounce-slow {
    animation: bounceSmooth 1.5s ease-in-out infinite;
  }
}
</style>
