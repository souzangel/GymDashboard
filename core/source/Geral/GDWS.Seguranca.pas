unit GDWS.Seguranca;

interface

uses
  Windows, Messages, Classes, Controls, Forms, sysutils,Registry,
  Dialogs, TLHelp32, GDWS.Utils, DBClient, midaslib, ExtCtrls, Math, GDWS.Base.Classe;

type
   TSeguranca = class(TGDWSBaseClasse)

   private
    FidCpuBanco: string;
    FidCpuLocal: string;
    FidHdBanco: string;
    FidHdLocal: string;
    Fativo: string;
    FExisteRegistro: string;

    procedure SetidCpuBanco(const Value: string);
    procedure SetidCpuLocal(const Value: string);
    procedure SetidHdBanco(const Value: string);
    procedure SetidHdLocal(const Value: string);
    procedure Setativo(const Value: string);
    procedure SetExisteRegistro(const Value: string);
    
   protected

   public
    class function criptografar(acao, Src: string): string; static;

    property idCpuLocal : string read FidCpuLocal write SetidCpuLocal;
    property idHdLocal  : string read FidHdLocal write SetidHdLocal;
    property idCpuBanco : string read FidCpuBanco write SetidCpuBanco;
    property idHdBanco  : string read FidHdBanco write SetidHdBanco;
    property Ativo      : string read FAtivo write SetAtivo;
    property ExisteRegistro : string  read FExisteRegistro write SetExisteRegistro;

    function  ComparaIds:boolean;

   end;

implementation

function TSeguranca.ComparaIds: boolean;
begin
  result := false;

  if {(idCpuLocal = idCpuBanco) and }(idHdLocal = idHdBanco) and (ativo = 'S') then
    result := true
  else
    result := false;

end;

class function TSeguranca.criptografar(acao,Src: string): string;
Label Fim;
var KeyLen : Integer;
  KeyPos : Integer;
  OffSet : Integer;
  Dest, Key : String;
  SrcPos : Integer;
  SrcAsc : Integer;
  TmpSrcAsc : Integer;
  Range : Integer;
begin
  if (Src = '') Then
  begin
    Result:= '';
    Goto Fim;
  end;
  Key := 'YUQL23KL23 DF90WI5E1J AS467NMCXX L6JAOAUWWM CL0AOMM4A4 VZYW9KHJUI 2347EJHJKD F3424SKLK3 LAKDJSL9RT';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if (acao = UpperCase('C')) then
  begin
//    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x',[OffSet]);
    for SrcPos := 1 to Length(Src) do
    begin
      Application.ProcessMessages;
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then KeyPos := KeyPos + 1 else KeyPos := 1;
      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x',[SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (acao = UpperCase('D')) then
  begin
    OffSet := StrToInt('$'+ copy(Src,1,2));
    SrcPos := 3;
  repeat
    SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));
    if (KeyPos < KeyLen) Then KeyPos := KeyPos + 1 else KeyPos := 1;
    TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
    else TmpSrcAsc := TmpSrcAsc - OffSet;
    Dest := Dest + Chr(TmpSrcAsc);
    OffSet := SrcAsc;
    SrcPos := SrcPos + 2;
  until (SrcPos >= Length(Src));
  end;
  Result:= Dest;
  Fim:
end;

procedure TSeguranca.Setativo(const Value: string);
begin
  Fativo := Value;
end;

procedure TSeguranca.SetExisteRegistro(const Value: string);
begin
  FExisteRegistro := Value;
end;

procedure TSeguranca.SetidCpuBanco(const Value: string);
begin
  FidCpuBanco := Value;
end;

procedure TSeguranca.SetidCpuLocal(const Value: string);
begin
  FidCpuLocal := Value;
end;

procedure TSeguranca.SetidHdBanco(const Value: string);
begin
  FidHdBanco := Value;
end;

procedure TSeguranca.SetidHdLocal(const Value: string);
begin
  FidHdLocal := Value;
end;

end.
