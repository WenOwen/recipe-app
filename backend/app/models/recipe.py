from pydantic import BaseModel
from typing import List, Optional


class Recipe(BaseModel):
    """菜谱数据模型"""

    id: str
    title: str
    description: str
    image_url: str
    ingredients: List[str]
    steps: List[str]
    cooking_time: int  # 分钟
    difficulty: str  # 简单/中等/困难
    servings: int  # 几人份
    category: str  # 分类：中餐/西餐/日料等
    tags: List[str] = []  # 标签：下饭、快手、减脂等
    is_favorite: bool = False
    missing_ingredients: List[str] = []  # 缺失食材，做这道菜还需要什么
    reason: str = ""  # 推荐理由


class RecipeListResponse(BaseModel):
    """菜谱列表响应"""

    data: List[Recipe]
    total: int
    page: int
    page_size: int


class RecommendRequest(BaseModel):
    """AI 推荐请求"""

    ingredients: List[str]  # 已有食材
    taste: Optional[str] = None  # 口味偏好：辣、清淡、甜等
    diet: Optional[str] = None  # 饮食限制：素食、低糖等
