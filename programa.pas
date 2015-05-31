program SudokuLoku;
uses sudoku, crt;
var jogo, solucao : sudoku_grade;
    lin_grade, lin_regiao : integer;
    col_grade, col_regiao : integer;
    regiao : sudoku_regiao;
    celula : sudoku_celula;
begin
    inicia_sudoku(jogo, solucao);
    window(1,1,80,50);

    for lin_grade := 1 to 3 do
    begin
        for col_grade := 1 to 3 do
        begin
            regiao := jogo[lin_grade, col_grade];
            for lin_regiao := 1 to 3 do
            begin
                for col_regiao := 1 to 3 do
                begin
                    gotoxy((4*col_grade-4)+col_regiao, (4*lin_grade-4)+lin_regiao);
                    celula := regiao[lin_regiao, col_regiao];
                    write(celula.digito);
                end;
            end;
        end;
    end;

    window(40,1,80,50);

    for lin_grade := 1 to 3 do
    begin
        for col_grade := 1 to 3 do
        begin
            regiao := solucao[lin_grade, col_grade];
            for lin_regiao := 1 to 3 do
            begin
                for col_regiao := 1 to 3 do
                begin
                    gotoxy((4*col_grade-4)+col_regiao, (4*lin_grade-4)+lin_regiao);
                    celula := regiao[lin_regiao, col_regiao];
                    write(celula.digito);
                end;
            end;
        end;
    end;

    readkey;
end.
