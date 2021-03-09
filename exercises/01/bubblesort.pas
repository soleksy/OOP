program BubbleSort;
uses crt;

type
   list = array [0..9] of integer;

var
   size: integer = Length(list)-1;
   arr: list;
   sorted: list;
   i: integer;

function bubblesort(arr: list): list;

var
   temp: integer = 0;
   i: integer = 0;
   j: integer = 0;
   size: integer = Length(arr)-1;

begin

   for i := 0 to size do
      begin
         for j := 0 to size-i-1 do
            begin
               if(arr[j]>arr[j+1]) then begin
                  temp := arr[j];
                  arr[j] := arr[j+1];
                  arr[j+1] := temp;
               end;
            end;
      end;

   bubblesort := arr;
end;


begin
   Randomize;
   for i := 0 to size do
      begin
         arr[i] := Random(100);
      end;
      
   for i := 0 to size do
      begin
         writeln(arr[i]);
      end;

   sorted := bubblesort(arr);
   writeln('sorted:');

   for i := 0 to size do
      begin
         writeln(sorted[i]);
      end;

end.
