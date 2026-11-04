# Memória dos Casais

Jogo da memória educacional em Elm para ensinar programação funcional. O par
é formado por similaridade (no tema pronto, macho e fêmea da mesma espécie), não por cartas
iguais. Visão geral e arquitetura no `README.md`.

## Idioma

Nível 1 do ADR 0002 do tooling-root:

- A conversa com o humano é sempre em português.
- Português em documentos, comentários, docstrings e mensagens de commit.
- Identificadores em inglês. Textos mostrados ao jogador ficam em português.

## Comandos

O gerenciador de pacotes é o pnpm.

- `pnpm api`: API REST em http://localhost:8000.
- `pnpm dev`: servidor com hot reload (repassa `/api` e `/cards` à API).
- `pnpm test`: testes com elm-test.
- `pnpm check`: formatação, testes e build. Define "pronto".

## Regras do projeto

- `src/Game.elm` e `src/Main.elm` são o código que os
  alunos leem e escrevem. Mantenha-os curtos e sem truques: `elm/core`,
  `elm/html`, `elm/browser`, `elm/http`, `elm/json` e `elm/url`, sem portas.
- `server/` é a API REST (FastAPI, rodada com uv) que serve temas,
  cartas e imagens. Dados em `server/data/themes.json`. Roteiro do
  laboratório em `notas.md`.
- `src/Rng.elm`, `src/styles/` e `server/cards/` são infraestrutura
  fornecida e podem ter mais complexidade.
- Efeitos visuais ficam no CSS. O Elm só escolhe classes.
- O layout assume o tabuleiro 4 × 4 com 16 cartas. Cada tema é descrito
  em `server/data/themes.json`; imagens locais ficam em `server/cards/<tema>/`
  com um `CREDITS.md`. Imagens do Pokémon
  não são copiadas: o tema aponta para URLs externas. Ver `server/CREDITS.md`.
- Estética de mesa de jogo: feltro verde, cartas de papel-cartão, tons de
  vinho e creme, fontes Alegreya e Alegreya Sans. Sem neon, brilho ou
  degradês chamativos.
