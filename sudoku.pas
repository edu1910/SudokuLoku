unit sudoku;

interface

    type sudoku_celula =
        record
            digito : char;
            automatico : boolean;
        end;
    type sudoku_regiao = array[1..3,1..3] of sudoku_celula;
    type sudoku_grade = array[1..3,1..3] of sudoku_regiao;

    procedure inicia_sudoku(var jogo, solucao : sudoku_grade);

implementation

    const
        ESCONDER_MAX = 30;
        MIXAGEM = 42;

    procedure limpa_celulas(var grade : sudoku_grade);
    var
        lin_grade, lin_regiao : integer;
        col_grade, col_regiao : integer;
        regiao : sudoku_regiao;
        celula : sudoku_celula;
    begin
        for lin_grade := 1 to 3 do
        begin
            for col_grade := 1 to 3 do
            begin
                regiao := grade[lin_grade, col_grade];
                for lin_regiao := 1 to 3 do
                begin
                    for col_regiao := 1 to 3 do
                    begin
                        celula := regiao[lin_regiao, col_regiao];
                        celula.digito := '.';
                        celula.automatico := false;
                        regiao[lin_regiao, col_regiao] := celula;
                    end;
                end;
                grade[lin_grade, col_grade] := regiao;
            end;
        end;
    end;

    procedure solucao_padrao(var solucao : sudoku_grade);
    var
        lin_grade, lin_regiao : integer;
        col_grade, col_regiao : integer;
        regiao : sudoku_regiao;
        celula : sudoku_celula;
    begin
        for lin_grade := 1 to 3 do
        begin
            for col_grade := 1 to 3 do
            begin
                regiao := solucao[lin_grade, col_grade];
                for lin_regiao := 1 to 3 do
                begin
                    for col_regiao := 1 to 3 do
                    begin
                        celula := regiao[lin_regiao, col_regiao];
                        celula.digito := chr(48 + ((3*col_grade-3+col_regiao)
                            + ((3*lin_regiao-3)) + (lin_grade-1) -1) mod 9 + 1);
                        celula.automatico := true;
                        regiao[lin_regiao, col_regiao] := celula;
                    end;
                end;
                solucao[lin_grade, col_grade] := regiao;
            end;
        end;
    end;

    procedure embaralha_solucao(var solucao : sudoku_grade);
    var
        lin_grade, lin_regiao : integer;
        col_grade, col_regiao : integer;
        regiao : sudoku_regiao;
        celula : sudoku_celula;
        rnd1,rnd2 : integer;
        idx : integer;
    begin
        randomize;

        for idx := 1 to MIXAGEM do
        begin
            rnd1 := random(3)+1;
            rnd2 := random(3)+1;

            for col_grade := 1 to 3 do
            begin
                regiao := solucao[rnd1, col_grade];
                solucao[rnd1, col_grade] := solucao[rnd2, col_grade];
                solucao[rnd2, col_grade] := regiao;
            end;
        end;

        for idx := 1 to MIXAGEM do
        begin
            rnd1 := random(3)+1;
            rnd2 := random(3)+1;

            for lin_grade := 1 to 3 do
            begin
                regiao := solucao[lin_grade, rnd1];
                solucao[lin_grade, rnd1] := solucao[lin_grade, rnd2];
                solucao[lin_grade, rnd2] := regiao;
            end;
        end;

        for idx := 1 to MIXAGEM do
        begin
            lin_grade := random(3)+1;
            rnd1 := random(3)+1;
            rnd2 := random(3)+1;

            for col_grade := 1 to 3 do
            begin
                regiao := solucao[lin_grade, col_grade];
                for col_regiao := 1 to 3 do
                begin
                    celula := regiao[rnd1, col_regiao];
                    regiao[rnd1, col_regiao] := regiao[rnd2, col_regiao];
                    regiao[rnd2, col_regiao] := celula;
                end;
                solucao[lin_grade, col_grade] := regiao;
            end;
        end;

        for idx := 1 to MIXAGEM do
        begin
            col_grade := random(3)+1;
            rnd1 := random(3)+1;
            rnd2 := random(3)+1;

            for lin_grade := 1 to 3 do
            begin
                regiao := solucao[lin_grade, col_grade];
                for lin_regiao := 1 to 3 do
                begin
                    celula := regiao[lin_regiao, rnd1];
                    regiao[lin_regiao, rnd1] := regiao[lin_regiao, rnd2];
                    regiao[lin_regiao, rnd2] := celula;
                end;
                solucao[lin_grade, col_grade] := regiao;
            end;
        end;
    end;

    function solucao_valida(jogo : sudoku_grade; digito : char; posicao : integer) : boolean;
    var
        lin_grade, lin_regiao : integer;
        col_grade, col_regiao : integer;
        regiao : sudoku_regiao;
        celula : sudoku_celula;
        idx, jdx : integer;
    begin
        solucao_valida := true;

        lin_grade := (posicao-1) div 27 + 1;
        col_grade := ((posicao-1) div 3) mod 3 + 1;

        lin_regiao := (posicao - 27*(lin_grade-1) -1) div 9 + 1;
        col_regiao := (posicao - 27*(lin_grade-1) - 9*(lin_regiao-1) - 1) mod 3 + 1;

        regiao := jogo[lin_grade,col_grade];
        for idx := 1 to 3 do
        begin
            for jdx := 1 to 3 do
            begin
                celula := regiao[idx,jdx];
                if celula.digito = digito then
                begin
                    solucao_valida := false;
                    break;
                end;
            end;
        end;

        if solucao_valida then
        begin
            for idx := 1 to 3 do
            begin
                if idx <> lin_grade then
                begin
                    regiao := jogo[idx,col_grade];
                    for jdx := 1 to 3 do
                    begin
                        celula := regiao[jdx,col_regiao];
                        if celula.digito = digito then
                        begin
                            solucao_valida := false;
                            break;
                        end;
                    end;
                    if not solucao_valida then
                        break;
                end;
            end;
        end;

        if solucao_valida then
        begin
            for idx := 1 to 3 do
            begin
                if idx <> col_grade then
                begin
                    regiao := jogo[lin_grade,idx];
                    for jdx := 1 to 3 do
                    begin
                        celula := regiao[lin_regiao,jdx];
                        if celula.digito = digito then
                        begin
                            solucao_valida := false;
                            break;
                        end;
                    end;
                    if not solucao_valida then
                        break;
                end;
            end;
        end;
    end;

    function verifica_solucao_unica(var jogo : sudoku_grade; posicao : integer) : boolean;
    var
        celula, bkp_celula : sudoku_celula;
        regiao : sudoku_regiao;
        lin_grade, lin_regiao : integer;
        col_grade, col_regiao : integer;
        digito : char;
        primeira_solucao : boolean;
    begin
        if posicao = 82 then
        begin
            verifica_solucao_unica := true;
            exit;
        end;

        primeira_solucao := false;

        lin_grade := (posicao-1) div 27 + 1;
        col_grade := ((posicao-1) div 3) mod 3 + 1;

        lin_regiao := (posicao - 27*(lin_grade-1) -1) div 9 + 1;
        col_regiao := (posicao - 27*(lin_grade-1) - 9*(lin_regiao-1) - 1) mod 3 + 1;

        regiao := jogo[lin_grade,col_grade];
        celula := regiao[lin_regiao,col_regiao];

        if celula.digito <> '.' then
        begin
            verifica_solucao_unica := verifica_solucao_unica(jogo, posicao+1);
        end
        else
        begin
            bkp_celula := celula;

            for digito := '1' to '9' do
            begin
                if solucao_valida(jogo, digito, posicao) then
                begin
                    celula.digito := digito;
                    regiao[lin_regiao,col_regiao] := celula;
                    jogo[lin_grade,col_grade] := regiao;
                    verifica_solucao_unica := verifica_solucao_unica(jogo, posicao+1);
                    if verifica_solucao_unica then
                        if primeira_solucao = false then
                            primeira_solucao := true
                        else
                            verifica_solucao_unica := false
                    else
                        break;

                end;
            end;

            regiao[lin_regiao,col_regiao] := bkp_celula;
            jogo[lin_grade,col_grade] := regiao;
        end;
    end;

    function esconde_celula(var jogo : sudoku_grade; posicao : integer) : boolean;
    var
        celula, bkp_celula : sudoku_celula;
        lin_grade, lin_regiao : integer;
        col_grade, col_regiao : integer;
    begin
        esconde_celula := false;
        lin_grade := (posicao-1) div 27 + 1;
        col_grade := ((posicao-1) div 3) mod 3 + 1;

        lin_regiao := (posicao - 27*(lin_grade-1) -1) div 9 + 1;
        col_regiao := (posicao - 27*(lin_grade-1) - 9*(lin_regiao-1) - 1) mod 3 + 1;

        celula := jogo[lin_grade,col_grade][lin_regiao,col_regiao];
        if celula.automatico then
        begin
            bkp_celula := celula;
            celula.digito := '.';
            celula.automatico := false;
            jogo[lin_grade,col_grade][lin_regiao,col_regiao] := celula;
            esconde_celula := verifica_solucao_unica(jogo, 1);
            if not esconde_celula then
                jogo[lin_grade,col_grade][lin_regiao,col_regiao] := bkp_celula;
        end;
    end;

    procedure esconde_celulas(var jogo : sudoku_grade; solucao : sudoku_grade);
    var
        rnd : integer;
        celulas_escondidas : integer;
        tries : integer;
    begin
        tries := 0;

        randomize;
        jogo := solucao;

        celulas_escondidas := 0;

        while (celulas_escondidas < ESCONDER_MAX) and (tries < 50) do
        begin
            rnd := random(81)+1;

            if esconde_celula(jogo, rnd) then
            begin
                celulas_escondidas := celulas_escondidas + 1;
                tries := 0;
                if esconde_celula(jogo, 81-rnd+1) then
                    celulas_escondidas := celulas_escondidas + 1
            end;

            tries := tries+1;
        end;

        writeln(celulas_escondidas);
    end;

    procedure inicia_sudoku(var jogo, solucao : sudoku_grade);
    begin
        limpa_celulas(jogo);
        limpa_celulas(solucao);
        solucao_padrao(solucao);
        embaralha_solucao(solucao);
        esconde_celulas(jogo, solucao);
    end;

end.
