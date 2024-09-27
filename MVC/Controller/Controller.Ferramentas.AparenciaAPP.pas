unit Controller.Ferramentas.AparenciaAPP;

interface

uses
   FMX.Edit,
   FMX.Forms,
   System.Types,
   System.UITypes,
   System.SysUtils;

   function VoltaCorPadraoAPP(): TAlphaColor;
   function CorPadraoFundoAPP(): TAlphaColor;
   function CorPadraoDetalhesAPP(): TAlphaColor;
   function VoltaTextSettingsFontColorAPP(): TAlphaColor;
   function VoltaTextSettingsFontColorAPP_Cinza(): TAlphaColor;
   function VoltaCorIconesPadraoAPP(): TAlphaColor;
   function VoltaTamanhoTela(): Double;
   function VoltaTamanhoPadraoTela_iPhoneX_Ou_Superior(): Double;

var
  // VARIÁVEL QUE CONTROLA O TEMA DA APARÊNCIA DO APP
  TemaAparenciaEscuro: Boolean;

implementation

function VoltaCorPadraoAPP (): TAlphaColor;
begin
  {$IFDEF FILAVIP}
   Result := $FFB5076D;
  {$ENDIF}
end;

function CorPadraoFundoAPP (): TAlphaColor;
begin
   if TemaAparenciaEscuro then
      Result := TAlphaColorRec.Black
   else
      Result := TAlphaColorRec.White;
end;

function CorPadraoDetalhesAPP (): TAlphaColor;
begin
   if TemaAparenciaEscuro then
      Result := TAlphaColorRec.White
   else
      Result := TAlphaColorRec.Black;
end;

function VoltaTextSettingsFontColorAPP(): TAlphaColor;
begin
   Result := CorPadraoDetalhesAPP ();
end;

function VoltaTextSettingsFontColorAPP_Cinza(): TAlphaColor;
begin
   Result := TAlphaColorRec.Darkgray;
end;

function VoltaCorIconesPadraoAPP (): TAlphaColor;
begin
   {$IFDEF MEUQRCODE}
   Result := TAlphaColorRec.Steelblue;
   {$ENDIF}
end;

function VoltaTamanhoTela(): Double;
var
  TamanhoTela: TSizeF;
begin
   TamanhoTela := Screen.Size;
   Result      := TamanhoTela.cy;
end;

function VoltaTamanhoPadraoTela_iPhoneX_Ou_Superior(): Double;
begin
   Result := 812;
end;

end.
