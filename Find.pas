
function Find(Types, Colors: Array of Word; Containers: Array of Cardinal): Array of Cardinal;
var _FindDistance, _FindVertical, It, Lt, Ic, Lc, Ir, Lr: Integer;
begin
  _FindDistance := FindDistance; FindDistance := -1;
  _FindVertical := FindVertical; FindVertical := -1; 
  Lt := Length(Types)-1;
  Lc := Length(Colors)-1;
  Lr := Length(Containers)-1;
  Result := [];
  if Lt >= 0 then begin
    for It := 0 to Lt do begin
      if Lc >= 0 then begin
        for Ic := 0 to Lc do begin
          if Lr >= 0 then begin
            for Ir := 0 to Lr do begin
              if FindTypeEx(Types[It], Colors[Ic], Containers[Ir], False) > 0 then Result := Union(Result, FoundItems);
            end;          
          end else begin
            if FindTypeEx(Types[It], Colors[Ic], Ground, True) > 0 then Result := Union(Result, FoundItems);
          end;
        end;      
      end else begin
        if Lr >= 0 then begin
          for Ir := 0 to Lr do begin
            if FindTypeEx(Types[It], $FFFF, Containers[Ir], False) > 0 then Result := Union(Result, FoundItems);
          end;          
        end else begin
          if FindTypeEx(Types[It], $FFFF, Ground, True) > 0 then Result := Union(Result, FoundItems);
        end;
      end;
    end;
  end else begin
    if Lc >= 0 then begin
      for Ic := 0 to Lc do begin
        if Lr >= 0 then begin
          for Ir := 0 to Lr do begin
            if FindTypeEx($FFFF, Colors[Ic], Containers[Ir], False) > 0 then Result := Union(Result, FoundItems);
          end;          
        end else begin
          if FindTypeEx($FFFF, Colors[Ic], Ground, True) > 0 then Result := Union(Result, FoundItems);
        end;
      end;      
    end else begin
      if Lr >= 0 then begin
        for Ir := 0 to Lr do begin
          if FindTypeEx($FFFF, $FFFF, Containers[Ir], False) > 0 then Result := Union(Result, FoundItems);
        end;
      end else begin
        if FindTypeEx($FFFF, $FFFF, Ground, True) > 0 then Result := FoundItems;
      end;
    end;
  end;
  FindDistance := _FindDistance;
  FindVertical := _FindVertical;
end;
