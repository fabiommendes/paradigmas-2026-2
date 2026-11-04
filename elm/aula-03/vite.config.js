import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";

// Endereço da API (veja server/main.py).
const api = "http://localhost:8000";

export default defineConfig({
  // Caminhos relativos: o build funciona em qualquer subpasta do servidor.
  base: "./",
  plugins: [elmPlugin()],
  // Em desenvolvimento, o Vite repassa /api e /cards para o servidor Python.
  // Assim o Elm usa caminhos relativos e não há problema de CORS.
  server: {
    proxy: {
      "/api": api,
      "/cards": api,
    },
  },
});
