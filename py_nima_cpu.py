#!/usr/bin/env python3

# Instrucciones:
# 1. Instalar primero las dependencias en Debian/Devuan:
#    sudo apt install python3-venv python3-full git wget -y
#
# 2. Crear y activar un entorno virtual (si no lo tenés):
#    sudo apt install python3-venv python3-full -y
#    python3 -m venv venv
#    source venv/bin/activate
#
# 3. Instalar librerías necesarias (CPU-only):
#    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
#    pip install ftfy regex numpy pillow requests scikit-learn keras tensorflow git+https://github.com/openai/CLIP.git
#
# 4. Descargar el predictor de estética de LAION (si el script no lo hace solo):
#    verificar nombre del archivo en https://github.com/idealo/image-quality-assessment/tree/master/models/MobileNet
#    wget https://raw.githubusercontent.com/idealo/image-quality-assessment/master/models/MobileNet/weights_mobilenet_aesthetic_0.07.hdf5 -O NIMA_model.h5
#    verificar nombre del archivo en https://github.com/LAION-AI/aesthetic-predictor/tree/main
#    wget https://raw.githubusercontent.com/LAION-AI/aesthetic-predictor/main/sa_0_4_vit_b_32_linear.pth -O aesthetic_predictor.pth
#
# 5. Uso del script:
#    python fotos_rank.py --input fotos_sesion --output best_of --top 200 --alpha 0.6
#
#    Donde:
#      --input   = carpeta de entrada con fotos
#      --output  = carpeta de salida con seleccionadas
#      --top     = cantidad de mejores fotos a copiar
#      --alpha   = peso de LAION (por defecto 0.6). El resto va a NIMA.

import os
import argparse
import requests
import shutil
import numpy as np
from PIL import Image
import torch
from torch import nn
from torchvision import transforms
from tensorflow.keras.applications import MobileNet
from tensorflow.keras.layers import Dense
from tensorflow.keras.models import Model
from tensorflow.keras.preprocessing import image

# -------------------
# Rutas de modelos
# -------------------
MODEL_DIR = os.path.expanduser("~/ai_models")
os.makedirs(MODEL_DIR, exist_ok=True)

NIMA_MODEL_PATH = os.path.join(MODEL_DIR, "weights_mobilenet_aesthetic_0.07.hdf5")
LAION_MODEL_PATH = os.path.join(MODEL_DIR, "sa_0_4_vit_b_32_linear.pth")

NIMA_URL = "https://raw.githubusercontent.com/idealo/image-quality-assessment/master/models/MobileNet/weights_mobilenet_aesthetic_0.07.hdf5"
LAION_URL = "https://raw.githubusercontent.com/LAION-AI/aesthetic-predictor/main/sa_0_4_vit_b_32_linear.pth"

def download_if_missing(url, path):
    if not os.path.exists(path):
        print(f"Descargando {os.path.basename(path)}...")
        r = requests.get(url, stream=True)
        r.raise_for_status()
        with open(path, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"{os.path.basename(path)} guardado en {path}")

download_if_missing(NIMA_URL, NIMA_MODEL_PATH)
download_if_missing(LAION_URL, LAION_MODEL_PATH)

# -------------------
# NIMA (Keras/TensorFlow)
# -------------------
def build_nima_model():
    base_model = MobileNet(input_shape=(224,224,3), include_top=False, pooling='avg')
    x = Dense(10, activation='softmax')(base_model.output)
    model = Model(inputs=base_model.input, outputs=x)
    return model

nima_model = build_nima_model()
nima_model.load_weights(NIMA_MODEL_PATH)

def evaluate_nima(model, img_path):
    img = image.load_img(img_path, target_size=(224,224))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0) / 255.0
    preds = model.predict(x, verbose=0)[0]
    score = sum([(i+1)*p for i,p in enumerate(preds)])
    return score

# -------------------
# LAION (PyTorch)
# -------------------
import clip  # del repo OpenAI CLIP

device = "cuda" if torch.cuda.is_available() else "cpu"
clip_model, preprocess = clip.load("ViT-B/32", device=device)

class LAIONWrapper(nn.Module):
    def __init__(self, clip_model):
        super().__init__()
        self.clip_model = clip_model
        self.fc = nn.Linear(512,1)  # adaptar tamaño embedding según ViT-B/32

    def forward(self, img_tensor):
        with torch.no_grad():
            emb = self.clip_model.encode_image(img_tensor)
        return self.fc(emb)

laion_model = LAIONWrapper(clip_model)
state_dict = torch.load(LAION_MODEL_PATH, map_location=device)
laion_model.fc.load_state_dict(state_dict)
laion_model.eval()

transform = preprocess  # usamos el preprocess de CLIP

def evaluate_laion(model, img_path):
    img = Image.open(img_path).convert("RGB")
    x = transform(img).unsqueeze(0).to(device)
    with torch.no_grad():
        score = model(x).item()
    return score

# -------------------
# Main
# -------------------
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, help="Directorio con fotos")
    parser.add_argument("--output", required=True, help="Directorio para copiar las mejores fotos")
    parser.add_argument("--top", type=int, default=100, help="Cantidad de mejores fotos a copiar")
    parser.add_argument("--alpha", type=float, default=0.6, help="Peso de LAION (0-1)")
    args = parser.parse_args()

    input_dir = args.input
    output_dir = args.output
    top_n = args.top
    alpha = args.alpha

    os.makedirs(output_dir, exist_ok=True)

    files = [f for f in os.listdir(input_dir) if f.lower().endswith((".jpg",".jpeg",".png",".arw"))]
    results = []

    total = len(files)
    for idx, file in enumerate(files,1):
        path = os.path.join(input_dir,file)
        try:
            nima_score = evaluate_nima(nima_model,path)
            laion_score = evaluate_laion(laion_model,path)
            combined = alpha*laion_score + (1-alpha)*nima_score
            results.append((path,combined))
            print(f"{idx}/{total} -> {file} | NIMA: {nima_score:.2f}, LAION: {laion_score:.2f}, Combinado: {combined:.2f}")
        except Exception as e:
            print(f"Error con {file}: {e}")

    results.sort(key=lambda x: x[1], reverse=True)
    for i,(path,score) in enumerate(results[:top_n],1):
        filename = os.path.basename(path)
        dest = os.path.join(output_dir, filename)
        shutil.copy(path,dest)  # copia
        print(f"Seleccionada {i}: {filename} con score {score:.2f}")
