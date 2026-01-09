FROM python:3.11-slim

# Paquetes básicos
RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1) Clonar ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

WORKDIR /app/ComfyUI

# 2) Instalar dependencias de ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# 3) Instalar el custom node (tu repo)
RUN mkdir -p /app/ComfyUI/custom_nodes \
 && git clone https://github.com/neuronlabpro-coder/ComfyUI_PromptManager /app/ComfyUI/custom_nodes/ComfyUI_PromptManager \
 && pip install --no-cache-dir -r /app/ComfyUI/custom_nodes/ComfyUI_PromptManager/requirements.txt

# Puerto por defecto de ComfyUI
EXPOSE 8188

# Arranque
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
