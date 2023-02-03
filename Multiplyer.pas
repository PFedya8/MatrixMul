Uses The_Tree, Matrix_in_Tree;


var r,r_1, r_2, a, b, c, d: matrix_t;
    Ep: real;
    osh: integer;
    kol_par: integer;
    result: string;

procedure Multiplyer(var x: matrix_t; x1: matrix_t; x2: matrix_t);
    var i, j, k: int64;
        a, b, c: double;
        t1, t2: ptree_node_t;
        b1: boolean;
    begin
        b1 := False;
        if x1.num_columns <> x2.num_rows then
            begin
                Writeln('Неправильные размерности');
                Halt(1);
            end
        else 
            begin
                x.num_rows := x1.num_rows;
                x.num_columns := x2.num_columns
            end;
        for i := 1 to x.num_rows - 0 do
            begin
                for j := 1 to x.num_columns - 0 do 
                    begin
                        c := 0;
                        for k := 1 to x1.num_columns - 0 do 
                            begin
                                t1 := Searching_new(x1.r, i, k);
                                if t1 <> nil then 
                                    begin
                                        a := t1^.element;
                                    end;
                                if t1 = nil then 
                                    begin
                                        a := 0;
                                    end; 
                                
                                t2 := Searching_new(x2.r, k, j);
                                if t2 <> nil then
                                    begin
                                        b := t2^.element;
                                    end;
                                if t2 = nil then
                                    begin
                                        b := 0;
                                    end;
                                c := c + a * b;
                            end;
                            if c > Ep then 
                                begin
                                    Add_new(i, j, i * x.num_columns + j,
                                            c, x.r, b1);
                                end;
                    end;
            end;

    end;






{Парамаетры вводятся следующим образом:
1- название результирующего файла
2- значение эпсила
3- имя файла 1
4- имя файла 2
5-
6- имена других файлов}
begin
    kol_par := ParamCount;
    if (kol_par < 4)  or (kol_par > 6) then
        begin   
            writeln('Неправильное количество параметров');
            halt(1);
        end;
    result := ParamStr(1);
    
    val(ParamStr(2), ep, osh);
    if osh <> 0 then halt(1);
    Input_Matrix(ParamStr(3) + '.mtr', a);
    //ep := 9;
    Input_Matrix(ParamStr(4) + '.mtr', b);
    Multiplyer(r, a, b);
    if kol_par = 4 then 
        begin
            Print_Matrix_in_file(result + '.mtr', r, 0);
            DOT(result, r.r, 0);
        end;
    if kol_par = 5 then 
        begin
            Input_Matrix(ParamStr(5) + '.mtr', c);
            Multiplyer(r_1, r, c);
            Print_Matrix_in_file(result + '.mtr', r_1, 0);
            DOT(result, r_1.r, 0);
        end;
    if kol_par = 6 then 
        begin
            Input_Matrix(ParamStr(5) + '.mtr', c);
            Input_Matrix(ParamStr(6) + '.mtr', d);
            Multiplyer(r_1, c, d);
            Multiplyer(r_2, r, r_1);
        end;

    Delete(a.r, 0);
    Delete(r.r, 0);
    Delete(r_1.r, 0);
    Delete(r_2.r, 0);
    Delete(c.r, 0);
    Delete(d.r, 0);
    Delete(b.r, 0);
    
    {if kol_par > 4 then         
        begin
            for i := 4 to kol_par do 
                begin
                    Keep(r.r, 0);
                    Input_Matrix(ParamStr(i) + '.mtr', c);
                    writeln(r.num_columns);
                    Multiplyer(r_1, r, c);

                end;
            Print_Matrix_in_file(result, r, 0);
            DOT(result, r.r, 0);
        end;}

end.