// Comemoração de fim de jogo: exagerada de propósito.
//
// Este é o lado JavaScript do nosso primeiro exemplo de portas: o Elm não
// sabe animar canvas nem chamar bibliotecas JS, então ele só avisa "o jogo
// acabou" e o JavaScript faz o espetáculo.
//
// Bibliotecas:
//   - canvas-confetti: confete, fogos de artifício e emojis voando.
//   - anime.js: as cartas pulam, giram e fazem a ola.

import confetti from "canvas-confetti";
import { animate, createTimeline, stagger, utils } from "animejs";

const COLORS = ["#7a1f2b", "#f6efdf", "#d4a017", "#2f6b3a", "#e85d75", "#4ea1d3"];

const random = (min, max) => Math.random() * (max - min) + min;

// Executa `fn` a cada `interval` ms até passar `duration` ms.
function repeat(fn, interval, duration) {
  const end = Date.now() + duration;
  const id = setInterval(() => {
    if (Date.now() > end) clearInterval(id);
    else fn();
  }, interval);
}

// ---------- Confete e fogos ----------

// Dois canhões nos cantos de baixo, atirando sem parar.
function cannons(duration) {
  repeat(
    () => {
      confetti({ particleCount: 12, angle: 60, spread: 70, origin: { x: 0, y: 1 }, colors: COLORS, startVelocity: 70 });
      confetti({ particleCount: 12, angle: 120, spread: 70, origin: { x: 1, y: 1 }, colors: COLORS, startVelocity: 70 });
    },
    60,
    duration,
  );
}

// Fogos: explosões redondas em pontos aleatórios do céu.
function fireworks(duration) {
  repeat(
    () => {
      const origin = { x: random(0.1, 0.9), y: random(0.05, 0.45) };
      confetti({
        particleCount: 120,
        spread: 360,
        startVelocity: 35,
        ticks: 90,
        gravity: 0.7,
        scalar: 0.9,
        origin,
        colors: [COLORS[Math.floor(random(0, COLORS.length))], "#ffffff"],
      });
    },
    350,
    duration,
  );
}

// Chuva de emojis caindo do alto da tela.
function emojiRain(duration) {
  const shapes = ["🎉", "⭐", "🃏", "λ", "🏆", "✨"].map((text) =>
    confetti.shapeFromText({ text, scalar: 3 }),
  );
  repeat(
    () => {
      confetti({
        particleCount: 3,
        shapes,
        scalar: 3,
        spread: 180,
        startVelocity: 10,
        gravity: 0.6,
        ticks: 300,
        flat: true,
        origin: { x: random(0, 1), y: -0.1 },
      });
    },
    120,
    duration,
  );
}

// Uma explosão enorme no centro, para fechar.
function grandFinale() {
  const burst = (ratio, opts) =>
    confetti({ origin: { y: 0.6 }, colors: COLORS, particleCount: Math.floor(600 * ratio), ...opts });
  burst(0.25, { spread: 26, startVelocity: 55 });
  burst(0.2, { spread: 60 });
  burst(0.35, { spread: 100, decay: 0.91, scalar: 0.8 });
  burst(0.1, { spread: 120, startVelocity: 25, decay: 0.92, scalar: 1.2 });
  burst(0.1, { spread: 120, startVelocity: 45 });
}

// ---------- Cartas ----------

// As cartas pulam, giram e fazem uma ola a partir do centro do tabuleiro.
// Animamos o `.card` (não o `.board__slot`, que já tem animação de CSS, nem
// o `.card__inner`, que guarda a rotação da virada).
function danceCards() {
  const cards = document.querySelectorAll(".board .card");
  if (cards.length === 0) return;

  // A transição de CSS da carta brigaria com o anime.js a cada quadro.
  cards.forEach((card) => (card.style.transition = "none"));

  const fromCenter = { grid: [4, 4], from: "center" };

  const timeline = createTimeline({
    // No fim, devolve as cartas ao controle do CSS.
    onComplete: () => {
      utils.cleanInlineStyles(timeline);
      cards.forEach((card) => card.style.removeProperty("transition"));
    },
  });

  timeline
    // Pulo com giro completo.
    .add(cards, {
      translateY: [0, -80, 0],
      rotate: [0, 360],
      scale: [1, 1.3, 1],
      duration: 900,
      delay: stagger(60, fromCenter),
      ease: "outBack",
    })
    // Tremedeira.
    .add(cards, {
      translateX: [0, -12, 12, -12, 12, 0],
      duration: 500,
      delay: stagger(20),
      ease: "linear",
    })
    // Ola: uma onda que atravessa o tabuleiro duas vezes.
    .add(cards, {
      translateY: [0, -40, 0],
      rotate: [0, -15, 15, 0],
      duration: 600,
      delay: stagger(80, { grid: [4, 4], from: "first", axis: "x" }),
      ease: "inOutSine",
      loop: 2,
    })
    // Explodem para fora e voltam com elástico.
    .add(cards, {
      translateX: stagger([-300, 300], fromCenter),
      translateY: stagger([-300, 300], { ...fromCenter, axis: "y" }),
      rotate: () => random(-720, 720),
      scale: 0.4,
      duration: 700,
      ease: "outQuad",
    })
    .add(cards, {
      translateX: 0,
      translateY: 0,
      rotate: 0,
      scale: 1,
      duration: 1400,
      delay: stagger(40, { from: "random" }),
      ease: "outElastic(1, .4)",
    });
}

// ---------- Letreiro ----------

// "PARABÉNS!" gigante, letra por letra, no meio da tela.
function banner() {
  const el = document.createElement("div");
  el.className = "comemoracao__banner";
  el.setAttribute("aria-hidden", "true");
  el.innerHTML = [..."PARABÉNS!"]
    .map((ch) => `<span class="comemoracao__letra">${ch}</span>`)
    .join("");
  document.body.append(el);

  const letters = el.querySelectorAll(".comemoracao__letra");
  createTimeline({ onComplete: () => el.remove() })
    .add(letters, {
      translateY: [-400, 0],
      rotate: [() => random(-180, 180), 0],
      opacity: [0, 1],
      duration: 900,
      delay: stagger(70),
      ease: "outBounce",
    })
    .add(letters, {
      scale: [1, 1.4, 1],
      duration: 400,
      delay: stagger(50),
      loop: 4,
      ease: "inOutQuad",
    })
    .add(letters, {
      translateY: () => random(600, 1000),
      rotate: () => random(-360, 360),
      opacity: 0,
      duration: 900,
      delay: stagger(40, { from: "random" }),
      ease: "inBack",
    });
}

// Pisca a tela de branco, como um flash de fotógrafo.
function flash() {
  const el = document.createElement("div");
  el.className = "comemoracao__flash";
  document.body.append(el);
  animate(el, {
    opacity: [0.9, 0],
    duration: 600,
    ease: "outQuad",
    onComplete: () => el.remove(),
  });
}

// ---------- Estrelas ----------

const STAR_SVG = `
  <svg viewBox="-50 -50 100 100" aria-hidden="true">
    <polygon points="0,-48 11,-15 46,-15 18,6 29,40 0,19 -29,40 -18,6 -46,-15 -11,-15" />
  </svg>`;

// Uma estrela grande e transparente que "sai do monitor": nasce pequena perto
// do centro e cresce enquanto foge para a borda, num caminho cheio de desvios
// e girando ora para um lado, ora para o outro.
function flyingStar() {
  const el = document.createElement("div");
  el.className = "comemoracao__estrela";
  el.innerHTML = STAR_SVG;
  el.style.color = COLORS[Math.floor(random(0, COLORS.length))];
  document.body.append(el);

  const angle = random(0, 2 * Math.PI);
  const reach = Math.max(window.innerWidth, window.innerHeight) * 0.8;
  const steps = 5;
  const duration = random(2200, 3500);
  const step = duration / steps;

  // A distância cresce com o quadrado do tempo: devagar no fundo, rápido
  // quando chega "perto". O desvio lateral é o movimento errático.
  const path = Array.from({ length: steps }, (_, i) => {
    const t = (i + 1) / steps;
    const dist = reach * t * t;
    const wobble = random(-120, 120) * t;
    return {
      x: Math.cos(angle) * dist - Math.sin(angle) * wobble,
      y: Math.sin(angle) * dist + Math.cos(angle) * wobble,
    };
  });

  let turn = 0;
  animate(el, {
    translateX: path.map((p) => ({ to: p.x, duration: step, ease: "inOutSine" })),
    translateY: path.map((p) => ({ to: p.y, duration: step, ease: "inOutSine" })),
    rotate: path.map(() => ({ to: (turn += random(-240, 240)), duration: step, ease: "inOutQuad" })),
    scale: [{ from: 0.1, to: random(4, 7), duration, ease: "inQuad" }],
    opacity: [
      { from: 0, to: 0.45, duration: duration * 0.2 },
      { to: 0.45, duration: duration * 0.5 },
      { to: 0, duration: duration * 0.3 },
    ],
    onComplete: () => el.remove(),
  });
}

function flyingStars(duration) {
  repeat(flyingStar, 180, duration);
}

// ---------- Tudo junto ----------

export function comemorar() {
  flash();
  banner();
  danceCards();
  cannons(3000);
  fireworks(6000);
  emojiRain(5000);
  flyingStars(6500);
  setTimeout(grandFinale, 6000);
  setTimeout(flash, 6000);
}
