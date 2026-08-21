# Formatos de questão

Templates de conteúdo para cada categoria. A sintaxe Markdown abaixo é um padrão
neutro — ajuste para o formato de saída combinado com o usuário (GIFT, CSV,
texto simples, etc.), mas mantenha os elementos de conteúdo: enunciado, opções
(quando houver), resposta correta e justificativa.

## Múltipla escolha (uma resposta correta)

```markdown
# Questão — Múltipla escolha

**Tópico:** <tópico específico dentro do conteúdo>

**Enunciado:**

<contexto necessário, se houver, seguido da pergunta>

**Alternativas:**

a) <alternativa>

b) <alternativa>

c) <alternativa>

d) <alternativa>

**Resposta correta:** <letra>

**Justificativa:** <por que a correta está certa e, se ajudar, por que as
principais erradas parecem plausíveis mas não são>
```

## Múltipla seleção (mais de uma resposta correta)

Mesma estrutura da múltipla escolha, mas deixe claro no enunciado que pode haver
mais de uma alternativa correta, e liste todas as corretas na resposta:

```markdown
**Enunciado:**

Marque todas as afirmações **verdadeiras** sobre <tópico>.

**Resposta correta:** a, c, d
```

## Verdadeiro ou falso

```markdown
# Questão — Verdadeiro ou Falso

**Tópico:** <tópico>

**Enunciado:**

Considere a afirmação:

> "<afirmação a ser julgada>"

Essa afirmação é **verdadeira** ou **falsa**?

**Resposta correta:** Verdadeiro/Falso

**Justificativa:** <explicação>
```

Uma variante comum é apresentar várias afirmações numeradas de uma vez, pedindo
V ou F para cada uma — útil quando o usuário quer testar vários fatos
relacionados em uma única questão.

## Associação / correspondência

```markdown
# Questão — Associação

**Tópico:** <tópico>

**Enunciado:**

Associe cada item da coluna A com o item correspondente na coluna B.

**Coluna A**

1. <item>
2. <item>
3. <item>

**Coluna B**

a) <item>

b) <item>

c) <item>

**Associação correta:** 1-<letra>, 2-<letra>, 3-<letra>

**Justificativa:** <explicação de cada par, se não for óbvio>
```

Se algum item da coluna B não tiver correspondência (distrator), diga isso
explicitamente no enunciado — senão o aluno pode acertar por eliminação.

## Dissertativa / resposta curta

```markdown
# Questão — Dissertativa

**Tópico:** <tópico>

**Enunciado:**

<pergunta que exige uma resposta elaborada pelo aluno>

**Resposta esperada / critérios de correção:**

<pontos-chave que uma boa resposta deve conter, e não necessariamente uma
resposta pronta — para provas dissertativas o valor está nos critérios>
```

## Preencher lacuna

```markdown
# Questão — Preencher lacuna

**Tópico:** <tópico>

**Enunciado:**

<frase ou trecho de código com uma ou mais lacunas marcadas, ex: "O
predicado ___ decompõe um termo em uma lista de argumentos.">

**Resposta correta:** <palavra(s) que preenche(m) a lacuna>

**Justificativa:** <explicação, se não for óbvia>
```