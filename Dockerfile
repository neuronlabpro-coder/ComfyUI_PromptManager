FROM python:3.11-slim

# Paquetes mínimos para poder clonar repos y construir wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 0) Instalar ComfyUI (base)
RUN git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git

# 1) Entrar al repo como indica el flujo de instalación
WORKDIR /app/ComfyUI

# 2) Instalar dependencias de ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# 3) (Manual) Clonar el repositorio en ComfyUI/custom_nodes/
RUN mkdir -p custom_nodes \
 && git clone --depth=1 https://github.com/ComfyAssets/ComfyUI_PromptManager custom_nodes/ComfyUI_PromptManager

# 4) (Manual) Instalar dependencias del plugin
RUN pip install --no-cache-dir -r custom_nodes/ComfyUI_PromptManager/requirements.txt

# Puerto ComfyUI
EXPOSE 8188

# 5) Arranque (CPU para evitar error CUDA si no hay GPU)
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--cpu"]

