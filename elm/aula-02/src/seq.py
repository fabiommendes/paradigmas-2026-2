from __future__ import annotations

# type Seq a
#     = Empty
#     | Cons a (Seq a)


# Padrao 1: Hierarquia de classes
class Seq[a]: # Classe abstrata
    pass

class Empty[a](Seq[a]):
    pass

class Cons[a](Seq[a]):
    value: a
    tail: Seq[a]

# Classe que pode estragar tudo...
class Evil[a](Seq[a]):
    left: a
    right: a

# Modo 2: Classes disjuntas
type List[a] = Empty_ | Cons_[a]

class Empty_:
    pass

class Cons_[a]:
    value: a
    tail: List[a]
