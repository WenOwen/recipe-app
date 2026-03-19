# AI 菜谱推荐后端

基于 FastAPI + LangChain + MiniMax API 的智能菜谱推荐后端服务。

## 技术栈

- **Web 框架**: FastAPI
- **AI 引擎**: LangChain + MiniMax API
- **Python 版本**: 3.10+

## 项目结构

```
backend/
├── app/
│   ├── api/           # API 路由
│   │   ├── recipes.py   # 菜谱相关接口
│   │   └── ai.py        # AI 推荐接口
│   ├── core/          # 核心配置
│   │   └── config.py
│   ├── data/          # 模拟数据
│   │   └── recipes_data.py
│   ├── models/        # 数据模型
│   │   └── recipe.py
│   ├── services/      # 业务服务
│   │   └── ai_service.py
│   └── main.py        # 应用入口
├── requirements.txt   # 依赖
├── .env.example       # 环境变量示例
└── run.bat           # Windows 启动脚本
```

## 快速开始

### 1. 安装依赖

```bash
cd backend
pip install -r requirements.txt
```

### 2. 配置环境变量

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入你的 MiniMax API Key：

```
MINIMAX_API_KEY=your_api_key_here
```

### 3. 启动服务

```bash
# Windows
run.bat

# 或手动启动
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 4. 访问 API

- API 文档: http://localhost:8000/docs
- 健康检查: http://localhost:8000/health

## API 接口

### 菜谱接口

| 方法 | 路径 | 描述 |
|------|------|------|
| GET | `/api/recipes` | 获取菜谱列表（支持分页、筛选） |
| GET | `/api/recipes/{id}` | 获取菜谱详情 |
| GET | `/api/recipes/search?q=关键词` | 搜索菜谱 |
| GET | `/api/categories` | 获取分类列表 |

### AI 接口

| 方法 | 路径 | 描述 |
|------|------|------|
| POST | `/api/ai/recommend` | AI 推荐菜谱 |
| GET | `/api/ai/chat?message=问题` | AI 聊天 |

## 示例请求

### 获取菜谱列表

```bash
curl http://localhost:8000/api/recipes?page=1&page_size=10
```

### AI 推荐

```bash
curl -X POST http://localhost:8000/api/ai/recommend \
  -H "Content-Type: application/json" \
  -d '{"ingredients": ["鸡蛋", "番茄"], "taste": "清淡"}'
```

## MiniMax API 申请

1. 访问 https://platform.minimax.chat/
2. 注册账号并登录
3. 在控制台创建 API Key
4. 将 API Key 填入 `.env` 文件
