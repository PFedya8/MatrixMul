Uses sysutils, The_Tree, Matrix_in_Tree;
type 
    matr_t = array of real;
var 
    file_n: string;
    f: text;
    mode, line: string;
    num_rows, num_columns, size: int64;
    matrix_density: real;
    a: matr_t;
    ne_nol, j, i, schet: integer;
    r: int64;
    osh: integer;
    x: Matrix_t;



function Rand_between(a, b: integer): real;
    begin
        Rand_between := a + (b - a) * random;
    end;
    
procedure One(var a: matr_t);
    var i: integer;
    begin
        for i := 0 to size - 1 do 
            begin
                a[i] := 1;
            end;
    end;

procedure Low(var a: matr_t);
    var i: integer;
    begin
        for i := 0 to size - 1 do 
            begin
                a[i] := Rand_between(-1, 1);
               
            end;
    end;

procedure High(var a: matr_t);
    var i: integer;
        l: integer;
    begin
        for i := 0 to size - 1 do 
            begin
                l := random(2);
                if l = 0 then a[i] := Rand_between(-1000, 0)
                else a[i] := Rand_between(0, 1000)
            end;
    end;

procedure Integ(var a: matr_t);
    var i, l: integer;
    begin
        for i := 0 to size - 1 do 
            begin
                l := random(2);
                if l = 0 then a[i] := random(0 + 1000 + 1) - 1000
                else a[i] := random(1000 + 1);
            end;
    end;

procedure Edin(var a: matr_t);
    begin
        writeln(f, 'Sparse_matrix', ' ', IntToStr(num_rows), ' ',
             IntToStr(num_columns), ' ', IntToStr(num_rows * num_columns));
        r := random(num_columns) + 1;
        for i := r to num_rows do
            begin
                write(f, IntToStr(i), ' ', IntToStr(i - r + 1), ' ', '1', #13#10);
            end;
        close(f);
    end;


begin
    begin
        if ParamCount = 0 then 
            begin
                Writeln('Вы не ввели параметры');
                halt(1);
            end;
        file_n := ParamStr(1);

        val(ParamStr(2), num_rows, osh);
        if (osh <> 0) or (num_rows <= 0) then halt(1);

        val(ParamStr(3), num_columns, osh);
        if (osh <> 0) or (num_columns <= 0) then halt(1);
            
        mode := ParamStr(4);
        if (mode <> 'random_high') and (mode <> 'random_low')
        and (mode <> 'all_one') and (mode <> 'one') 
        and (mode <> 'random_integers' ) then 
            begin
                Writeln('Неправильно введён режим генерации матрицы');
                halt(1);
            end;

        matrix_density := StrToFloat(ParamStr(5));
        if (matrix_density > 1.0) or (matrix_density <= 0.0) then
            begin
                writeln('Неправльно введены данные плотности');
                halt(1);
            end;

    end;
    randomize;
    {num_rows := 10;
    num_columns := 10;
    mode := 'all_one';
    matrix_density := 1.0;
    file_n := 'Gen_Matr.mtr';}
    ne_nol := round(matrix_density * num_columns);
 
    size := ne_nol * num_rows;
    //nol := num_columns - ne_nol;
    //writeln(nol, ne_nol, size);
    Setlength(a, size);
    assign(f , file_n + '.mtr');
    rewrite(f);

    if mode = 'all_one' then One(a)
    else if mode = 'random_low' then Low(a)
    else if mode = 'random_high' then High(a)
    else if mode = 'random_integers' then Integ(a)
    else if mode = 'one' then 
        begin
            Edin(a);
            Halt(0);
        end;
    
    writeln(f, 'Sparse_matrix', ' ', IntToStr(num_rows), ' ',
             IntToStr(num_columns), ' ', IntToStr(num_rows * num_columns));
    
    line := ' ';
    schet := 0;
    for i := 1 to num_rows  do 
        begin   
            for j := 1 to ne_nol do 
                begin
                    r := Random(num_columns) + 1 ;
                    while pos(' ' + IntToStr(r) + ' ', line) > 0 do
                        begin
                            r := Random(num_columns) + 1;
                        end; 
                    Write(f, IntToStr(i), ' ', IntToStr(r), ' ',  floatToStr(a[schet]), #13#10);
                    line := line + IntToStr(Round(r)) + ' ';
                    schet := schet + 1;
                end;
            line := ' ';
        end; 
    close(f);
    if (ParamCount() = 6) and (ParamStr(6) = 'print') then
        begin
            Input_Matrix(file_n + '.mtr', x);
            Print_in_terminal_dense(x);
        end;
    Delete(x.r, 0);
end.
