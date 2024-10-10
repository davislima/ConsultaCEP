unit View.Frame.PopUpDialogBox;

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
   FMX.Objects,
   FMX.Controls.Presentation,
   FMX.Ani,
   FMX.Effects,
   FMX.ScrollBox,
   FMX.Memo,
   FMX.ListBox,
   FMX.Layouts,
   FMX.Memo.Types,
   FMX.Edit;

type
   TframeTelaPopUpDialogBox = class(TFrame)
      TelaComFundoEscuroMeioTransparente: TRectangle;
      faRectPopUpDialogBox_Movimento: TFloatAnimation;
      lbPopUpDialogBox: TListBox;
      lbiPopUpDialogBox00: TListBoxItem;
      lbiPopUpDialogBox01: TListBoxItem;
      lbiPopUpDialogBox02: TListBoxItem;
      lbiPopUpDialogBox03: TListBoxItem;
      lbiPopUpDialogBox04: TListBoxItem;
      lbiPopUpDialogBox05: TListBoxItem;
      lbiPopUpDialogBox06: TListBoxItem;
      lbiPopUpDialogBoxSair: TListBoxItem;
      rectMemoPopUpDialogBox: TRectangle;
      memoPopUpDialogBox: TMemo;
      faTelaComFundoEscuroMeioTransparente_Opacity: TFloatAnimation;
      rectBottonTelaPopUpDialogBox: TRectangle;
      panelPopUpDialogBox: TPanel;

      procedure TelaComFundoEscuroMeioTransparenteClick(Sender: TObject);
      procedure faRectPopUpDialogBox_MovimentoFinish(Sender: TObject);
      procedure lbPopUpDialogBoxItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);

   private
      FNomeForm: TForm;

      procedure AbrirTelaPopUpDialogBox;
      procedure FecharTelaPopUpDialogBox;
      procedure ExecutarOpcao00(Sender: TObject);
      procedure ExecutarOpcao01(Sender: TObject);
      procedure ExecutarOpcao02(Sender: TObject);
      procedure ExecutarOpcao03(Sender: TObject);
      procedure ExecutarOpcao04(Sender: TObject);
      procedure ExecutarOpcao05(Sender: TObject);
      procedure ExecutarOpcao06(Sender: TObject);
      procedure ExecutarOpcaoSair(Sender: TObject);

   public
      procedure ExecutarTelaPopUpDialogBox(arrayPopUpDialogBox: TArray<String>;
                                           aMensagemDialogBox: String;
                                           aNomeForm: TForm);

end;

var
   // VARIÁVEL QUE CONTÉM AS PROCEDURES DAS OPÇÕES DO PopUpDialogBox
   arrayPopUpDialogBoxProcedures: Array of Procedure of object;

implementation

{$R *.fmx}

uses
   Controller.Ferramentas.AparenciaAPP,
   Controller.Frame.PopUpDialogBox;

procedure TframeTelaPopUpDialogBox.TelaComFundoEscuroMeioTransparenteClick(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
end;

procedure TframeTelaPopUpDialogBox.ExecutarTelaPopUpDialogBox(arrayPopUpDialogBox: TArray<String>;
                                                              aMensagemDialogBox: String;
                                                              aNomeForm: TForm);
begin
   TThread.Synchronize(nil,
   procedure
   var
      i,
      xItemInicialEmbranco: Integer;
   begin
      try
         FNomeForm := aNomeForm;

         // MESAGEM DO PopUpDialogBox
         memoPopUpDialogBox.Lines.Clear;

         memoPopUpDialogBox.Text := aMensagemDialogBox;
         xItemInicialEmbranco    := 0;

         // INCLUI OS ÍTENS DO MENU PopUp
         for i := 0 to High(arrayPopUpDialogBox) do
         begin
            if TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [i]))) is TListBoxItem then
            begin
               // HABILITO VISUALMENTE OS ÍTENS NO MENU
               TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [i]))).Visible := True;

               // INFORMO O NOME DE CADA OPÇÃO DO MENU
               TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [i]))).Text := arrayPopUpDialogBox [i];

               // VERIFICO O PRIMEIRO ÍTEM QUE ESTÁ EM BRANCO
               if (Trim(arrayPopUpDialogBox [i]) = EmptyStr) and (xItemInicialEmbranco = 0) then
                  xItemInicialEmbranco := i;
            end;
         end;

         // SE xItemInicialEmbranco IGUAL A "-1" É PORQUE NÃO TEM NENHUMA OPÇÃO EM BRANCO
         // E NESSE CASO A POSIÇÃO DA OPÇÃO "SAIR" SEMPRE SERÁ A ÚLTIMA
         if (TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [0]))) is TListBoxItem) and
            (Trim(TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [High(arrayPopUpDialogBox)]))).Text) <> '') then
            xItemInicialEmbranco := High(arrayPopUpDialogBox) + 1;

         // ALTERO A ORDEM DO ÚLTIMO ListBoxItem, QUE É A OPÇÃO "SAIR" PARA QUE FIQUE ABAIXO
         // DO ÚLTIMO ÍTEM DA LISTA
         lbiPopUpDialogBoxSair.Index := xItemInicialEmbranco;

         // O PRÓXIMO for DESABILITA VISUALMENTE OS ÍTENS DO MENU QUE NÃO SERÃO UTILIZADOS
         // NA TELA PopUp E COLOQUEI "xItemInicialEmbranco +1" NO for, POIS IREI DESABILITAR
         // APENAS OS ÍTENS POSTERIORES, OU SEJA, A PARTIR DO ÚLTIMO ÍTEM DO MENU.
         // AJUSTO O TAMANHO DO rectPopUpDialogBox E A VARIÁVEL xItemInicialEmbranco INICIA
         // A PARTIR DO PRIMEIRO ÍTEM EM BRANCO, OU SEJA, SEM OPÇÃO A EXECUTAR
         for i := xItemInicialEmbranco to Pred(lbPopUpDialogBox.Count) do
         begin
            if TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [i]))) is TListBoxItem then
            begin
               // DESATIVO VISUALMENTE O ListBoxItem DO MENU QUE NÃO É NECESSÁRIO
               TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [i]))).Visible := False;

               // DIMINUO O TAMANHO DO rectPopUpDialogBox PARA CABER SÓ O TOTAL DE OPÇÕES
               // COLOQUEI "+1" NO xItemInicialEmbranco POIS TEM MAIS O ÚLTIMO
               // ListBoxItem, QUE É A OPÇÃO "SAIR"
               panelPopUpDialogBox.Height := (xItemInicialEmbranco + 1) * TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [i]))).Height;
            end;
         end;

         // QUANDO NÃO TIVER NENHUM ÍTEM EM BRANCO, O TAMANHO DO rect SERÁ O TAMANHO
         // DE TODAS AS OPÇÕES
         if xItemInicialEmbranco = High(arrayPopUpDialogBox) + 1 then
            panelPopUpDialogBox.Height := (xItemInicialEmbranco + 1) * TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [0]))).Height;

         // QUANDO O ÍTEM ZERO ESTIVER EM BRANCO SIGNIFICA DIZER QUE É APENAS UMA MENSAGEM INFORMATIVA
         // E NESSE CASO APAGO ESSE ÍTEM PARA NÃO FICAR MOSTRANDO NA TELA
         if (TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [0]))) is TListBoxItem) and
            (Trim(TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [0]))).Text) = '') then
         begin
            // DESATIVO VISUALMENTE O ListBoxItem DO MENU QUE NÃO É NECESSÁRIO
            TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [0]))).Visible := False;

            // COLOQUEI "+100" NO Height PARA AJUSTAR O TAMANHO E FICAR IDEAL
            panelPopUpDialogBox.Height := panelPopUpDialogBox.Height - TListBoxItem(FindComponent('lbiPopUpDialogBox' + Format('%2.2d', [0]))).Height;
         end;

         // AJUSTO O TAMANHO DO POPUP
         panelPopUpDialogBox.Height := panelPopUpDialogBox.Height + 20;

         // VAI PARA O PRIMEIRO ÍTEM DA LISTA
         lbPopUpDialogBox.ScrollToItem(lbPopUpDialogBox.ListItems[0]);

         // CHAMO A TELA COM O MENU
         AbrirTelaPopUpDialogBox;
      except
      end;
   end);
end;

procedure TframeTelaPopUpDialogBox.faRectPopUpDialogBox_MovimentoFinish(Sender: TObject);
begin
   TThread.Synchronize(nil,
   procedure
   begin
      if faRectPopUpDialogBox_Movimento.StopValue = FNomeForm.Height + 1 then
         if Assigned(TPopUpDialogBox.xFrameTelaPopUpDialogBox) then
            FreeAndNil(TPopUpDialogBox.xFrameTelaPopUpDialogBox);
   end);
end;

procedure TframeTelaPopUpDialogBox.FecharTelaPopUpDialogBox;
begin
   TThread.Synchronize(nil,
   procedure
   begin
      try
         // PARÂMETROS DO FloatAnimation
         faTelaComFundoEscuroMeioTransparente_Opacity.StartValue := 0.5;
         faTelaComFundoEscuroMeioTransparente_Opacity.StopValue  := 0;

         // INICIA O FloatAnimation
         faTelaComFundoEscuroMeioTransparente_Opacity.Start;

         // PARÂMETROS DA MOVIMENTAÇÃO DO FloatAnimationTelaPopUp
         faRectPopUpDialogBox_Movimento.StartValue := panelPopUpDialogBox.Position.Y;
         faRectPopUpDialogBox_Movimento.StopValue  := FNomeForm.Height + 1;

         // ALTERO ALGUMAS PROPRIEDADES DO FLOATANIMATTION E NO OnClose VOLTO AO "NORMAL"
         faRectPopUpDialogBox_Movimento.Duration      := 0.3;
         faRectPopUpDialogBox_Movimento.AnimationType := TAnimationType.In;
         faRectPopUpDialogBox_Movimento.Interpolation := TInterpolationType.Linear;

         // INICIA O FloatAnimationTelaPopUp
         faRectPopUpDialogBox_Movimento.Start;
      except
      end;
   end);
end;

procedure TframeTelaPopUpDialogBox.ExecutarOpcao00(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
   arrayPopUpDialogBoxProcedures[00];
end;

procedure TframeTelaPopUpDialogBox.ExecutarOpcao01(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
   arrayPopUpDialogBoxProcedures[01];
end;

procedure TframeTelaPopUpDialogBox.ExecutarOpcao02(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
   arrayPopUpDialogBoxProcedures[02];
end;

procedure TframeTelaPopUpDialogBox.ExecutarOpcao03(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
   arrayPopUpDialogBoxProcedures[03];
end;

procedure TframeTelaPopUpDialogBox.ExecutarOpcao04(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
   arrayPopUpDialogBoxProcedures[04];
end;

procedure TframeTelaPopUpDialogBox.ExecutarOpcao05(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
   arrayPopUpDialogBoxProcedures[05];
end;

procedure TframeTelaPopUpDialogBox.ExecutarOpcao06(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
   arrayPopUpDialogBoxProcedures[06];
end;

procedure TframeTelaPopUpDialogBox.ExecutarOpcaoSair(Sender: TObject);
begin
   FecharTelaPopUpDialogBox;
end;

procedure TframeTelaPopUpDialogBox.lbPopUpDialogBoxItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
   try
      if Item = lbiPopUpDialogBox00 then
         ExecutarOpcao00(Sender)
      else
      if Item = lbiPopUpDialogBox01 then
         ExecutarOpcao01(Sender)
      else
      if Item = lbiPopUpDialogBox02 then
         ExecutarOpcao02(Sender)
      else
      if Item = lbiPopUpDialogBox03 then
         ExecutarOpcao03(Sender)
      else
      if Item = lbiPopUpDialogBox04 then
         ExecutarOpcao04(Sender)
      else
      if Item = lbiPopUpDialogBox05 then
         ExecutarOpcao05(Sender)
      else
      if Item = lbiPopUpDialogBox06 then
         ExecutarOpcao06(Sender)
      else
      if Item = lbiPopUpDialogBoxSair then
         ExecutarOpcaoSair(Sender);
   except
   end;
end;

procedure TframeTelaPopUpDialogBox.AbrirTelaPopUpDialogBox;
begin
   TThread.Synchronize(nil,
   procedure
   var
      AlturaTela: Integer;
   begin
      try
         {$IFDEF ANDROID}
         // AJUSTA A StatusBar
         FNomeForm.DefinirStatusBar(FNomeForm.StatusBarTransparente {DefinirStatusBarTransparente},
                                    FNomeForm.StatusBarDarkMode {DefinirStatusBarDarkMode},
                                    FNomeForm.StatusBarCor {DefinirStatusBarCor});
         {$ENDIF}

         // PEGO A ALTURA DA TELA
         AlturaTela := FNomeForm.Height;

         {$IF Defined(MSWINDOWS) or Defined(MACOS)}
         rectBottonTelaPopUpDialogBox.Height := 10;

         // COLOQUEI "+110" NO Height PARA AJUSTAR O TAMANHO E FICAR IDEAL
         panelPopUpDialogBox.Height := panelPopUpDialogBox.Height + 110;
         {$ENDIF MSWINDOWS or MACOS}

         {$IFDEF ANDROID}
         rectBottonTelaPopUpDialogBox.Height := 10;

         // COLOQUEI "+110" NO Height PARA AJUSTAR O TAMANHO E FICAR IDEAL
         panelPopUpDialogBox.Height := panelPopUpDialogBox.Height + 110;
         {$ENDIF}

         {$IFDEF IOS}
         rectBottonTelaPopUpDialogBox.Height := 20;

         // COLOQUEI "+110" NO Height PARA AJUSTAR O TAMANHO E FICAR IDEAL
         panelPopUpDialogBox.Height := panelPopUpDialogBox.Height + 110;
         {$ENDIF}

         // HABILITO O FRAME
         FNomeForm.BringToFront;
         FNomeForm.Visible := True;

         // PARÂMETROS DO FloatAnimation
         faTelaComFundoEscuroMeioTransparente_Opacity.StartValue := 0;
         faTelaComFundoEscuroMeioTransparente_Opacity.StopValue  := 0.5;

         // INICIA O FloatAnimation
         faTelaComFundoEscuroMeioTransparente_Opacity.Start;

         // INICIA O rectTelaPopUpDialogBox ABAIXO DO TAMANHO DA TELA
         panelPopUpDialogBox.Position.Y := AlturaTela + 1;

         // HABILITO VISULAMENTE O MENU SUSPENSO
         panelPopUpDialogBox.Visible := True;

         // PARÂMETROS DA MOVIMENTAÇÃO DO FloatAnimationTelaPopUp
         faRectPopUpDialogBox_Movimento.StartValue := AlturaTela + 1;

         {$IF Defined(MSWINDOWS) or Defined(MACOS)}
         faRectPopUpDialogBox_Movimento.StopValue := AlturaTela - panelPopUpDialogBox.Height - 50;
         {$ENDIF MSWINDOWS or MACOS}

         {$IFDEF IOS}
         faRectPopUpDialogBox_Movimento.StopValue := AlturaTela - panelPopUpDialogBox.Height - 25;
         {$ENDIF}

         {$IFDEF ANDROID}
         faRectPopUpDialogBox_Movimento.StopValue := AlturaTela - panelPopUpDialogBox.Height - 12;
         {$ENDIF}

         // ALTERO ALGUMAS PROPRIEDADES DO FLOATANIMATTION E NO OnClose VOLTO AO "NORMAL"
         faRectPopUpDialogBox_Movimento.Duration      := 2;
         faRectPopUpDialogBox_Movimento.AnimationType := TAnimationType.Out;
         faRectPopUpDialogBox_Movimento.Interpolation := TInterpolationType.Elastic;

         // INICIA O FloatAnimationTelaPopUp
         faRectPopUpDialogBox_Movimento.Start;
      except
         FecharTelaPopUpDialogBox;
      end;
   end);
end;

end.


