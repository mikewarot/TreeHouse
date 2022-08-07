unit mystrings;

{$mode ObjFPC}{$H+}

interface
  uses
    StrUtils;  // Hex2Dec

  type
    CharSet = Set of Char;

  procedure SkipSpace(Var S : String);

  function GrabString(Var S : String): String;

  Function GrabName(Var S : String): String;

  function GrabNumber(Var S : String): Int64;

  function GrabUntil(Var S : String; Delimiter : CharSet):String;

  function GrabLine(Var S : String): String;

  Function GrabQuotedString(Var S : String): String;

  Procedure Expect(Var S : String; ExpectedString : String);

implementation

  procedure SkipSpace(Var S : String);
  begin
    While (S <> '') AND (S[1] in [' ',',',#9,#13,#10]) do
      delete(s,1,1);
  end;

  function GrabString(Var S : String): String;
  var
    t : string;
  begin
    t := '';
    SkipSpace(S);
    while (s <> '') AND NOT(S[1] in [' ',#9,#13,#10]) do
    begin
      t := t + s[1];
      delete(s,1,1);
    end;
    GrabString := T;
  end;

  Function GrabName(Var S : String): String;
  var
    t : string;
  begin
    t := '';
    While (S <> '') AND (S[1] in ['A'..'Z','a'..'z']) do
    begin
      t := t + UpCase(s[1]);
      delete(s,1,1);
    end;
    GrabName := T;
  end;

  function GrabNumber(Var S : String): Int64;
  var
    sign : int64;
    x    : Int64;
  begin
    sign := +1;
    x := 0;
    SkipSpace(S);
    if (s <> '') and (s[1] = '-') then
    begin
      sign := -1;
      delete(s,1,1);
    end;
    while (s <> '') AND (s[1] in ['0'..'9']) do
    begin
      x := x * 10;
      x := x + (ord(s[1])-ord('0'));
      delete(s,1,1);
    end;
    x := x * sign;
    GrabNumber := X;
  end;

  function GrabUntil(Var S : String; Delimiter : CharSet):String;
  var
    t : string;
  begin
    Skipspace(S);
    t := '';
    SkipSpace(S);
    while (s <> '') AND NOT(S[1] in Delimiter) do
    begin
      t := t + s[1];
      delete(s,1,1);
    end;

    while (S <> '') AND (S[1] in Delimiter) do
      delete(s,1,1);

    GrabUntil := T;
  end; // GrabUntil

  function GrabLine(Var S : String): String;
  var
    t : string;
    c : string;
    done : boolean;
  begin
    t := '';
    done := Length(S) = 0;
    while not Done do
    begin
      c := s[1];  delete(s,1,1);
      case C of
        #10 : begin
                if (s <> '') AND (s[1] = #13) then delete(s,1,1);
                done := true;
              end;
        #13 : begin
                if (s <> '') AND (s[1] = #10) then delete(s,1,1);
                done := true;
              end;
      else
        t := t + c;
      end;
      if s = '' then done := true;
    end;
    GrabLine := T;
  end;

  Function GrabQuotedString(Var S : String): String;

    Function GrabChar : Char;
    begin
      if s <> '' then
        begin
          grabchar := s[1];
          delete(s,1,1);
        end
      else
        GrabChar := #0;
    end;

  var
    c : char;
    t : string;
    done : boolean;
  begin
    t := '';
    skipspace(S);
    If GrabChar = #39 then
    begin
      done := (s = '');
      while NOT Done do
      begin
        c := GrabChar;
        case C of
          '\' : begin
                  Case GrabChar of
                    'x' : begin
                            t := t + char(hex2dec(copy(s,1,2)));
                            delete(s,1,2);
                          end;
                    '\' : t := t + '\';
                    'n' : t := t + #10;
                  end; // case GrabChar
                end; // '\'
          #39 : Begin   // single quote  '
                  if (s = '') OR (s[1] <> #39) then
                    done := true
                  else
                    begin
                      delete(s,1,1);
                      t := t + #39;
                    end;
                  end
          else
            t := t + c;
          end; // case C
      end;
    end;
    GrabQuotedString := T;
  end;

  Procedure Expect(Var S : String; ExpectedString : String);
  begin
    If Pos(ExpectedString,S) = 1 then
      Delete(S,1,Length(ExpectedString));
  end;

end.

