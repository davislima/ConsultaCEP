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
  View.Frame.PopUpDialogBox,
  Controller.ConsultarCEP;

type
  TExecutarProcedure = procedure of object; // ROTINA PopUpDialogBox_PerguntaComOpcoes

  TfrmPrincipal = class(TForm)
    layoutToolBar: TLayout;
    lblToolBar: TLabel;
    layoutToolBar_PesquisarCEP: TLayout;
    panelBuscarCEP: TPanel;
    eBuscarCEP: TEdit;
    cebBuscarCEP: TClearEditButton;
    imagemBuscarCEP: TImage;
    StyleBookTemaEscuro: TStyleBook;
    layoutMensagemEspera: TLayout;
    rectMensagemEspera_PreencheTelaTransparente: TRectangle;
    layoutMensagemEspera_BoxMeio: TLayout;
    arcAnimacaoEsperaFundo: TArc;
    rectMensagemEspera_BoxMeio: TRectangle;
    shadowMensagemEspera_BoxMeio: TShadowEffect;
    arcAnimacaoEspera: TArc;
    FloatAnimationAnimacaoEspera: TFloatAnimation;
    lblMensagemEspera: TLabel;
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
    frameTelaPopUpDialogBox: TframeTelaPopUpDialogBox;

    procedure eBuscarCEPEnter(Sender: TObject);
    procedure eBuscarCEPExit(Sender: TObject);
    procedure eBuscarCEPTyping(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BotaoSuperiorDireitoClick(Sender: TObject);
    procedure imagemBuscarCEPClick(Sender: TObject);
    procedure eBuscarCEPKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);

  private
    procedure TelaMensagemEspera (TextoMensagem: String;
                                  HabilitaMensagem: Boolean);
    procedure MensagemTThreadSynchronize (Mensagem: String);
    procedure PopUpDialogBox_PerguntaComOpcoes (MensagemDialogBox,
                                                Mensagem00,
                                                Mensagem01,
                                                Mensagem02,
                                                Mensagem03,
                                                Mensagem04,
                                                Mensagem05,
                                                Mensagem06: String;
                                                ExecutarRotina00,
                                                ExecutarRotina01,
                                                ExecutarRotina02,
                                                ExecutarRotina03,
                                                ExecutarRotina04,
                                                ExecutarRotina05,
                                                ExecutarRotina06: TExecutarProcedure);
    procedure RotinaNaoExecutaNadaPopUpDialogBox;
    procedure LimparLabels_frmPrincipal;
    procedure EnderecoToLabels(pEndereco: TConsultarCEP);
    procedure ConsultarCEP;

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
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

procedure TfrmPrincipal.TelaMensagemEspera (TextoMensagem: String;
                                            HabilitaMensagem: Boolean);
begin
   TThread.Synchronize(nil,
   procedure
   begin
      layoutMensagemEspera.Visible         := HabilitaMensagem;
      FloatAnimationAnimacaoEspera.Enabled := HabilitaMensagem;
      lblMensagemEspera.Text               := TextoMensagem;

      layoutMensagemEspera_BoxMeio.BringToFront;
   end);
end;

procedure TfrmPrincipal.MensagemTThreadSynchronize (Mensagem: String);
begin
   TThread.Synchronize(nil,
   procedure
   begin
      PopUpDialogBox_PerguntaComOpcoes (Mensagem,
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        RotinaNaoExecutaNadaPopUpDialogBox,
                                        RotinaNaoExecutaNadaPopUpDialogBox,
                                        RotinaNaoExecutaNadaPopUpDialogBox,
                                        RotinaNaoExecutaNadaPopUpDialogBox,
                                        RotinaNaoExecutaNadaPopUpDialogBox,
                                        RotinaNaoExecutaNadaPopUpDialogBox,
                                        RotinaNaoExecutaNadaPopUpDialogBox);
   end);
end;

procedure TfrmPrincipal.PopUpDialogBox_PerguntaComOpcoes (MensagemDialogBox,
                                                          Mensagem00,
                                                          Mensagem01,
                                                          Mensagem02,
                                                          Mensagem03,
                                                          Mensagem04,
                                                          Mensagem05,
                                                          Mensagem06: String;
                                                          ExecutarRotina00,
                                                          ExecutarRotina01,
                                                          ExecutarRotina02,
                                                          ExecutarRotina03,
                                                          ExecutarRotina04,
                                                          ExecutarRotina05,
                                                          ExecutarRotina06: TExecutarProcedure);
begin
   TThread.Synchronize(nil,
   procedure
   var
      arrayPopUpDialogBox: TArray<String>;
   begin
      // APAGAR QUALQUER ELEMENTO QUE ESTEJA NA MATRIZ
      arrayPopUpDialogBox           := nil;
      arrayPopUpDialogBoxProcedures := nil;

      // INFORMO A DIMENSÃO DO array COM O TOTAL DE OPÇÕES DO MENU
      SetLength (arrayPopUpDialogBox, 07); {TArray<String>}
      SetLength (arrayPopUpDialogBoxProcedures, 07); {Array of Procedure of object}

      // INFORMO AS OPÇÕES DO MENU
      arrayPopUpDialogBox [0] := Mensagem00;
      arrayPopUpDialogBox [1] := Mensagem01;
      arrayPopUpDialogBox [2] := Mensagem02;
      arrayPopUpDialogBox [3] := Mensagem03;
      arrayPopUpDialogBox [4] := Mensagem04;
      arrayPopUpDialogBox [5] := Mensagem05;
      arrayPopUpDialogBox [6] := Mensagem06;

      // INFORMO AS ROTINAS QUE SERÃO EXECUTADAS EM CADA ListBoxItem
      arrayPopUpDialogBoxProcedures [0] := ExecutarRotina00;
      arrayPopUpDialogBoxProcedures [1] := ExecutarRotina01;
      arrayPopUpDialogBoxProcedures [2] := ExecutarRotina02;
      arrayPopUpDialogBoxProcedures [3] := ExecutarRotina03;
      arrayPopUpDialogBoxProcedures [4] := ExecutarRotina04;
      arrayPopUpDialogBoxProcedures [5] := ExecutarRotina05;
      arrayPopUpDialogBoxProcedures [6] := ExecutarRotina06;

      // ADICIONA OS ÍTENS AO MENU E EXECUTA A TELA PopUpDialogBox
      frameTelaPopUpDialogBox.ExecutaTelaPopUpDialogBox (arrayPopUpDialogBox,
                                                         MensagemDialogBox);
   end);
end;

procedure TfrmPrincipal.RotinaNaoExecutaNadaPopUpDialogBox ();
begin
   // NÃO EXECUTA NADA, POIS É QUANDO A OPÇÃO NÃO TEM NADA A EXECUTAR, ÓBVIO, KKKKK
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
         MensagemTThreadSynchronize('Formato de CEP inválido!');
         LimparLabels_frmPrincipal;
         exit;
      end;

      TelaMensagemEspera ('Consultando CEP...',  True);

      try
         xConsultarCEP := TConsultarCEP.Create;
         xConsultarCEP.ConsultarAPIsCEP(eBuscarCEP.Text, xConsultarCEP.Endereco);

         if xConsultarCEP.Endereco.Status = 200 then
            EnderecoToLabels(xConsultarCEP)
         else
         if xConsultarCEP.Endereco.Status = 404 then
         begin
            MensagemTThreadSynchronize('CEP não encontrado!');
            LimparLabels_frmPrincipal;
         end
         else
         begin
            MensagemTThreadSynchronize('Serviço de consulta de CEP indisponível no momento!');
            LimparLabels_frmPrincipal;
         end;
      finally
         TelaMensagemEspera (EmptyStr,  False);

         if Assigned(xConsultarCEP) then FreeAndNil(xConsultarCEP);
      end;
   end).Start;
end;

end.


