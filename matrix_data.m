clear;
clc;
close all;

Max_data_value = 2^(6)-1; % Maximum value of data
Ti=randi(10);
Tj=randi(10);
Tk=randi(10);
display(Ti);
display(Tj);
display(Tk);


Matrix1=randi(Max_data_value,Ti,Tj); %Create the first matrix
Transpose_Matrix1=Matrix1';                                          
vector1=Transpose_Matrix1(:);     %get the column vector of first matrix
display(vector1);
Matrix2=randi(Max_data_value,Tj,Tk);    %Create the second matrix
Transpose_Matrix2=Matrix2';                                          
vector2=Transpose_Matrix2(:);     %get the column vector of second matrix
display(vector2);
fid=fopen('D:\FPGA_project\multicore_optimize\simulation\modelsim\datain.txt','w');     %create and open the txt file 
fprintf(fid,'%d\n', Ti);
fprintf(fid,'%d\n',Tj);
fprintf(fid,'%d\n', Tk);
for i=0:Ti*Tj-1                              %first matrix
    fprintf(fid,'%d\n',vector1(i+1));
end
for i=0:Tj*Tk-1                               %second matrix
    fprintf(fid,'%d\n',vector2(i+1));
end

fclose(fid);                            %Close the file 

%output matrix
Matrix_out=Matrix1*Matrix2;
display(Matrix_out);
