unit View.Principal.ConsultaCEP;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Edit,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.TabControl,
  FMX.Effects,
  Controller.ConsultarCEP;

type
  TfrmPrincipal = class(TForm)
    layoutToolBar: TLayout;
    lblToolBar: TLabel;
    layoutToolBar_PesquisarCEP: TLayout;
    panelBuscarCEP: TPanel;
    eBuscarCEP: TEdit;
    cebBuscarCEP: TClearEditButton;
    imagemBuscarCEP: TImage;
    StyleBookTemaEscuro: TStyleBook;
    tabPrincipal: TTabControl;
    tabConsultaCEP: TTabItem;
    panelConsultaCEP_Endereco: TPanel;
    lblConsultaCEP_Endereco_Cabecalho: TLabel;
    panelConsultaCEP_Cabecalho: TPanel;
    lblConsultaCEP_Cabecalho: TLabel;
    layoutConsultaCEP_Cidade_UF: TLayout;
    panelConsultaCEP_Bairro: TPanel;
    lblConsultaCEP_Bairro_Cabecalho: TLabel;
    panelConsultaCEP_Cidade: TPanel;
    lblConsultaCEP_Cidade_Cabecalho: TLabel;
    lblConsultaCEP_Cidade: TLabel;
    lblConsultaCEP_Endereco: TLabel;
    lblConsultaCEP_Bairro: TLabel;
    panelConsultaCEP_UF: TPanel;
    lblConsultaCEP_UF_Cabecalho: TLabel;
    lblConsultaCEP_UF: TLabel;
    BotaoSuperiorDireito: TSpeedButton;

    procedure eBuscarCEPEnter(Sender: TObject);
    procedure eBuscarCEPExit(Sender: TObject);
    procedure eBuscarCEPTyping(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BotaoSuperiorDireitoClick(Sender: TObject);
    procedure imagemBuscarCEPClick(Sender: TObject);
    procedure eBuscarCEPKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);

  private
    procedure LimparLabels_frmPrincipal;
    procedure EnderecoToLabels(pEndereco: TConsultarCEP);
    procedure ConsultarCEP;

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
   View.Frame.MensagemEspera,
   Controller.Frame.PopUpDialogBox,
   Controller.Ferramentas.Format,
   Controller.Ferramentas.Objects.Synchronize;

{$R *.fmx}

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
   ActiveTabTThreadSynchronize(tabPrincipal,
                               tabConsultaCEP);
   LimparLabels_frmPrincipal;

   ReportMemoryLeaksOnShutDown := True;
end;

procedure TfrmPrincipal.BotaoSuperiorDireitoClick(Sender: TObject);
begin
   ConsultarCEP;
end;

procedure TfrmPrincipal.eBuscarCEPEnter(Sender: TObject);
begin
   imagemBuscarCEP.Visible := False;
   eBuscarCEP.Margins.Left := 10;
   cebBuscarCEP.Visible    := True;

   if (Trim (eBuscarCEP.Text) = EmptyStr) or
      (Trim (eBuscarCEP.Text) = eBuscarCEP.TextPrompt) then
   begin
      eBuscarCEP.Text                   := EmptyStr;
      eBuscarCEP.TextSettings.FontColor := TAlphaColorRec.White;
   end;
end;

procedure TfrmPrincipal.eBuscarCEPExit(Sender: TObject);
begin
   imagemBuscarCEP.Visible := True;
   eBuscarCEP.Margins.Left := 5;
   cebBuscarCEP.Visible    := False;

   if (Trim (eBuscarCEP.Text) = EmptyStr) or
      (Trim (eBuscarCEP.Text) = eBuscarCEP.TextPrompt) then
   begin
      eBuscarCEP.Text                   := EmptyStr;
      eBuscarCEP.TextSettings.FontColor := TAlphaColorRec.Darkgray;
   end;
end;

procedure TfrmPrincipal.eBuscarCEPKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if Key = vkReturn then
      ConsultarCEP;
end;

procedure TfrmPrincipal.eBuscarCEPTyping(Sender: TObject);
begin
   Formatar (Sender, TFormato.CEP);
end;

procedure TfrmPrincipal.imagemBuscarCEPClick(Sender: TObject);
begin
   if eBuscarCEP.CanFocus then
      eBuscarCEP.SetFocus;
end;

procedure TfrmPrincipal.EnderecoToLabels(pEndereco: TConsultarCEP);
begin
   TThread.Synchronize(nil,
   procedure
   begin
      lblConsultaCEP_Cabecalho.Text := 'Endereço completo para o CEP: '+ FormatarCEP(pEndereco.Endereco.CEP);
      lblConsultaCEP_Endereco.Text  := pEndereco.Endereco.Endereco;
      lblConsultaCEP_Bairro.Text    := pEndereco.Endereco.Bairro;
      lblConsultaCEP_Cidade.Text    := pEndereco.Endereco.Cidade;
      lblConsultaCEP_UF.Text        := pEndereco.Endereco.Estado;
   end);
end;

procedure TfrmPrincipal.LimparLabels_frmPrincipal;
begin
   TThread.Synchronize(nil,
   procedure
   begin
      lblConsultaCEP_Cabecalho.Text := 'Endereço completo';
      lblConsultaCEP_Endereco.Text  := EmptyStr;
      lblConsultaCEP_Bairro.Text    := EmptyStr;
      lblConsultaCEP_Cidade.Text    := EmptyStr;
      lblConsultaCEP_UF.Text        := EmptyStr;
   end);
end;

procedure TfrmPrincipal.ConsultarCEP;
begin
   TThread.CreateAnonymousThread(
   procedure
   var
      xConsultarCEP: TConsultarCEP;
   begin
      if Trim (eBuscarCEP.Text) = EmptyStr then
         exit;

      if Length (eBuscarCEP.Text) <> 10 then
      begin
         TPopUpDialogBox.MensagemAviso('Formato de CEP inválido!', Self);
         LimparLabels_frmPrincipal;
         exit;
      end;

      TframeMensagemEspera.MensagemEspera('Consultando CEP...',  True, Self);

      try
         xConsultarCEP := TConsultarCEP.Create;
         xConsultarCEP.ConsultarAPIsCEP(eBuscarCEP.Text, xConsultarCEP.Endereco);

         if xConsultarCEP.Endereco.Status = 200 then
            EnderecoToLabels(xConsultarCEP)
         else
         if xConsultarCEP.Endereco.Status = 404 then
         begin
            TPopUpDialogBox.MensagemAviso('CEP não encontrado!', Self);
            LimparLabels_frmPrincipal;
         end
         else
         begin
            TPopUpDialogBox.MensagemAviso('Serviço de consulta de CEP indisponível no momento!', Self);
            LimparLabels_frmPrincipal;
         end;
      finally
         TframeMensagemEspera.MensagemEspera(EmptyStr,  False, Self);

         if Assigned(xConsultarCEP) then FreeAndNil(xConsultarCEP);
      end;
   end).Start;
end;

end.


