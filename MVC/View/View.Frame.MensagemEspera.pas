unit View.Frame.MensagemEspera;

interface

uses
   System.SysUtils,
   System.Types,
   System.UITypes,
   System.Classes,
   System.Variants,
   FMX.Types,
   FMX.Graphics,
   FMX.Controls,
   FMX.Forms,
   FMX.Dialogs,
   FMX.StdCtrls,
   FMX.Controls.Presentation,
   FMX.Ani,
   FMX.Effects,
   FMX.Objects,
   FMX.Layouts;

type
   TframeMensagemEspera = class(TFrame)
      layoutMensagemEspera: TLayout;
      rectMensagemEspera_PreencheTelaTransparente: TRectangle;
      layoutMensagemEspera_BoxMeio: TLayout;
      arcAnimacaoEsperaFundo: TArc;
      rectMensagemEspera_BoxMeio: TRectangle;
      shadowMensagemEspera_BoxMeio: TShadowEffect;
      arcAnimacaoEspera: TArc;
      FloatAnimationAnimacaoEspera: TFloatAnimation;
      lblMensagemEspera: TLabel;

   private

   public
      class var xFrameMensagemEspera: TframeMensagemEspera;
      class procedure MensagemEspera(aTextoMensagem: String; aAtivar: Boolean; aParent: TFMXObject);

end;

implementation

{$R *.fmx}

uses
   Controller.Ferramentas.Strings;

class procedure TframeMensagemEspera.MensagemEspera(aTextoMensagem: String; aAtivar: Boolean; aParent: TFMXObject);
begin
   TThread.Synchronize(nil,
   procedure
   begin
      try
         if aAtivar then
         begin
            if not Assigned(xFrameMensagemEspera) then
            begin
               xFrameMensagemEspera        := TframeMensagemEspera.Create(aParent);
               xFrameMensagemEspera.Parent := aParent;
               xFrameMensagemEspera.Align  := TAlignLayout.Contents;
               xFrameMensagemEspera.Name   := 'frameMensagemEspera' + VoltaChaveUnicaBaseadaNaDataHoje;
            end;

            xFrameMensagemEspera.FloatAnimationAnimacaoEspera.Enabled := True;
            xFrameMensagemEspera.layoutMensagemEspera.Visible         := True;
            xFrameMensagemEspera.lblMensagemEspera.Text               := aTextoMensagem;
            xFrameMensagemEspera.layoutMensagemEspera_BoxMeio.BringToFront;
         end
         else
            if Assigned(xFrameMensagemEspera) then
            begin
               xFrameMensagemEspera.layoutMensagemEspera.Visible := False;
               FreeAndNil(xFrameMensagemEspera);
            end;
      except
      end;
   end);
end;

end.
