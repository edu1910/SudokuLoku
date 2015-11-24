'''
SUDOKU
    Biblioteca para criação de uma partida de Sudoku.
    As sub rotinas iniciadas com __ não devem ser utilizadas diretamente.
    Busque por inicia_sudoku no final do arquivo.
'''

import random
import copy

DIGITO = 'digito'
AUTOMATICO = 'automatico'

__MIXAGEM__ = 42 #E a resposta para a Vida, o Universo e tudo mais é... 42!
__ESCONDER_MAX__ = 40 #Quantidade de casas a esconder da solução (max.: +-50)

def __constroi_grade__():
    grade = []

    for lin_grade in range(3):
        linha_grade = []
        for col_grade in range(3):
            regiao = []
            for lin_regiao in range(3):
                linha_regiao = []
                for col_regiao in range(3):
                    celula = {DIGITO : '.', AUTOMATICO : False}
                    linha_regiao.append(celula)
                regiao.append(linha_regiao)
            linha_grade.append(regiao)
        grade.append(linha_grade)

    return grade

def __solucao_padrao__(solucao):
    for lin_grade in range(3):
        for col_grade in range(3):
            regiao = solucao[lin_grade][col_grade]
            for lin_regiao in range(3):
                for col_regiao in range(3):
                    celula = regiao[lin_regiao][col_regiao]
                    celula[DIGITO] = chr(48 + ((3 * col_grade - 2 + col_regiao)
                            + ((3 * lin_regiao - 2)) + lin_grade - 1) % 9 + 1)
                    celula[AUTOMATICO] = True

def __embaralha_solucao__(solucao):
    for idx in range(__MIXAGEM__):
        rnd1 = random.randrange(3)
        rnd2 = random.randrange(3)

        for col_grade in range(3):
            regiao = solucao[rnd1][col_grade]
            solucao[rnd1][col_grade] = solucao[rnd2][col_grade]
            solucao[rnd2][col_grade] = regiao

    for idx in range(__MIXAGEM__):
        rnd1 = random.randrange(3)
        rnd2 = random.randrange(3)

        for lin_grade in range(3):
            regiao = solucao[lin_grade][rnd1]
            solucao[lin_grade][rnd1] = solucao[lin_grade][rnd2]
            solucao[lin_grade][rnd2] = regiao

    for idx in range(__MIXAGEM__):
        lin_grade = random.randrange(3)
        rnd1 = random.randrange(3)
        rnd2 = random.randrange(3)

        for col_grade in range(3):
            regiao = solucao[lin_grade][col_grade]
            for col_regiao in range(3):
                    celula = regiao[rnd1][col_regiao]
                    regiao[rnd1][col_regiao] = regiao[rnd2][col_regiao]
                    regiao[rnd2][col_regiao] = celula

    for idx in range(__MIXAGEM__):
        col_grade = random.randrange(3)
        rnd1 = random.randrange(3)
        rnd2 = random.randrange(3)

        for lin_grade in range(3):
            regiao = solucao[lin_grade][col_grade]
            for lin_regiao in range(3):
                celula = regiao[lin_regiao][rnd1]
                regiao[lin_regiao][rnd1] = regiao[lin_regiao][rnd2]
                regiao[lin_regiao][rnd2] = celula

def __solucao_valida__(jogo, digito, posicao):
    solucao_valida = True

    lin_grade = int((posicao - 1) / 27)
    col_grade = int((posicao - 1) / 3) % 3

    lin_regiao = int((posicao - 27 * lin_grade - 1) / 9)
    col_regiao = int((posicao - 27 * lin_grade - 9 * lin_regiao - 1) % 3)

    regiao = jogo[lin_grade][col_grade]
    for idx in range(3):
        for jdx in range(3):
            celula = regiao[idx][jdx]
            if celula[DIGITO] == digito:
                solucao_valida = False
                break

    if solucao_valida:
        for idx in range(3):
            if idx != lin_grade:
                regiao = jogo[idx][col_grade]
                for jdx in range(3):
                    celula = regiao[jdx][col_regiao]
                    if celula[DIGITO] == digito:
                        solucao_valida = False
                        break
                if not solucao_valida:
                    break

    if solucao_valida:
        for idx in range(3):
            if idx != col_grade:
                regiao = jogo[lin_grade][idx]
                if celula[DIGITO] == digito:
                    solucao_valida = False
                    break
            if not solucao_valida:
                break

    return solucao_valida
            
def __verifica_solucao_unica__(jogo, posicao):
    solucao_unica = True
    if posicao <= 81:
        primeira_solucao = False

        lin_grade = int((posicao - 1) / 27)
        col_grade = int(((posicao - 1) / 3) % 3)

        lin_regiao = int((posicao - 27 * lin_grade - 1) / 9)
        col_regiao = int(((posicao - 27 * lin_grade) - 9 * lin_regiao - 1) / 3)

        regiao = jogo[lin_grade][col_grade]
        celula = regiao[lin_regiao][col_regiao]

        if celula[DIGITO] != '.':
            solucao_unica = __verifica_solucao_unica__(jogo, posicao+1)
        else:
            bkp_celula = celula.copy()

            for digito in range(9):
                digito = chr(49 + digito)

                if __solucao_valida__(jogo, digito, posicao):
                    celula[DIGITO] = digito
                    solucao_unica = __verifica_solucao_unica__(jogo, posicao+1)
                    if solucao_unica:
                        if not primeira_solucao:
                            primeira_solucao = True
                        else:
                            solucao_unica = False
                    else:
                        break

            regiao[lin_regiao][col_regiao] = bkp_celula

    return solucao_unica

def __esconde_celula__(jogo, posicao):
    esconde_celula = False
    lin_grade = int((posicao - 1) / 27)
    col_grade = int((posicao - 1) / 3) % 3

    lin_regiao = int((posicao - 27 * lin_grade - 1) / 9)
    col_regiao = int((posicao - 27 * lin_grade - 9 * lin_regiao - 1) % 3)

    celula = jogo[lin_grade][col_grade][lin_regiao][col_regiao]

    if celula[AUTOMATICO]:
        bkp_celula = celula.copy()
        celula[DIGITO] = '.'
        celula[AUTOMATICO] = False
        esconde_celula = __verifica_solucao_unica__(jogo, 1)
        if not esconde_celula:
            jogo[lin_grade][col_grade][lin_regiao][col_regiao] = bkp_celula

    return esconde_celula

def __esconde_celulas__(jogo):
    tries = 0
    celulas_escondidas = 0

    while (celulas_escondidas < __ESCONDER_MAX__) and (tries < 50):
        rnd = random.randrange(81) + 1
        
        if __esconde_celula__(jogo, rnd):
            celulas_escondidas += 1
            tries = 0
            if __esconde_celula__(jogo, 81 - rnd + 1):
                celulas_escondidas += 1

        tries += 1

'''
inicia_sudoku
    Sub rotina que inicia uma partida de Sudoku.
    As matrizes são retornadas como listas de listas. Cada posição
    do tabuleiro é representada por um dicionário e contém as chaves
    digito e automatico (utilizar sudoku.DIGITO e sudoku.AUTOMATICO).

    - parâmetros: nenhum
    - retorno: duas matrizes com o jogo (tabuleiro) e a solução

    Exemplo de uso: jogo, solucao = sudoku.inicia_sudoku()
'''
def inicia_sudoku():
    solucao = __constroi_grade__()
    __solucao_padrao__(solucao)
    __embaralha_solucao__(solucao)
    jogo = copy.deepcopy(solucao)
    __esconde_celulas__(jogo)

    return jogo, solucao
