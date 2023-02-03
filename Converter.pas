uses The_Tree, Matrix_in_Tree;



var x: Matrix_t;
    f_1: text;
    ep: double;
    osh, kol_par: integer;


    {имя рез файла, файл который преобразуем, режим преобразования, 
    эпсила (если спарстуденс)}
begin
    kol_par := ParamCount();
    if ParamStr(3) = 'sparse2dense' then
        begin
            assign(f_1, ParamStr(1) + '.mtr');
            rewrite(f_1);
            Input_Matrix(ParamStr(2) + '.mtr', x);
            Print_Matrix_in_file_dense(ParamStr(1) + '.mtr', x);
            close(f_1);
            if kol_par > 3 then writeln('Введены лишние параметры, но ' +
                                        'выполнению не помешали')
        end
    else if ParamStr(3) = 'dense2sparse' then    
        begin
            if kol_par < 4 then
                begin
                    writeln('Вы не ввели Epsila');
                    halt(1);
                end;
            assign(f_1, ParamStr(1) + '.mtr');
            rewrite(f_1);
            val(ParamStr(4), ep, osh);
            if osh <> 0 then halt(1);
            Input_matrix_den(ParamStr(2) + '.mtr', x, ep);
            Print_Matrix_in_file(ParamStr(1) + '.mtr', x, 0);
            close(f_1);
            if kol_par > 4 then writeln('Введены лишние параметры, но ' +
                                        'выполнению не помешали')
        end
    else 
        begin
            writeln('Неправильно введен режим преобразования');
            halt(1);
        end;
    Delete(x.r, 0);



end.
