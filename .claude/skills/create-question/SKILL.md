---
name: question-writer
description: Elabora questões de avaliação (prova, quiz, lista de exercícios, banco de questões) sobre qualquer assunto — múltipla escolha, múltipla seleção, verdadeiro/falso, associação/correspondência, e outros formatos que o usuário pedir. Use esta skill sempre que o usuário pedir para criar, gerar, elaborar ou revisar questões, exercícios, avaliações, provas, quizzes ou um banco de questões — mesmo que ele não diga explicitamente "múltipla escolha" ou "quiz", mas descreva um conteúdo e peça para "testar o entendimento", "criar uma atividade" ou "preparar uma avaliação" sobre ele.
---

# Elaborador de questões

Esta skill ajuda a escrever questões de avaliação de qualidade sobre qualquer
conteúdo, em qualquer formato de questão. Ela não assume uma disciplina, um
formato de saída ou uma quantidade fixa — isso varia demais de um pedido para
o outro, e assumir errado custa mais tempo do que perguntar.

## Antes de escrever: alinhar o pedido

Antes de gerar qualquer questão, confirme com o usuário (por perguntas
diretas, ou por uma leitura cuidadosa do que ele já disse) os pontos abaixo.
Não repita perguntas cuja resposta já esteja clara no pedido — só pergunte o
que realmente falta.

1. **Conteúdo/escopo**: sobre o que são as questões? Se o usuário apontar um
   material de referência (notas de aula, um capítulo, um arquivo), leia-o
   antes de escrever — as questões devem cobrir o que foi de fato ensinado,
   nem mais nem menos.
2. **Categorias de questão**: múltipla escolha, múltipla seleção (mais de uma
   correta), verdadeiro/falso, associação/correspondência, dissertativa,
   preencher lacuna, ou outra? Ver `references/formatos.md` para o padrão de
   cada categoria.
3. **Quantidade**: quantas questões, de cada categoria? Não assuma um número
   padrão — pergunte.
4. **Nível/público**: qual o nível de dificuldade e para quem é (ensino
   médio, graduação, treinamento corporativo, etc.)? Isso muda o vocabulário,
   a complexidade dos distratores e a profundidade esperada da resposta.
5. **Formato de saída**: Markdown solto (um arquivo por questão ou um arquivo
   único), texto simples, ou um formato de importação específico (GIFT do
   Moodle, formato de outro LMS, CSV/planilha)? Se o usuário não especificar,
   Markdown com um arquivo por questão é um bom padrão neutro — mas confirme.
6. **Gabarito e justificativa**: incluir resposta correta e uma explicação
   do porquê (recomendado — ajuda tanto quem revisa quanto quem eventualmente
   recorre da questão), ou só o gabarito seco?

Depois de esclarecido isso, escreva as questões. Se o pedido já responde a
maioria desses pontos (ex.: "faça 5 questões de múltipla escolha sobre
fotossíntese, nível ensino médio, com gabarito"), não interrogue o usuário —
confirme o que faltar e vá direto ao trabalho.

## Escrevendo boas questões

Uma questão malfeita testa se o aluno decora truques da prova, não se ele
entende o conteúdo. Ao escrever, preste atenção a:

* **Uma ideia por questão.** Não misture dois conceitos independentes na
  mesma pergunta — isso confunde o diagnóstico de quem errou (não dá pra
  saber qual dos dois conceitos a pessoa não entendeu).
* **Resposta inequívoca.** Para múltipla escolha/seleção, a alternativa
  correta deve ser correta sem ambiguidade, e as erradas devem ser
  claramente erradas para quem domina o conteúdo — mas plausíveis para quem
  tem um equívoco comum. Distratores absurdos ("nenhuma das anteriores é
  possível porque a lua é de queijo") não testam nada.
* **Sem pistas gramaticais ou de tamanho.** Evite que só a alternativa
  correta concorde gramaticalmente com o enunciado, ou que ela seja sempre a
  mais longa/detalhada — alunos atentos exploram esse tipo de vazamento.
* **Fidelidade ao escopo.** Não introduza conceitos que não foram cobertos
  no material de referência, a menos que o usuário peça explicitamente
  questões de aprofundamento.
* **Independência entre questões.** Uma questão não deveria depender da
  resposta de outra, nem entregar a resposta de outra questão do mesmo
  conjunto.
* **Verdadeiro/falso sem armadilha barata.** Evite negações duplas ou
  pegadinhas puramente sintáticas; a dificuldade deve vir do conteúdo, não
  da leitura.
* **Associação com pareamento único.** Garanta que cada item da coluna A
  corresponda a exatamente um item da coluna B (ou deixe claro se algum item
  de B sobra de propósito, para evitar acerto por eliminação).

## Formatos de questão

Consulte `references/formatos.md` para o template de cada categoria
(múltipla escolha, múltipla seleção, verdadeiro/falso, associação,
dissertativa, preencher lacuna) com exemplos preenchidos. Adapte o template
ao formato de saída acordado com o usuário — o arquivo mostra a estrutura de
conteúdo, não uma sintaxe obrigatória.

## Organização dos arquivos

Quando a saída for Markdown e o usuário não pedir uma estrutura específica,
um arquivo por questão (numerado, com um nome curto indicando a categoria e o
tema) funciona bem para bancos de questão que depois são importados um a um
em algum ambiente de ensino:

```
exercicios/
├── 01-multipla-escolha-<tema>.md
├── 02-verdadeiro-falso-<tema>.md
└── ...
```

Para uma lista de exercícios de uso corrido (prova, lista para imprimir), um
único arquivo com todas as questões em sequência costuma ser mais prático.
Pergunte se não estiver claro qual dos dois casos se aplica.