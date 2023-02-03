uses The_Tree, Matrix_in_Tree;
var mode, file_n: string;
    x: matrix_t;
    y: matrix_t;
    i: integer;
    t: array of string;
begin
    if ParamCount = 0 then 
        begin
            writeln('Вы не ввели параметры');
            halt(1);
        end;
    file_n := ParamStr(1);
    mode := ParamStr(2);
    Input_Matrix(ParamStr(1) + '.mtr', x);
    DOT(ParamStr(1), x.r, 0);
    Input_index(file_n + '.dot', y.r);
    if mode = 'root-left-right' then
        begin
            Root_left_right(y.r);
        end    
    else if mode = 'left-root-right' then
        begin
            Left_root_right(y.r);

        end
    else if mode = 'right-root-left' then 
        begin
            Right_root_left(y.r);
        end
    else if mode = 'levels' then 
        begin
            SetLength(t, Height_new(y.r, 1) + 1);
            for i := 0 to Height_new(y.r, 1) - 1 do 
                begin
                    t[i] := '';
                end;
            Levels(y.r, 1, 0, t);
            for i := 0 to Height_new(y.r, 1) - 1 do 
                begin
                    Writeln('Level=', i + 1);
                    writeln(t[i]);
                end;
        end
    else if mode = 'height' then 
        begin
            writeln(Height_new(y.r, 1));
        end
    else 
        begin
            writeln('Параметры введены неверно!');
            halt(1);
        end;
    Delete(x.r, 0);
    Delete(y.r, 0);
end.