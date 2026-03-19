@echo off
echo ========================================
echo AI 菜谱推荐后端服务启动中...
echo ========================================

cd /d "%~dp0"

echo.
echo 正在安装依赖...
pip install -r requirements.txt

echo.
echo 正在启动服务...
echo 访问地址: http://localhost:8000
echo API 文档: http://localhost:8000/docs
echo.

python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

pause
