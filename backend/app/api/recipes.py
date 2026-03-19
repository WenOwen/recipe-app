from fastapi import APIRouter, HTTPException, Query
from typing import Optional
from app.models import Recipe, RecipeListResponse
from app.data import (
    RECIPES,
    get_recipe_by_id,
    search_recipes,
    filter_by_category,
    filter_by_difficulty,
)

router = APIRouter(prefix="/api", tags=["菜谱"])


@router.get("/recipes", response_model=RecipeListResponse)
async def get_recipes(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    category: Optional[str] = Query(None, description="分类筛选"),
    keyword: Optional[str] = Query(None, description="关键词搜索"),
    difficulty: Optional[str] = Query(None, description="难度筛选"),
):
    """获取菜谱列表"""
    recipes = RECIPES

    # 分类筛选
    if category and category != "全部":
        recipes = [r for r in recipes if r.category == category]

    # 难度筛选
    if difficulty and difficulty != "全部":
        recipes = [r for r in recipes if r.difficulty == difficulty]

    # 关键词搜索
    if keyword:
        keyword = keyword.lower()
        recipes = [
            r
            for r in recipes
            if keyword in r.title.lower()
            or keyword in r.description.lower()
            or any(keyword in tag.lower() for tag in r.tags)
        ]

    total = len(recipes)

    # 分页
    start = (page - 1) * page_size
    end = start + page_size
    paginated_recipes = recipes[start:end]

    return RecipeListResponse(
        data=paginated_recipes,
        total=total,
        page=page,
        page_size=page_size,
    )


@router.get("/recipes/{recipe_id}", response_model=Recipe)
async def get_recipe_detail(recipe_id: str):
    """获取菜谱详情"""
    recipe = get_recipe_by_id(recipe_id)
    if not recipe:
        raise HTTPException(status_code=404, detail="菜谱不存在")
    return recipe


@router.get("/recipes/search", response_model=list[Recipe])
async def search_recipe(q: str = Query(..., min_length=1, description="搜索关键词")):
    """搜索菜谱"""
    return search_recipes(q)


@router.get("/categories")
async def get_categories():
    """获取所有分类"""
    return {
        "data": [
            "全部",
            "中餐",
            "西餐",
            "日料",
            "韩餐",
            "东南亚",
            "早餐",
            "快手菜",
            "甜点",
            "饮品",
        ]
    }


@router.post("/recipes", response_model=Recipe)
async def create_recipe(recipe: Recipe):
    """创建新菜谱"""
    # 生成新 ID
    import uuid

    new_recipe = Recipe(
        id=str(uuid.uuid4())[:8],
        title=recipe.title,
        description=recipe.description,
        image_url=recipe.image_url,
        ingredients=recipe.ingredients,
        steps=recipe.steps,
        cooking_time=recipe.cooking_time,
        difficulty=recipe.difficulty,
        servings=recipe.servings,
        category=recipe.category,
        tags=recipe.tags,
        is_favorite=False,
    )

    # 添加到列表（实际应存数据库）
    RECIPES.append(new_recipe)

    return new_recipe
