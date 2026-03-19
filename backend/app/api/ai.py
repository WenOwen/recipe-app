from fastapi import APIRouter
from app.models import RecommendRequest, Recipe
from app.services.ai_service import ai_service

router = APIRouter(prefix="/api/ai", tags=["AI 推荐"])


@router.post("/recommend", response_model=list[Recipe])
async def recommend_recipes(request: RecommendRequest):
    """根据食材智能私厨推荐菜谱"""
    try:
        recommendations = await ai_service.recommend(
            ingredients=request.ingredients,
            taste=request.taste,
            diet=request.diet,
            count=request.count,
        )
        return recommendations
    except Exception as e:
        # 如果 AI 服务出错，返回空列表或模拟数据
        print(f"智能私厨推荐出错: {e}")
        return []


@router.get("/chat")
async def chat(message: str):
    """AI 聊天（测试用）"""
    try:
        response = await ai_service.chat(message)
        return {"data": response}
    except Exception as e:
        return {"data": f"AI 服务暂时不可用: {str(e)}"}
