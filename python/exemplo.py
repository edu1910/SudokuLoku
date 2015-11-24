import sudoku, curses, os, pickle

def desenha_sudoku(window, grade, selecao):
    curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)

    for lin_grade in range(3):
        for col_grade in range(3):
            regiao = grade[lin_grade][col_grade]
            for lin_regiao in range(3):
                for col_regiao in range(3):
                    posicao = (lin_grade*27)+(col_grade*3)+(lin_regiao*9)+col_regiao+1

                    celula = regiao[lin_regiao][col_regiao]

                    y = 4*(col_grade+1)-4+col_regiao
                    x = 4*(lin_grade+1)-4+lin_regiao

                    if posicao == selecao:
                        window.addstr(x, y, celula[sudoku.DIGITO], curses.color_pair(1))
                    else:
                        window.addstr(x, y, celula[sudoku.DIGITO])
                    #window.getch()
                    window.refresh()


'''
Exemplo de uso da biblioteca sudoku
'''

try:
    arquivo = open('jogo.save', 'rb')
    jogo = pickle.load(arquivo)
    solucao = pickle.load(arquivo)
    arquivo.close()

    os.remove('jogo.save')
except:
    jogo, solucao = sudoku.inicia_sudoku()

    arquivo = open('jogo.save', 'wb')
    pickle.dump(jogo, arquivo)
    pickle.dump(solucao, arquivo)
    arquivo.close()

stdscr = curses.initscr()

curses.start_color()
curses.noecho()
curses.cbreak()
curses.curs_set(False)

stdscr.clear()

selecao = 1

window1 = curses.newwin(80, 50, 0, 0)
desenha_sudoku(window1, jogo, selecao)
window2 = curses.newwin(80, 50, 0, 40)
desenha_sudoku(window2, solucao, -1)

key = window1.getch()

while key != 10:
    key = chr(key)
    if key == 'w':
        if (selecao - 9) >= 1:
            selecao -= 9
    elif key == 's':
        if (selecao + 9) <= 81:
            selecao += 9
    elif key == 'a':
        if (selecao - 1) >= 1:
            selecao -= 1
    elif key == 'd':
        if (selecao + 1) <= 81:
            selecao += 1

    desenha_sudoku(window1, jogo, selecao)
    key = window1.getch()

curses.endwin()
