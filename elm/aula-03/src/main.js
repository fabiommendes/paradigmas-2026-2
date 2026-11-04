import "./styles/main.css";
import { Elm } from "./Main.elm";

// Semente aleatória para o embaralhamento. O Elm recebe um Int pelas flags,
// sem precisar de decoders JSON.
const seed = crypto.getRandomValues(new Uint32Array(1))[0];

Elm.Main.init({
  node: document.getElementById("memoria"),
  flags: seed,
});
