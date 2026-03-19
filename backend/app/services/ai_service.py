import json
from typing import Optional
from app.core.config import settings
from app.models import Recipe
from app.data import RECIPES


class AIService:
    """AI 服务 - 使用 Anthropic API 兼容接口调用 MiniMax M2.7"""

    def __init__(self):
        self.api_key = settings.MINIMAX_API_KEY
        self.base_url = getattr(
            settings, "ANTHROPIC_BASE_URL", "https://api.minimaxi.com/anthropic"
        )
        self.model = settings.MINIMAX_MODEL

    async def recommend(
        self,
        ingredients: list[str],
        taste: Optional[str] = None,
        diet: Optional[str] = None,
    ) -> list[Recipe]:
        """
        根据食材推荐菜谱

        使用 MiniMax M2.7 模型进行分析
        """
        if not self.api_key or self.api_key == "你的API密钥填在这里":
            # 没有 API Key 时，使用简单匹配逻辑
            return self._simple_recommend(ingredients, taste, diet)

        # 调用 AI
        prompt = self._build_prompt(ingredients, taste, diet)

        try:
            response = await self._call_ai(prompt)
            return self._parse_response(response)
        except Exception as e:
            print(f"AI 调用失败: {e}")
            return self._simple_recommend(ingredients, taste, diet)

    def _simple_recommend(
        self,
        ingredients: list[str],
        taste: Optional[str] = None,
        diet: Optional[str] = None,
    ) -> list[Recipe]:
        """简单的推荐逻辑：根据食材关键词匹配"""
        ingredients_lower = [i.lower() for i in ingredients]
        matched_recipes = []

        for recipe in RECIPES:
            score = 0
            recipe_ingredients_lower = [i.lower() for i in recipe.ingredients]

            # 计算食材匹配分数
            for user_ing in ingredients_lower:
                for recipe_ing in recipe_ingredients_lower:
                    if user_ing in recipe_ing or recipe_ing in user_ing:
                        score += 1

            # 口味偏好过滤
            if taste:
                if (
                    taste == "辣"
                    and "辣" not in recipe.tags
                    and "麻辣" not in recipe.tags
                ):
                    score = score // 2
                elif taste == "清淡" and recipe.difficulty == "困难":
                    score = score // 2

            if score > 0:
                matched_recipes.append((recipe, score))

        # 按分数排序
        matched_recipes.sort(key=lambda x: x[1], reverse=True)

        # 返回前 5 个
        return [r[0] for r in matched_recipes[:5]]

    def _build_prompt(
        self,
        ingredients: list[str],
        taste: Optional[str] = None,
        diet: Optional[str] = None,
    ) -> str:
        """构建 AI prompt"""
        ingredient_str = "、".join(ingredients)

        prompt = f"""你是一个专业厨师。用户冰箱里有以下食材：{ingredient_str}
"""

        if taste:
            prompt += f"用户口味偏好：{taste}\n"
        if diet:
            prompt += f"饮食限制：{diet}\n"

        prompt += """
请根据这些食材推荐一道最合适的菜谱。
推荐要求：
1. 优先使用用户已有的食材
2. 考虑食材之间的搭配
3. 做法简单家常

请以 JSON 格式返回推荐结果：
{
    "title": "菜谱名称",
    "description": "简要描述（10字以内）",
    "ingredients": ["食材1", "食材2", ...],
    "steps": ["步骤1", "步骤2", ...],
    "cooking_time": 30,
    "difficulty": "简单/中等/困难",
    "servings": 2,
    "category": "中餐/西餐/日料等"
}

请只返回 JSON，不要有其他内容。"""

        return prompt

    async def _call_ai(self, prompt: str) -> str:
        """调用 MiniMax M2.7 API (Anthropic 兼容)"""
        import httpx

        headers = {
            "x-api-key": self.api_key,
            "anthropic-version": "2023-06-01",
            "content-type": "application/json",
        }

        data = {
            "model": self.model,
            "max_tokens": 2000,
            "messages": [
                {"role": "user", "content": [{"type": "text", "text": prompt}]}
            ],
        }

        # 注意：Coding Plan 可能需要 /v1 前缀
        url = f"{self.base_url}/v1/messages"

        async with httpx.AsyncClient(timeout=httpx.Timeout(120.0)) as client:
            response = await client.post(
                url,
                headers=headers,
                json=data,
            )
            response.raise_for_status()
            result = response.json()

            # Anthropic 格式的响应
            if "content" in result:
                for block in result["content"]:
                    if block.get("type") == "text":
                        return block["text"]

            return result.get("content", [{}])[0].get("text", "")

    def _parse_response(self, response: str) -> list[Recipe]:
        """解析 AI 返回的 JSON 响应"""
        try:
            # 尝试提取 JSON
            json_str = response.strip()

            # 去掉可能的 markdown 代码块
            if "```json" in json_str:
                json_str = json_str.split("```json")[1].split("```")[0]
            elif "```" in json_str:
                json_str = json_str.split("```")[1].split("```")[0]

            json_str = json_str.strip()

            # 如果开头有 "json" 字样，去掉
            if json_str.startswith("json"):
                json_str = json_str[4:].strip()

            data = json.loads(json_str)

            # 构建 Recipe 对象
            recipe = Recipe(
                id=f"ai_{hash(response) % 100000}",
                title=data.get("title", ""),
                description=data.get("description", ""),
                image_url="",
                ingredients=data.get("ingredients", []),
                steps=data.get("steps", []),
                cooking_time=data.get("cooking_time", 30),
                difficulty=data.get("difficulty", "中等"),
                servings=data.get("servings", 2),
                category=data.get("category", "中餐"),
                tags=["AI推荐"],
            )
            return [recipe]
        except Exception as e:
            print(
                f"解析 AI 响应失败: {e}, 原始响应: {response[:200] if len(response) > 200 else response}"
            )
            return []

    async def chat(self, message: str) -> str:
        """聊天功能"""
        if not self.api_key or self.api_key == "你的API密钥填在这里":
            return "AI 服务未配置 API Key，请联系管理员配置 MiniMax API"

        prompt = f"""你是一个美食助手，请回答用户关于烹饪、菜谱、食材等方面的问题。

用户问题：{message}

请用友好、专业的语气回答。"""

        try:
            return await self._call_ai(prompt)
        except Exception as e:
            return f"抱歉，AI 服务暂时不可用: {str(e)}"


# 全局单例
ai_service = AIService()
