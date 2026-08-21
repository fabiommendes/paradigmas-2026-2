"""Chamando Prolog a partir do Python com janus_swi.

janus_swi embeda o SWI-Prolog no mesmo processo do Python (sem precisar de
um servidor separado). Instale com:

    pip install janus-swi

Rode com: python3 queens_python.py
"""

import janus_swi as janus

janus.consult("queens_lib")  # carrega queens_lib.pl (rainhas/2, todas_rainhas/2)


def rainhas(n):
    """Devolve UMA solução para o problema das N rainhas, como lista de colunas."""
    for solucao in janus.query("rainhas(N, Posicoes)", {"N": n}):
        return solucao["Posicoes"]
    return None


def todas_as_rainhas(n):
    """Devolve TODAS as soluções, usando o predicado todas_rainhas/2 do Prolog.

    Repare que a busca com findall/3 fica dentro do arquivo .pl, não na
    consulta feita pelo Python: variáveis "de uso interno" de um findall/3
    (o template e a lista intermediária) não ficam disponíveis para o
    Python quando a consulta é feita diretamente, então é mais simples --
    e mais robusto -- expor um predicado já pronto do lado do Prolog.
    """
    resultado = janus.query_once("todas_rainhas(N, Todas)", {"N": n})
    return resultado["Todas"]


if __name__ == "__main__":
    posicoes = rainhas(8)
    print("Uma solução para 8 rainhas:", posicoes)

    todas = todas_as_rainhas(6)
    print(f"Total de soluções para 6 rainhas: {len(todas)}")
    print("Primeira:", todas[0])
