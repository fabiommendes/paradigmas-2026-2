import "./styles/main.css";
import { Elm } from "./Main.elm";
import { comemorar } from "./comemoracao.js";
import { playCardFlipSound } from "./sons.js";

// Semente aleatória para o embaralhamento. O Elm recebe um Int pelas flags,
// sem precisar de decoders JSON.
const seed = crypto.getRandomValues(new Uint32Array(1))[0];

const app = Elm.Main.init({
  node: document.getElementById("memoria"),
  flags: seed,
});

// Funções disponíveis no console do navegador, para testar à mão.
// Na aula, ligamos cada uma delas a uma porta do Elm.
window.comemorar = comemorar;
window.playCardFlipSound = playCardFlipSound;

// Trapaça: o JavaScript não alcança o modelo do Elm, mas mexe no DOM. Basta
// dar a todas as cartas as classes de "par encontrado" para o CSS mostrá-las
// resolvidas. O Elm não fica sabendo: para ele o jogo continua igual.
window.trapacear = () => {
  document.querySelectorAll(".board .card").forEach((card) => {
    card.classList.add("card--up", "card--matched");
  });
};
