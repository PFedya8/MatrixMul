unit Matrix_in_Tree;
interface

uses The_Tree, strutils, sysutils;

type matrix_t = record
    num_rows, num_columns: longint;
    r: ptree_node_t;
    end;
var f_1: text;

procedure Input_matrix(file_n:string; var a: matrix_t);
procedure Input_index(file_n: string; var x: ptree_node_t);
procedure Print_Matrix_in_file(file_n: string; var x: matrix_t; l: longint);
procedure Print_Matrix_in_file_dense(file_n: string; var x: matrix_t);
procedure Print_in_terminal_dense(var x: matrix_t);
procedure Input_matrix_den(file_n: string; var x: matrix_t; ep: double);



Implementation

{Считаывание спарсе матрицы}
procedure Input_Matrix(file_n: string; var a: matrix_t);
    var i, j: int64;
        q, b: boolean;
        s, s2, s3: string;
        k, osh, n: integer;
        valu: double;
    begin
        if not(FileExists(file_n)) then
            begin
                Writeln('Файл не существует');
                halt(1);
            end;
        Assign(f_1, file_n);
        reset(f_1);
        q := False;
        b := False;
        {Считывание данных про матрицу (кол-во стб и строк)}
        while (not eof(f_1)) and (q = False) do 
            begin
                readln(f_1, s2);
                s3 := ExtractWord(1, s2, [' ']);
                if s3 = 'Sparse_matrix' then 
                    begin
                        s := ExtractWord(2, s2, [' ']);
                        val(s, k, osh);
                        if (osh <> 0) or (k < 0) then 
                            begin
                                Writeln('Rows input is incorrect');
                                halt(1);
                            end;
                        a.num_rows := k;
                        //writeln(a.num_rows);
                        s := ExtractWord(3, s2, [' ']);
                        val(s, k, osh);
                        if (osh <> 0) or (k < 0) then 
                                begin
                                    Writeln('Column input is incorrect');
                                    halt(1); 
                                end;
                        a.num_columns := k;
                        //writeln(a.num_columns);
                        q := True;
                    end
                else if s3[1] <> '#' then   {Проверка на комментарии}
                    begin
                        writeln('File is incorrect');
                        halt(1);
                    end;
                
            end;
        n := 0;
        b := False;
        while (not eof(f_1)) do 
            begin
                read(f_1, i);
                read(f_1, j);
                readln(f_1, valu);
                //writeln(i, j,valu);
                Add_new(i, j, n, valu, a.r, b);
                n := n + 1;
            end;
        close(f_1);
    end;

{Считывание плотной матрицы}
procedure Input_matrix_den(file_n: string; var x: matrix_t; ep: double);
    var i, j: int64;
        q, b: boolean;
        s, s2, s3: string;
        k, osh, n: integer;
        valu: double;
    begin
        if not(FileExists(file_n)) then
            begin
                Writeln('Файл не существует');
                halt(1);
            end;
        Assign(f_1, file_n);
        reset(f_1);
        q := False;
        b := False;
        {Считывание данных про матрицу (кол-во стб и строк)}
        while (not eof(f_1)) and (q = False) do 
            begin
                readln(f_1, s2);
                s3 := ExtractWord(1, s2, [' ']);
                if s3 = 'Dense_matrix' then 
                    begin
                        s := ExtractWord(2, s2, [' ']);
                        val(s, k, osh);
                        if (osh <> 0) or (k < 0) then 
                            begin
                                Writeln('Rows input is incorrect');
                                halt(1);
                            end;
                        x.num_rows := k;
                        //writeln(x.num_rows);
                        s := ExtractWord(3, s2, [' ']);
                        val(s, k, osh);
                        if (osh <> 0) or (k < 0) then 
                                begin
                                    Writeln('Column input is incorrect');
                                    halt(1); 
                                end;
                        x.num_columns := k;
                        //writeln(x.num_columns);
                        q := True;
                    end
                else if s3[1] <> '#' then   {Проверка на комментарии}
                    begin
                        writeln('File is incorrect');
                        halt(1);
                    end;
            end;
        n := 0;
        b := False;

        for i := 1 to x.num_rows do 
            begin
                for j := 1 to x.num_columns do 
                    begin
                        if not eof(f_1) then
                            begin 
                                read(f_1, valu);
                                //writeln(valu);
                                if (valu > ep) and (valu <> 0) then 
                                    begin
                                        Add_new(i, j, n, valu, x.r, b);
                                        n := n + 1;
                                    end;
                            end;
                    end;
            end;
        close(f_1);
    end;

{Для принт индекса}
procedure Input_index(file_n: string; var x: ptree_node_t);
    var i, j, node: int64;
        b: boolean;
        s, s2, s3: string;
        k, osh: integer;
        valu: double;
    begin
        if x = nil then Create(x);
        if not(FileExists(file_n)) then
            begin
                Writeln('Файл не существует');
                halt(1);
            end;
        Assign(f_1, file_n);
        reset(f_1);
        b := False;
        k := 0;
        while (not eof(f_1)) and (k < 2) do
            begin
                readln(f_1, s);
                s2 := ExtractWord(1, s, [' ']);
                if s2 = 'digraph' then 
                    begin
                        if k = 0 then 
                            begin
                                k := k + 1;
                            end
                        else 
                            begin
                                writeln('wrong file 1');
                                halt(1);
                            end;    
                    end;
                
                if s2 = '{' then
                    begin
                        if k = 1 then 
                            begin
                                k := k + 1;
                            end
                        else 
                            begin
                                writeln('wrong file 2');
                                halt(1);
                            end;
                    end;
            end;

            k := 0;
            while (not eof(f_1)) and (k = 0) do 
                begin
                    readln(f_1, s);
                    s2 := ExtractWord(1, s, [' ']);
                    if s = '//edges' then k := 1
                    else
                        begin
                            val(s2, node, osh);
                            if (osh <> 0) or (node < 0) then 
                                begin
                                    writeln('wrong file 3');
                                    halt(1);
                                end;

                            s2 := ExtractWord(2, s, [' ']);
                            s3 := copy(s2, 9, length(s2) - 8); //length(s2) - 8
                            val(s3, i, osh);
                            if (osh <> 0) or (i < 0) then 
                                begin
                                    writeln('wrong file 4');
                                    halt(1);
                                end;

                            s2 := ExtractWord(3, s, [' ']);
                            s3 := copy(s2, 1, 1{length(s2) - 2});
                            val(s3, j, osh);
                            if (osh <> 0) or (j < 0) then 
                                begin
                                    writeln('wrong file 5');
                                    halt(1);
                                end;
                            
                            s2 := ExtractWord(4, s, [' ']);
                            //writeln(s2);
                            s3 := copy(s2, 1, length(s2) - 3);
                            val(s3, valu, osh);
                            if osh <> 0 then 
                                begin
                                    writeln('wrong file 6');
                                    halt(1);
                                end;
                            
                            Add_new(i, j, node, valu, x, b)
                        end;
                end;
    end;

procedure Print_help(var x: ptree_node_t; l: longint);
    begin
        if x <> nil then    
            begin
                with x^ do 
                    begin   
                        write(f_1, x^.key.row, ' ', x^.key.column, ' '); 
                        writeln(f_1, x^.element:0:10);
                        Print_help(x^.left, l + 1);
                        Print_help(x^.right, l + 1);
                    end;
            end;
    end;

{Печать разреженной матрицы в файл}
procedure Print_Matrix_in_file(file_n: string; var x: matrix_t; l: longint);
    begin
        assign(f_1, file_n);
        rewrite(f_1);
        //writeln(x.num_columns);
        writeln(f_1, 'Sparse_matrix', ' ', x.num_rows, ' ', x.num_columns,
                 ' ', x.num_columns * x.num_rows);
        Print_help(x.r, l);
        close(f_1);
    end;

{Печать плотной матрицы в файл}
procedure Print_Matrix_in_file_dense(file_n: string; var x: matrix_t);
    var i, j: int64;
        t: ptree_node_t;
    begin
        assign(f_1, file_n);
        rewrite(f_1);
        writeln(f_1, 'Dense_matrix', ' ', x.num_rows, ' ', x.num_columns,
                    ' ', x.num_columns * x.num_rows);
        for i := 1 to x.num_rows  do
            begin
                for j := 1 to x.num_columns  do 
                    begin
                        t := Searching_new(x.r, i, j);
                        if t <> nil then 
                            begin
                                write(f_1, t^.element:0:10, ' ');
                            end;
                        if t = nil then 
                            begin
                                write(f_1, 0.0:0:10, ' ');
                            end;
                    end;
                writeln(f_1)    
            end;

        close(f_1);
    end;


{Печать Плотной матрицы в терминал (принт в генераторе)}
procedure Print_in_terminal_dense(var x: matrix_t);
    var i, j: int64;
           t: ptree_node_t;
    begin
        writeln('Dense_matrix', ' ', x.num_rows, ' ', x.num_columns,
                    ' ', x.num_columns * x.num_rows);
        for i := 1 to x.num_rows do
            begin
                for j := 1 to x.num_columns do 
                    begin
                        t := Searching_new(x.r, i, j);
                        if t <> nil then 
                            begin
                                write(t^.element:0:10, ' ');
                            end;
                        if t = nil then 
                            begin
                                write(0.0:0:10, ' ');
                            end;
                    end;
                writeln()    
            end;
    end;    



end.