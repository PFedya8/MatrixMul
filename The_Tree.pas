unit The_Tree;

interface
uses SysUtils;
type 
    ptree_node_t = ^tree_node_t;

    key_t = record
            row, column: longint;
            end;

    tree_node_t = record
                internal_node_number: longint;
                key: key_t;
                element: double;
                left, right: ptree_node_t;
                dep: -1..1;
                    end;
var 
    f_1: text;
    w: ptree_node_t;
    q: array of ptree_node_t;


procedure Create(var x: ptree_node_t);
procedure LT(var x: ptree_node_t);
procedure LRT(var x: ptree_node_t);
procedure RT(var x: ptree_node_t);
procedure RLT(var x: ptree_node_t);
procedure Add(t: longint; var x: ptree_node_t; var f: boolean);
procedure Add_new(t: longint; y: longint; key: longint; valu: double; var x: ptree_node_t; var f: boolean);
function Depth(x: ptree_node_t; l: longint): longint;
function Searching(x: ptree_node_t; l, k: longint):ptree_node_t;
function Searching_new(x: ptree_node_t; l, k: longint):ptree_node_t;
procedure Delete(var x: ptree_node_t; l: longint);
{PrintIndex Part}
procedure Add_to_q(x: ptree_node_t);
function Get_from_q: ptree_node_t;
function Height(var x: ptree_node_t; l: longint):longint;
function Height_new(x: ptree_node_t; l: integer): integer;
procedure Levels(var x: ptree_node_t; l, k: longint; var t: array of string);
procedure Printing_n(var x: ptree_node_t);
procedure Root_left_right(var x: ptree_node_t);
procedure Left_root_right(var x: ptree_node_t);
procedure Right_root_left(var x: ptree_node_t);



{DOT Part}
procedure Labels(var x: ptree_node_t; l: longint);
procedure Edges(var x: ptree_node_t; l: longint);
procedure DOT(file_n: string; var x: ptree_node_t; l: longint);




implementation


procedure Create(var x: ptree_node_t);
    begin
        x := nil;    
    end;

{Часть поворотов деревьев}
procedure LT(var x: ptree_node_t);
    var l: ptree_node_t;
    begin
        l := x^.right;
        x^.right := l^.left;
        l^.left := x;
        x^.dep := 0;
        x := l;   
    end;

procedure LRT(var x: ptree_node_t);
    var l, k: ptree_node_t;
    begin
        l := x^.right;
        k := l^.left;
        l^.left := k^.right;
        k^.right := l;
        x^.right := k^.left;
        k^.left := x;
        if k^.dep = 1 then x^.dep := -1
        else x^.dep := 0;
        if k^.dep = -1 then l^.dep := 1
        else l^.dep := 0;
        x := k; 
    end;

procedure RT(var x: ptree_node_t);
    var l: ptree_node_t;
    begin
        l := x^.left;
        x^.left := l^.right;
        l^.right := x;
        x^.dep := 0;
        x := l;
       
    end;

procedure RLT(var x: ptree_node_t);
    var l, k: ptree_node_t;
    begin
        l := x^.left;
        k := l^.right;
        l^.right := k^.left;
        k^.left := l;
        x^.left := k^.right;
        k^.right := x;
        if k^.dep = -1 then x^.dep := 1
        else x^.dep := 0;
        if k^.dep = 1 then l^.dep := -1
        else l^.dep := 0;
        x := k;
    end;

{Часть с операциями над деревом}
procedure Add(t: longint; var x: ptree_node_t; var f: boolean);
    begin
        if (x = nil) then 
            begin
                New(x);
                f := true;
                x^.internal_node_number := t;
                x^.left := nil;
                x^.right := nil;
                x^.dep := 0;
            end
        else if t < x^.internal_node_number then
            begin
                Add(t, x^.left, f);
                if f then 
                    case x^.dep of
                        1:  begin
                                x^.dep := 0;
                                f := false;
                            end;
                        0: x^.dep := -1;
                        -1: begin 
                                if x^.left^.dep = -1 then
                                    begin
                                        RT(x)
                                    end
                                else RLT(x);
                                x^.dep := 0;
                                f := false;
                            end;
                    end;
            end            
                else if t > x^.internal_node_number then
                    begin
                        Add(t, x^.right, f);
                        if f then 
                            case x^.dep of
                                -1: begin
                                        x^.dep := 0;
                                        f := false;
                                    end;
                                0: x^.dep := 1;
                                1:  begin 
                                        if x^.right^.dep = 1 then LT(x)
                                        else LRT(x);
                                        x^.dep := 0;
                                        f := false;
                                    end;
                            end;
                    end
                else f := false;
    end;


procedure Add_new(t:longint; y: longint; key: longint; valu: double; var x: ptree_node_t; var f: boolean);
    begin
        if x = nil then 
        begin
            New(x);
            f := true;
            x^.internal_node_number := key;
            x^.element := valu;
            x^.key.row := t;
            x^.key.column := y;
            x^.left := nil;
            x^.right := nil;
            x^.dep := 0;
        end
        else if ((t < x^.key.row) or ((t = x^.key.row) and (y< x^.key.column))) then
            begin
                Add_new(t, y, key, valu, x^.left, f);
                if f then 
                    case x^.dep of
                        1:  begin
                                x^.dep := 0;
                                f := false;
                            end;
                        0:  x^.dep := -1;
                        -1: begin 
                                if (x^.left^.dep = -1) then RT(x)
                                else RLT(x);
                                x^.dep := 0;
                                f := false;
                            end;
                    end;
            end
        else if ((t > x^.key.row) or ((t = x^.key.row) and (y> x^.key.column))) then
            begin
                Add_new(t, y, key, valu, x^.right, f);
                if f then 
                    case x^.dep of
                        -1: begin
                                x^.dep := 0;
                                f := false;
                            end;
                        0:  x^.dep := 1;
                        1:  begin 
                                if (x^.right^.dep = 1) then LT(x)
                                else LRT(x);
                                x^.dep := 0;
                                f := false;
                            end;
                    end;
            end
        else f := false;
    end;







function Depth(x: ptree_node_t; l: longint): longint;
    var dlina1, dlina2: longint;
    begin
        if x = nil then Depth := l - 1
        else
            begin
                dlina1 := Depth(x^.left, l + 1);
                dlina2 := Depth(x^.right, l + 1);
                if dlina1 > dlina2 then Depth := dlina1
                else Depth := dlina2
            end;
    end;

function Searching(x: ptree_node_t; l, k: longint):ptree_node_t;
    var v1, v2: ptree_node_t;
    begin
        if x = nil then Searching := nil
        else 
            begin
                if (x^.key.row = l) and (x^.key.column = k) then Searching := x
                else 
                    begin
                        v1 := Searching(x^.left, l, k);
                        v2 := Searching(x^.right, l, k);
                        if v1 <> nil then Searching := v1;
                        if v2 <> nil then Searching := v2
                    end;
            end;
    end;


function Searching_new(x: ptree_node_t; l, k: longint):ptree_node_t;
    begin
        if x = nil then Searching_new := nil
        else 
            begin
                if (x^.key.row = l) and (x^.key.column = k) then Searching_new := x
                else 
                    begin
                        if ((l < x^.key.row ) or ((l = x^.key.row) 
                            and (k < x^.key.column))) then 
                                begin
                                    Searching_new := Searching_new(x^.left, l, k);
                                end;
                        if ((l > x^.key.row) or ((l = x^.key.row) 
                            and (k > x^.key.column))) then 
                                begin
                                    Searching_new := Searching_new(x^.right, l, k)
                                end;
                    
                    end;
            end;
    end;


procedure Delete(var x: ptree_node_t; l: longint);
    begin
        if x <> nil then
            with x^ do 
                begin
                    Delete(x^.left, l + 1);
                    Delete(x^.right, l + 1);
                    dispose(x);
                    x := nil;
                end;
    end;

procedure Add_to_q(x: ptree_node_t);
    begin
        SetLength(q, length(q) + 1);
        q[high(q)] := x;
    end;

function Get_from_q: ptree_node_t;
    var x: ptree_node_t;
        i: integer;
    begin
        Get_from_q := q[0];
        for i := 0 to high(q) do 
            begin
                x := q[i];
                q[i] := q[i + 1];
                q[i + 1] := x;
            end;
        SetLength(q, length(q) - 1);
    end;

{Часть для использования принт индекс}
function Height(var x: ptree_node_t; l: longint):longint;
    begin
        //l := L + 1;
        Height := 0;
        if x <> nil then
            begin
                Height := Height(x^.left, l + 1);
                Height := Height(x^.right, l + 1);
                writeln('l=', l, ' hi=', Height);
            end
        else if l > Height then Height := l;
        

    end;

function Height_new(x: ptree_node_t; l: integer): integer;
    var 
        d1, d2: integer;
        begin
            if x = nil then Height_new := l - 1
            else 
                begin
                    d1 := Height_new(x^.left, l + 1);
                    d2 := Height_new(x^.right, l + 1);
                    if d1 > d2 then Height_new := d1
                    else Height_new := d2;
                end;
        end;




procedure Printing_n(var x: ptree_node_t);
    begin
        if x <> nil then 
            begin
                write('{', x^.internal_node_number, ':');
                write(' (', x^.key.row, ',', x^.key.column, ')');
                write(' ',x^.element:0:10);
                if (x^.left <> nil) then write(' ', x^.left^.internal_node_number)
                else write(' NULL');
                if (x^.right <> nil) then write(' ', x^.right^.internal_node_number)
                else write(' NULL');

                writeln('}');
            end;
    end;

function Pechat(var x: ptree_node_t; l: longint): string;
    var row_str, column_str, valu_str, d, e, a: string;
    begin
        if x <> nil then
            begin
                row_str := IntToStr(x^.key.row);
                column_str := IntToStr(x^.key.column);
                valu_str := FloatToStr(x^.element);
                d := IntToStr(l);
                e := '{' + d + ' (' + row_str + ',' + column_str + ') ' 
                        + valu_str;
                if x^.left <> nil then
                    begin
                        a := IntToStr(l * 2);
                        e := e + ' ' + a + ' ';
                    end
                else 
                    begin
                        e := e + ' Null ';          
                    end;
                
                if x^.right <> nil then 
                    begin
                        a := IntToStr(l * 2 + 1);
                        e := e + ' ' + a + ' ';
                    end
                else
                    begin
                        e := e + ' Null ';
                    end;
                e := e + '}';
                Pechat := e;
            end;
    end;

procedure Levels(var x: ptree_node_t; l, k: longint; var t: array of string);
    begin
        t[k] := t[k] + ' ' + Pechat(x, l);
        if x^.left <> nil then 
            begin
                Levels(x^.left, l * 2 , k + 1, t);
            end;
        if x^.right <> nil then 
            begin
                Levels(x^.right, l * 2 + 1, k + 1, t);
            end;
    end;

procedure Root_left_right(var x: ptree_node_t);
    begin
        if x <> nil then 
            begin
                with x^ do 
                    begin
                        Printing_n(x);
                        Root_left_right(x^.left);
                        Root_left_right(x^.right);   
                    end;
            end;
    end;

procedure Left_root_right(var x: ptree_node_t);
    begin
        if x <> nil then 
            begin
                with x^ do 
                    begin
                        Left_root_right(x^.left);
                        writeln(x^.internal_node_number);
                        Left_root_right(x^.right);
                    end;
            end;
    end;

procedure Right_root_left(var x: ptree_node_t);
    begin
        if x <> nil then 
            begin
                with x^ do 
                    begin
                        Right_root_left(x^.right);
                        writeln(x^.internal_node_number);
                        Right_root_left(x^.left);
                    end;
            end;
    end;

//procedure Left_right_root



{DOT PART}

procedure Labels(var x: ptree_node_t; l: longint);
    begin
        if x <> nil then
            with x^ do
                begin
                    write(f_1, x^.internal_node_number, ' [label="');
                    write(f_1, x^.key.row, ' '); 
                    write(f_1, x^.key.column, '\n ');
                    writeln(f_1, x^.element:0:10, '"];');
                    Labels(x^.left, l + 1);
                    Labels(x^.right, l + 1);
                end;
    end;

procedure Edges(var x: ptree_node_t; l: longint);
    begin
        if x <> nil then
            with x^ do
                begin
                    if x^.left <> nil then 
                        begin
                            write(f_1, x^.internal_node_number,' -> ', 
                                  x^.left^.internal_node_number);
                            writeln(f_1,' [label="L"]');
                        end;

                    if x^.right <> nil then
                        begin
                            write(f_1, x^.internal_node_number,' -> ',
                                  x^.right^.internal_node_number);
                            writeln(f_1,' [label="R"]');
                        end;
                    Edges(x^.left, l+1);
                    Edges(x^.right, l+1)
                end;
    end;


procedure DOT(file_n: string; var x: ptree_node_t; l: longint);
    begin
        assign(f_1, file_n + '.dot');
        rewrite(f_1);
        writeln(f_1, 'digraph');
        writeln(f_1, '{');
        Labels(x, 0);
        writeln(f_1, '//edges');
        Edges(x, 0);
        writeln(f_1, '}');
        close(f_1)
    end;


end.
