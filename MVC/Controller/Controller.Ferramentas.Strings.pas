unit Controller.Ferramentas.Strings;

interface

uses
   System.Classes,
   System.SysUtils,
   FMX.ListBox,
   FMX.Graphics,
   FMX.TabControl;

   function BooleanToStrSimNao(CondicaoVerdadeira: Boolean): String;
   function SubstituiString(Tira: String;
                            Substitui: String;
                            Texto: String): String;
   function VoltaChaveUnicaBaseadaNaDataHoje: String;
   function VoltaMensagemPadraoErroConexao: String;

implementation

function BooleanToStrSimNao(CondicaoVerdadeira: Boolean): String;
begin
   if CondicaoVerdadeira then
      Result := 'S'
   else
      Result := 'N';
end;

function SubstituiString(Tira: String;
                         Substitui: String;
                         Texto: String): String;
var
   PosString: Integer;
begin
   try
      if Tira = Substitui then
      begin
         Result := Texto;
         exit;
      end;

      PosString := Pos (Tira, Texto);

      while PosString <> 0 do
      begin
         Delete (Texto, PosString, Length (Tira));
         Insert (Substitui, Texto, PosString);
         PosString := Pos (Tira, Texto);
      end;

      Result := Texto;
   except
   end;
end;

function VoltaChaveUnicaBaseadaNaDataHoje(): String;
begin
   try
      Result := FormatDateTime ('ddmmyyyyhhmmsszzz', now);
   except
      Result := '';
   end;
end;

function VoltaMensagemPadraoErroConexao: String;
begin
   Result := 'verifique se existe conexão com a internet.';
end;

end.
