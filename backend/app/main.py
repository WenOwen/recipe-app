from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import recipes_router, ai_router
from app.core.config import settings

# 创建 FastAPI 应用
app = FastAPI(
    title="AI 菜谱推荐 API",
    description="使用 LangChain + MiniMax API 的智能菜谱推荐后端服务",
    version="1.0.0",
)

# CORS 配置，允许 Flutter 应用访问
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境应该限制具体域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 注册路由
app.include_router(recipes_router)
app.include_router(ai_router)


@app.get("/")
async def root():
    """根路径 - API 信息"""
    return {
        "name": "AI 菜谱推荐 API",
        "version": "1.0.0",
        "docs": "/docs",
    }


@app.get("/health")
async def health_check():
    """健康检查"""
    return {"status": "ok"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=settings.API_HOST,
        port=settings.API_PORT,
        reload=True,
    )
