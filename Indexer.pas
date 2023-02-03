uses The_Tree, Matrix_in_Tree;

var x: Matrix_t;


{Файл с матрицей}
begin
    Input_Matrix(ParamStr(1) + '.mtr', x);
    DOT(ParamStr(1), x.r, 0);
    Delete(x.r, 0);
end.
