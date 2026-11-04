"""API REST do jogo da memória.

Rode com `pnpm api` (ou `uv run fastapi dev main.py` nesta pasta).
Documentação interativa em http://localhost:8000/docs

Rotas (todas aceitam `delay=<ms>` para simular uma rede lenta):

    GET /api/themes                                  lista de temas
    GET /api/cards?theme=animals&equalPairs=false    as 16 cartas de um tema
    GET /cards/<tema>/<arquivo>                      imagens locais
"""

import asyncio
import json
import random
from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

ROOT = Path(__file__).parent
THEMES = json.loads((ROOT / "data" / "themes.json").read_text(encoding="utf-8"))

# O tabuleiro tem 4 × 4 cartas, ou seja, 8 grupos.
GROUPS_PER_GAME = 8


class Theme(BaseModel):
    id: str
    name: str
    description: str
    cover: str


class Card(BaseModel):
    group: str
    description: str
    url: str


app = FastAPI(title="Jogo da memória")

# Libera o acesso de outras origens (ex.: elm reactor em outra porta).
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"])

app.mount("/cards", StaticFiles(directory=ROOT / "cards"), name="cards")


async def wait(delay: int):
    """Espera `delay` milissegundos (no máximo 10 s) antes de responder."""
    await asyncio.sleep(min(max(delay, 0), 10_000) / 1000)


@app.get("/api/themes")
async def list_themes(delay: int = 0) -> list[Theme]:
    await wait(delay)
    return [Theme(**t) for t in THEMES]


@app.get("/api/cards")
async def list_cards(theme: str, equalPairs: bool = False, delay: int = 0) -> list[Card]:
    """Devolve 16 cartas, 2 por grupo, na ordem dos grupos (sem embaralhar).

    - `equalPairs=false`: as duas cartas do grupo formam uma associação
      (macho e fêmea, Pokémon e evolução...).
    - `equalPairs=true`: sorteia uma das duas cartas e manda ela duas vezes,
      como no jogo da memória tradicional.

    Temas com mais de 8 grupos têm 8 deles sorteados.
    """
    await wait(delay)
    found = next((t for t in THEMES if t["id"] == theme), None)
    if found is None:
        raise HTTPException(status_code=404, detail=f"tema desconhecido: {theme}")

    groups: dict[str, list[dict]] = {}
    for card in found["cards"]:
        groups.setdefault(card["group"], []).append(card)

    chosen = sorted(random.sample(sorted(groups), min(GROUPS_PER_GAME, len(groups))))

    cards = []
    for group in chosen:
        pair = groups[group]
        if equalPairs:
            pair = [random.choice(pair)] * 2
        cards += [Card(group=c["group"], description=c["description"], url=c["url"]) for c in pair]
    return cards
