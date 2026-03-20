"""模拟菜谱数据（实际项目中会从数据库获取）"""

from __future__ import annotations

from app.models.recipe import Recipe

RECIPES = [
    Recipe(
        id="1",
        title="红烧肉",
        description="家常经典菜，肥而不腻，入口即化",
        image_url="https://images.unsplash.com/photo-1544025162-d76694265947?w=400",
        ingredients=["五花肉", "冰糖", "生抽", "老抽", "八角", "桂皮", "葱姜"],
        steps=[
            "五花肉切块，冷水下锅焯水去血沫",
            "锅中放少量油，加入冰糖小火炒至焦糖色",
            "下入五花肉翻炒上色",
            "加入葱姜、八角、桂皮炒香",
            "加生抽、老抽、清水没过肉块",
            "大火烧开后转小火炖1小时",
            "大火收汁即可",
        ],
        cooking_time=60,
        difficulty="中等",
        servings=4,
        category="中餐",
        tags=["下饭", "硬菜", "肉食"],
    ),
    Recipe(
        id="2",
        title="番茄炒蛋",
        description="简单快手，酸甜可口，是家的味道",
        image_url="https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400",
        ingredients=["番茄", "鸡蛋", "葱", "盐", "糖", "食用油"],
        steps=[
            "鸡蛋打散加少许盐搅匀",
            "番茄切块备用",
            "热锅凉油，倒入蛋液炒熟盛出",
            "锅中放油，下番茄块翻炒出汁",
            "加入适量盐和糖调味",
            "倒入炒好的鸡蛋翻炒均匀",
            "撒葱花出锅",
        ],
        cooking_time=10,
        difficulty="简单",
        servings=2,
        category="中餐",
        tags=["快手", "下饭", "家常"],
    ),
    Recipe(
        id="3",
        title="意式披萨",
        description="经典意大利风味，芝士拉丝，香脆可口",
        image_url="https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400",
        ingredients=[
            "高筋面粉",
            "酵母",
            "温水",
            "番茄酱",
            "马苏里拉芝士",
            "香肠",
            "青椒",
            "洋葱",
        ],
        steps=[
            "面粉加酵母、温水揉成面团，发酵1小时",
            "面团擀成圆饼，戳一些小孔",
            "刷上番茄酱，铺上芝士",
            "放上香肠、青椒、洋葱等配料",
            "烤箱预热200度，烤15分钟",
            "取出再撒一层芝士，烤5分钟",
        ],
        cooking_time=45,
        difficulty="中等",
        servings=4,
        category="西餐",
        tags=["聚会", "芝士", "意式"],
    ),
    Recipe(
        id="4",
        title="三文鱼刺身",
        description="新鲜美味，入口即化，保留鱼肉的原汁原味",
        image_url="https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400",
        ingredients=["新鲜三文鱼", "酱油", "芥末", "姜丝", "紫苏叶"],
        steps=[
            "三文鱼用纸巾吸干表面水分",
            "切成厚薄均匀的片状",
            "摆盘时鱼片呈扇形排列",
            "配以酱油、芥末蘸料",
            "可用姜丝和紫苏叶点缀",
        ],
        cooking_time=5,
        difficulty="简单",
        servings=2,
        category="日料",
        tags=["刺身", "健康", "海鲜"],
    ),
    Recipe(
        id="5",
        title="韩式拌饭",
        description="色彩缤纷，营养丰富，一碗满足所有",
        image_url="https://images.unsplash.com/photo-1553163147-622ab57be1c7?w=400",
        ingredients=[
            "米饭",
            "韩式辣酱",
            "菠菜",
            "豆芽",
            "胡萝卜",
            "西葫芦",
            "鸡蛋",
            "芝麻",
        ],
        steps=[
            "菠菜、豆芽分别焯水沥干",
            "胡萝卜、西葫芦切丝炒熟",
            "煎一个荷包蛋",
            "米饭盛入碗中，铺上各色蔬菜",
            "放上荷包蛋，撒芝麻",
            "吃时加入韩式辣酱拌匀",
        ],
        cooking_time=30,
        difficulty="简单",
        servings=1,
        category="韩餐",
        tags=["一人食", "健康", "拌饭"],
    ),
    Recipe(
        id="6",
        title="提拉米苏",
        description="意式经典甜点，咖啡香与芝士的完美融合",
        image_url="https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400",
        ingredients=[
            "马斯卡彭奶酪",
            "手指饼干",
            "浓缩咖啡",
            "蛋黄",
            "细砂糖",
            "可可粉",
        ],
        steps=[
            "蛋黄加糖打发至颜色发白",
            "加入马斯卡彭奶酪搅拌均匀",
            "手指饼干快速蘸咖啡铺底",
            "铺一层奶酪糊，重复两层",
            "冷藏4小时以上",
            "食用前撒可可粉",
        ],
        cooking_time=30,
        difficulty="困难",
        servings=6,
        category="甜点",
        tags=["甜品", "下午茶", "意式"],
    ),
    Recipe(
        id="7",
        title="麻婆豆腐",
        description="川菜经典，麻辣鲜香，下饭神器",
        image_url="https://images.unsplash.com/photo-1582452932280-991140ae96f1?w=400",
        ingredients=[
            "嫩豆腐",
            "牛肉末",
            "郫县豆瓣酱",
            "花椒",
            "蒜苗",
            "姜蒜",
            "生抽",
            "淀粉",
        ],
        steps=[
            "豆腐切块焯水去豆腥",
            "牛肉末炒至变色盛出",
            "锅中放油，下花椒、豆瓣酱炒出红油",
            "加入姜蒜末炒香",
            "加水烧开，放入豆腐",
            "加生抽调味，中火煮5分钟",
            "下水淀粉勾芡，撒蒜苗出锅",
        ],
        cooking_time=20,
        difficulty="中等",
        servings=3,
        category="中餐",
        tags=["川菜", "麻辣", "下饭"],
    ),
    Recipe(
        id="8",
        title="蒜蓉西兰花",
        description="清爽健康，简单易做的家常素菜",
        image_url="https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=400",
        ingredients=["西兰花", "大蒜", "盐", "蚝油", "食用油"],
        steps=[
            "西兰花掰成小朵，浸泡洗净",
            "烧水加盐，西兰花焯水1分钟捞出",
            "大蒜切末",
            "锅中放油，下蒜末爆香",
            "倒入西兰花翻炒",
            "加蚝油、盐调味即可",
        ],
        cooking_time=10,
        difficulty="简单",
        servings=2,
        category="中餐",
        tags=["素菜", "健康", "快手"],
    ),
    Recipe(
        id="9",
        title="日式味噌汤",
        description="日料必备，汤鲜味美，暖胃暖心",
        image_url="https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400",
        ingredients=["味噌酱", "嫩豆腐", "海带", "小葱", "木鱼花"],
        steps=[
            "海带提前泡发，切小块",
            "锅中加水，放入海带煮开",
            "豆腐切小块放入",
            "小火煮2分钟",
            "关火后加入味噌酱搅匀",
            "盛出撒葱花和木鱼花",
        ],
        cooking_time=15,
        difficulty="简单",
        servings=3,
        category="日料",
        tags=["汤", "健康", "日式"],
    ),
    Recipe(
        id="10",
        title="可乐鸡翅",
        description="甜香可口，色泽红亮，小朋友的最爱",
        image_url="https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=400",
        ingredients=["鸡翅中", "可乐", "生抽", "姜", "料酒"],
        steps=[
            "鸡翅洗净，两面划几刀",
            "冷水下锅焯水，加料酒去腥",
            "锅中放油，下姜片爆香",
            "放入鸡翅煎至两面金黄",
            "加生抽和可乐，没过鸡翅",
            "大火烧开转小火炖20分钟",
            "大火收汁即可",
        ],
        cooking_time=30,
        difficulty="简单",
        servings=3,
        category="中餐",
        tags=["鸡翅", "甜口", "家常"],
    ),
]


def get_recipe_by_id(recipe_id: str) -> Recipe | None:
    """根据 ID 获取菜谱"""
    for recipe in RECIPES:
        if recipe.id == recipe_id:
            return recipe
    return None


def search_recipes(keyword: str) -> list[Recipe]:
    """搜索菜谱"""
    keyword = keyword.lower()
    return [
        r
        for r in RECIPES
        if keyword in r.title.lower()
        or keyword in r.description.lower()
        or any(keyword in tag.lower() for tag in r.tags)
    ]


def filter_by_category(category: str) -> list[Recipe]:
    """按分类筛选"""
    if category == "全部":
        return RECIPES
    return [r for r in RECIPES if r.category == category]


def filter_by_difficulty(difficulty: str) -> list[Recipe]:
    """按难度筛选"""
    if difficulty == "全部":
        return RECIPES
    return [r for r in RECIPES if r.difficulty == difficulty]
