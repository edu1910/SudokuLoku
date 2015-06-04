program SudokuLoku;
uses sudoku, crt;
type
    SudokuFile = file of sudoku_grade;
var jogo, solucao : sudoku_grade;
    sfile : SudokuFile;

procedure desenha_sudoku(jogo, solucao: sudoku_grade);
var
    lin_grade, lin_regiao : integer;
    col_grade, col_regiao : integer;
    regiao : sudoku_regiao;
    celula : sudoku_celula;
begin
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
end;

begin
    assign(sfile, 'teste.sku');
    reset(sfile);

    if ioresult = 0 then
    begin
        if not eof(sfile) then
        begin
            //seek(sfile,1);
            //read(sfile, jogo);
            seek(sfile,1);
            read(sfile, solucao);
            desenha_sudoku(jogo, solucao);
        end;

        close(sfile);
        erase(sfile);
        readkey;
        clrscr;
    end;

    inicia_sudoku(jogo, solucao);
    desenha_sudoku(jogo, solucao);

    rewrite(sfile);
    write(sfile, jogo);
    write(sfile, solucao);

    close(sfile);
    readkey;
end.
