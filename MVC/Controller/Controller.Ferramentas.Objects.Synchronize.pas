unit Controller.Ferramentas.Objects.Synchronize;

interface

uses
   System.Classes,
   System.SysUtils,
   System.UITypes,
   System.Types,
   FMX.StdCtrls,
   FMX.Forms,
   FMX.ListBox,
   FMX.Controls,
   FMX.TabControl,
   FMX.Objects,
   FMX.Ani,
   FMX.Types,
   FMX.Graphics,
   FMX.ListView,
   FMX.Layouts,
   FMX.SearchBox,

   {$IFDEF ANDROID}
   Androidapi.Helpers,
   Androidapi.JNI.Net,
   Androidapi.JNI.GraphicsContentViewText,
   {$ENDIF}

   FMX.ListView.Types;

   procedure HabilitaDesabilitaListBoxItem(HabilitaDesabilita: Boolean; NomeListBoxItem: TListBoxItem);
   procedure ActiveTabTThreadSynchronize(NomeTabControl: TTabControl;
                                         NomeTabItem: TTabItem);
   procedure TransicaoTabItemTThreadSynchronize(NomeTabControl: TTabControl;
                                                NomeTabItem: TTabItem;
                                                DirecaoTransicaoTabItem: TTabTransitionDirection);
   procedure ScrollListBoxTThreadSynchronize(NomeControl: TControl;
                                             NomeListBox: TListBox;
                                             VoltaPosicaoNormal: Boolean);
   procedure ScrollListBoxItemTThreadSynchronize(NomeListBox: TListBox;
                                                 NomeListBoxItem: TListBoxItem);
   procedure MensagemSplashTThreadSynchronize(NomeForm: TForm;
                                              Mensagem: String);
   procedure ScrollListViewItemTThreadSynchronize(NomeListView: TListView;
                                                  ItemListView: Integer);
   procedure ScrollVertScrollBoxTThreadSynchronize(PositionY: Single;
                                                   aVertScrollBox: TVertScrollBox);
   procedure ClearListViewTThreadSynchronize(NomeListView: TListView);
   procedure ApagaFiltroListViewSearchBoxTThreadSynchronize(ListView: TListView);
   procedure ConfiguraWidthBordaDireita_ItemListView (NomeListView: TListView;
                                                      ItemIndex: Integer;
                                                      CampoListView: String;
                                                      WidthBordaDireita: Double);

implementation

uses
   Controller.Ferramentas.AparenciaAPP;

procedure ActiveTabTThreadSynchronize(NomeTabControl: TTabControl;
                                      NomeTabItem: TTabItem);
begin
   // SE USAR ActiveTab DEVE TER UM TThread.Synchronize
   TThread.Synchronize(nil,
   procedure
   begin
      try
         NomeTabControl.ActiveTab := NomeTabItem;
      except
      end;
   end);
end;

procedure TransicaoTabItemTThreadSynchronize(NomeTabControl: TTabControl;
                                             NomeTabItem: TTabItem;
                                             DirecaoTransicaoTabItem: TTabTransitionDirection);
begin
   // SE USAR SetActiveTabWithTransitionAsync DEVE TER UM TThread.Synchronize
   TThread.Synchronize(nil,
   procedure
   begin
      try
         // VAI PARA UMA TELA ESPECÍFICA
         NomeTabControl.SetActiveTabWithTransitionAsync(NomeTabItem,
                                                        TTabTransition.Slide,
                                                        DirecaoTransicaoTabItem,
                                                        nil);
      except
      end;
   end);
end;

procedure HabilitaDesabilitaListBoxItem(HabilitaDesabilita: Boolean; NomeListBoxItem: TListBoxItem);
begin
   TThread.Synchronize(nil,
   procedure
   begin
      try
         NomeListBoxItem.Visible := HabilitaDesabilita;
      except
      end;
   end);
end;

procedure ScrollListBoxTThreadSynchronize(NomeControl: TControl;
                                          NomeListBox: TListBox;
                                          VoltaPosicaoNormal: Boolean);
begin
   {$IFDEF IOS_ANDROID}
   TThread.Synchronize(nil,
   procedure
   begin
      try
         if VoltaPosicaoNormal then
            begin
               NomeListBox.Margins.Bottom := 0;
            end
         else
            begin
               // ESPAÇO MAIS OU MENOS OCUPADO PELO TECLADO
               NomeListBox.Margins.Bottom := 250;

               // POSICIONA O CAMPO ACIMA DO TECLADO COM UMA MARGEM PARA FICAR MAIS
               // OU MENOS NO MEIO, ENTRE O TECLADO E O INCÍCIO DA TELA
               NomeListBox.ViewportPosition := PointF (NomeListBox.ViewportPosition.X,
                                                       TControl (NomeControl).Position.Y-90);
            end;
      except
      end;
   end);
   {$ENDIF}
end;

procedure ScrollListBoxItemTThreadSynchronize (NomeListBox: TListBox;
                                               NomeListBoxItem: TListBoxItem);
begin
   // SE USAR ScrollToItem no ListBox DEVE TER UM TThread.Synchronize
   TThread.Synchronize(nil,
      procedure
      begin
         try
            NomeListBox.ScrollToItem (NomeListBoxItem);
         except
         end;
      end);
end;

procedure MensagemSplashTThreadSynchronize(NomeForm: TForm;
                                           Mensagem: String);
begin
   TThread.Synchronize(nil,
      procedure
      var
         NomeObjeto: String;
         lblMensagemSplash: TLabel;
         rectMensagemSplash: TRectangle;
         floatanimationMensagemSplash: TFloatAnimation;
      begin
         try
            // NOME DO OBJETO A SER CRIADO
            NomeObjeto := 'rectMensagemSplash';

            // APAGO DA MEMORIA O OBJETO ANTERIOR SE EXISTIR
            if TRectangle (NomeForm.FindComponent (NomeObjeto)) is TRectangle then
               begin
                  TRectangle (NomeForm.FindComponent (NomeObjeto)).DisposeOf;
               end;

            // CRIA UM RETÂNGULO NA TELA
            rectMensagemSplash := TRectangle.Create(NomeForm);
            rectMensagemSplash.Name := NomeObjeto;
            rectMensagemSplash.Parent := NomeForm;
            rectMensagemSplash.Align := TAlignLayout.Center;
            rectMensagemSplash.Height := 30;
            rectMensagemSplash.Width := NomeForm.Width-150;
            rectMensagemSplash.HitTest := False;
            rectMensagemSplash.Tag := 0;
            rectMensagemSplash.Fill.Color := VoltaCorIconesPadraoAPP ();
            rectMensagemSplash.Fill.Kind := TBrushKind.Solid;
            rectMensagemSplash.Stroke.Kind := TBrushKind.None;
            rectMensagemSplash.Stroke.Thickness := 0;
            rectMensagemSplash.Opacity := 0;
            rectMensagemSplash.XRadius := 10;
            rectMensagemSplash.YRadius := 10;
            rectMensagemSplash.Visible := True;

            // ADICIONA O OBJETO
            NomeForm.AddObject(rectMensagemSplash);

            floatanimationMensagemSplash := TFloatAnimation.Create(rectMensagemSplash);
            floatanimationMensagemSplash.Name := 'floatanimationMensagemSplash';
            floatanimationMensagemSplash.AnimationType := TAnimationType.Out;
            floatanimationMensagemSplash.AutoReverse := False;
            floatanimationMensagemSplash.Delay := 0;
            floatanimationMensagemSplash.Duration := 2.5;
            floatanimationMensagemSplash.Enabled := False;
            floatanimationMensagemSplash.Interpolation := TInterpolationType.Sinusoidal;
            floatanimationMensagemSplash.Inverse := False;
            floatanimationMensagemSplash.Loop := False;
            floatanimationMensagemSplash.PropertyName := 'Opacity';
            floatanimationMensagemSplash.StartValue := 0;
            floatanimationMensagemSplash.StopValue := 0.9;
            floatanimationMensagemSplash.Tag := 0;
//            floatanimationMensagemSplash.OnFinish := FloatAnimationOnFinish_MensagemSplash;

            // ADICIONA O OBJETO
            rectMensagemSplash.AddObject(floatanimationMensagemSplash);

            // ADICIONA UM Label AO rectMensagemSplash
            lblMensagemSplash := TLabel.Create(rectMensagemSplash);
            lblMensagemSplash.Text := Mensagem;
            lblMensagemSplash.Width := rectMensagemSplash.Width;
            lblMensagemSplash.Align := TAlignLayout.HorzCenter;
            lblMensagemSplash.Visible := True;
            lblMensagemSplash.StyledSettings := lblMensagemSplash.StyledSettings - [TStyledSetting.Size];
            lblMensagemSplash.StyledSettings := lblMensagemSplash.StyledSettings - [TStyledSetting.Style];
            lblMensagemSplash.StyledSettings := lblMensagemSplash.StyledSettings - [TStyledSetting.FontColor];
            lblMensagemSplash.TextSettings.Font.Size := 13;
            lblMensagemSplash.TextSettings.FontColor := TAlphaColorRec.White;
            lblMensagemSplash.TextSettings.Font.Style := [TFontStyle.fsBold];
            lblMensagemSplash.TextSettings.WordWrap := False;
            lblMensagemSplash.TextSettings.HorzAlign := TTextAlign.Center;
            lblMensagemSplash.TextSettings.Trimming := TTextTrimming.Character;
            lblMensagemSplash.HitTest := False;

            // ADICIONA OBJETO
            rectMensagemSplash.AddObject(lblMensagemSplash);

            // EXIBE OS ÍTENS DE FORMA SUAVE
            floatanimationMensagemSplash.Enabled := True;
         except
            rectMensagemSplash.DisposeOf;
         end;
      end);
end;

procedure ScrollListViewItemTThreadSynchronize(NomeListView: TListView;
                                               ItemListView: Integer);
begin
   // SE USAR ScrollViewPos no ListView DEVE TER UM TThread.Synchronize
   TThread.Synchronize(nil,
      procedure
      begin
         try
            NomeListView.ScrollViewPos := ItemListView;
         except
         end;
      end);
end;

procedure ScrollVertScrollBoxTThreadSynchronize(PositionY: Single;
                                                aVertScrollBox: TVertScrollBox);
begin
   TThread.Synchronize(nil,
   procedure
   begin
      try
         aVertScrollBox.ViewportPosition := PointF(aVertScrollBox.ViewportPosition.X, PositionY);
      except
      end;
   end);
end;

procedure ClearListViewTThreadSynchronize (NomeListView: TListView);
begin
   // SE USAR Items.Clear DEVE TER UM TThread.Synchronize
   TThread.Synchronize(nil,
      procedure
      begin
         try
            NomeListView.Items.Clear;
         except
         end;
      end);
end;

procedure ApagaFiltroListViewSearchBoxTThreadSynchronize(ListView: TListView);
begin
   TThread.Synchronize(nil,
      procedure
      var
        a: Integer;
        SearchBox: TSearchBox;
      begin
         try
            for a := 0 to ListView.Controls.Count-1 do
               begin
                  if ListView.Controls[a].ClassType = TSearchBox then
                     begin
                        SearchBox := TSearchBox(ListView.Controls[a]);
                        SearchBox.Text := '';
                        Break;
                      end;
               end;

            // SEMPRE USAR O ListView.Items.Filter := nil SE NÃO OCORRE UM ERRO DE MEMÓRIA
            ListView.Items.Filter := nil;
         except
         end;
      end);
end;

procedure ConfiguraWidthBordaDireita_ItemListView (NomeListView: TListView;
                                                   ItemIndex: Integer;
                                                   CampoListView: String;
                                                   WidthBordaDireita: Double);
var
   itemTextListView: TListItemText;
   itemImagemListView: TListItemImage;
begin
   try
      // SOLUÇÃO FANTÁSTICA PARA ACESSAR O ÍTEM NO ListView CUSTOMIZADO!!
      itemTextListView := NomeListView.items[ItemIndex].Objects.FindObjectT<TListItemText>(CampoListView{CampoListView});

      // SE ENCONTROU FAZ A MUDANÇA NO TEXTO, SENÃO, VERIFICA SE É UM CAMPO IMAGEM
      if Assigned(itemTextListView) then
         begin
            itemTextListView.Width := (NomeListView.Width - (itemTextListView.PlaceOffset.X+10))-WidthBordaDireita;
         end
      else
         begin
            // SOLUÇÃO FANTÁSTICA PARA ACESSAR O ÍTEM NO ListView CUSTOMIZADO!!
            itemImagemListView := NomeListView.items[ItemIndex].Objects.FindObjectT<TListItemImage>(CampoListView{CampoListView});

            if Assigned(itemImagemListView) then
               begin
                  itemImagemListView.Width := (NomeListView.Width - (itemImagemListView.PlaceOffset.X+10))-WidthBordaDireita;
               end;
         end;
   except
   end;
end;

end.
