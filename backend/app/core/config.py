import os
from dotenv import load_dotenv

load_dotenv()


class Settings:
    """应用配置"""

    # API 配置
    API_HOST = os.getenv("API_HOST", "0.0.0.0")
    API_PORT = int(os.getenv("API_PORT", "8000"))

    # MiniMax API 配置
    MINIMAX_API_KEY = os.getenv("MINIMAX_API_KEY", "")

    # Anthropic 兼容接口配置 (Coding Plan)
    ANTHROPIC_BASE_URL = os.getenv(
        "ANTHROPIC_BASE_URL", "https://api.minimaxi.com/anthropic"
    )
    MINIMAX_MODEL = os.getenv("MINIMAX_MODEL", "MiniMax-M2.7")

    # LangChain 配置（可选，用于追踪）
    LANGCHAIN_TRACING = os.getenv("LANGCHAIN_TRACING", "false")
    LANGCHAIN_API_KEY = os.getenv("LANGCHAIN_API_KEY", "")


settings = Settings()
