// Sons do jogo, sintetizados com a Web Audio API (sem arquivos de áudio).
//
// Outro candidato a porta: o Elm não toca som, então ele avisa "virei uma
// carta" e o JavaScript faz o barulho.

let context = null;

// O navegador só libera áudio depois de alguma interação do usuário com a
// página. Criamos o contexto na primeira chamada e o "acordamos" se preciso.
function audio() {
  context ??= new AudioContext();
  if (context.state === "suspended") context.resume();
  return context;
}

const random = (min, max) => Math.random() * (max - min) + min;

// Monta o som da carta virando em `ctx`, começando no instante `start`.
// Separado de playCardFlipSound para poder ser testado num contexto offline.
export function cardFlip(ctx, start = ctx.currentTime) {
  const out = ctx.createGain();
  out.gain.value = 0.6;
  out.connect(ctx.destination);

  // 1. O estalo: ruído branco passando por um filtro, bem curtinho. É o som
  //    do papel-cartão raspando no ar.
  const length = Math.floor(ctx.sampleRate * 0.12);
  const buffer = ctx.createBuffer(1, length, ctx.sampleRate);
  const data = buffer.getChannelData(0);
  for (let i = 0; i < length; i++) data[i] = Math.random() * 2 - 1;

  const noise = ctx.createBufferSource();
  noise.buffer = buffer;

  const band = ctx.createBiquadFilter();
  band.type = "bandpass";
  band.frequency.setValueAtTime(random(2500, 3500), start);
  band.frequency.exponentialRampToValueAtTime(1200, start + 0.08);
  band.Q.value = 0.8;

  const snap = ctx.createGain();
  snap.gain.setValueAtTime(0.0001, start);
  snap.gain.exponentialRampToValueAtTime(1, start + 0.004);
  snap.gain.exponentialRampToValueAtTime(0.0001, start + 0.09);

  noise.connect(band).connect(snap).connect(out);
  noise.start(start);
  noise.stop(start + 0.12);

  // 2. O "tum": um grave rápido que cai de tom, a carta tocando a mesa.
  const thump = ctx.createOscillator();
  thump.type = "sine";
  thump.frequency.setValueAtTime(random(170, 210), start + 0.02);
  thump.frequency.exponentialRampToValueAtTime(70, start + 0.1);

  const thumpGain = ctx.createGain();
  thumpGain.gain.setValueAtTime(0.0001, start + 0.02);
  thumpGain.gain.exponentialRampToValueAtTime(0.5, start + 0.03);
  thumpGain.gain.exponentialRampToValueAtTime(0.0001, start + 0.12);

  thump.connect(thumpGain).connect(out);
  thump.start(start + 0.02);
  thump.stop(start + 0.13);
}

export function playCardFlipSound() {
  cardFlip(audio());
}
