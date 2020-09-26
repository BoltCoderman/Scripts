function FoundItems(): Array of Cardinal;
var Items: TStringList; i: Integer;
begin
  Items := TStringList.Create;
	GetFindedList(Items);
  SetLength(Result, Items.Count);
  for i := 0 to Items.Count-1 do Result[i] := StrToInt('$' + Items.Strings[i]);
  Items.Free;
end;

function First(Items: Array of Cardinal): Cardinal;
begin
  if Length(Items) > 0 then Result := Items[0] else Result := 0;
end;

function Last(Items: Array of Cardinal): Cardinal;
begin
  if Length(Items) > 0 then Result := Items[Length(Items)-1] else Result := 0;
end;

function IsContained(Item: Cardinal; Items: Array of Cardinal): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to Length(Items)-1 do begin
    if Item = Items[i] then begin
      Result := True;
      Break;
    end;
  end;
end;

function Union(const I1, I2: Array of Cardinal): Array of Cardinal;
var L, L1, L2, i, j: Integer; B: Boolean;
begin
  L := 0;
  L1 := Length(I1);
  L2 := Length(I2);
  SetLength(Result, L1 + L2);
  for i := 0 to L1-1 do begin
    B := False;
    for j := 0 to L-1 do begin
      if I1[i] = Result[j] then begin
        B := True;
        Break;
      end;
    end;
    if B = False then begin
      Result[L] := I1[i];
      L := L+1;
    end;
  end;
  for i := 0 to L2-1 do begin
    B := False;
    for j := 0 to L-1 do begin
      if I2[i] = Result[j] then begin
        B := True;
        Break;
      end;
    end;
    if B = False then begin
      Result[L] := I2[i];
      L := L+1;
    end;
  end;   
  SetLength(Result, L);
end;

function Intersection(const I1, I2: Array of Cardinal): Array of Cardinal;
var L, L1, L2, LM, i, j: Integer; B: Boolean;
begin
  L := 0;
  L1 := Length(I1);
  L2 := Length(I2);
  LM := L1;
  if LM < L2 then LM := L2;
  SetLength(Result, LM);
  for i := 0 to L1-1 do begin
    B := False;
    for j := 0 to L2-1 do begin
      if I1[i] = I2[j] then begin
        B := True;
        Break;
      end;
    end;
    if B = True then begin
      B := False;
      for j := 0 to L-1 do begin
        if I1[i] = Result[j] then begin
          B := True;
          Break;
        end;
      end;
      if B = False then begin
        Result[L] := I1[i];
        L := L+1;     
      end;
    end;
  end;
  SetLength(Result, L);
end;

function Complement(const I1, I2: Array of Cardinal): Array of Cardinal;
var L, L1, L2, i, j: Integer; B: Boolean;
begin
  L := 0;
  L1 := Length(I1);
  L2 := Length(I2);
  SetLength(Result, L1 + L2);
  for i := 0 to L1-1 do begin
    B := False;
    for j := 0 to L2-1 do begin
      if I1[i] = I2[j] then begin
        B := True;
        Break;
      end;
    end;
    if B = False then begin
      for j := 0 to L-1 do begin
        if I1[i] = Result[j] then begin
          B := True;
          Break;
        end;
      end;
      if B = False then begin
        Result[L] := I1[i];
        L := L+1;
      end;    
    end;
  end;
  for i := 0 to L2-1 do begin
    B := False;
    for j := 0 to L1-1 do begin
      if I2[i] = I1[j] then begin
        B := True;
        Break;
      end;
    end;
    if B = False then begin
      for j := 0 to L-1 do begin
        if I2[i] = Result[j] then begin
          B := True;
          Break;
        end;
      end;
      if B = False then begin
        Result[L] := I2[i];
        L := L+1;
      end;    
    end;
  end;
  SetLength(Result, L);
end;

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
