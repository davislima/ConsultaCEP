unit Controller.Frame.PopUpDialogBox;

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
   FMX.Layouts,
   View.Frame.PopUpDialogBox;

type
   TExecutarProcedure = procedure of object;

   TPopUpDialogBox = class
   private
      class procedure RotinaNaoExecutaNadaPopUpDialogBox;

   public
      class var xFrameTelaPopUpDialogBox: TframeTelaPopUpDialogBox;
      class procedure MensagemAviso(aMensagem: String; aParent: TForm);
      class procedure PerguntaComOpcoes(aMensagemDialogBox,
                                        aMensagem00,
                                        aMensagem01,
                                        aMensagem02,
                                        aMensagem03,
                                        aMensagem04,
                                        aMensagem05,
                                        aMensagem06: String;
                                        aExecutarRotina00,
                                        aExecutarRotina01,
                                        aExecutarRotina02,
                                        aExecutarRotina03,
                                        aExecutarRotina04,
                                        aExecutarRotina05,
                                        aExecutarRotina06: TExecutarProcedure;
                                        aParent: TForm);

end;

implementation

uses
   Controller.Ferramentas.Strings;

class procedure TPopUpDialogBox.PerguntaComOpcoes(aMensagemDialogBox,
                                                  aMensagem00,
                                                  aMensagem01,
                                                  aMensagem02,
                                                  aMensagem03,
                                                  aMensagem04,
                                                  aMensagem05,
                                                  aMensagem06: String;
                                                  aExecutarRotina00,
                                                  aExecutarRotina01,
                                                  aExecutarRotina02,
                                                  aExecutarRotina03,
                                                  aExecutarRotina04,
                                                  aExecutarRotina05,
                                                  aExecutarRotina06: TExecutarProcedure;
                                                  aParent: TForm);
begin
   TThread.Synchronize(nil,
   procedure
   var
      arrayPopUpDialogBox: TArray<String>;
   begin
      try
         if not Assigned(xFrameTelaPopUpDialogBox) then
         begin
            xFrameTelaPopUpDialogBox        := TframeTelaPopUpDialogBox.Create(aParent);
            xFrameTelaPopUpDialogBox.Parent := TFMXObject(aParent);
            xFrameTelaPopUpDialogBox.Align  := TAlignLayout.Contents;
            xFrameTelaPopUpDialogBox.Name   := 'frameTelaPopUpDialogBox' + VoltaChaveUnicaBaseadaNaDataHoje;
         end;

         // APAGAR QUALQUER ELEMENTO QUE ESTEJA NA MATRIZ
         arrayPopUpDialogBox           := nil;
         arrayPopUpDialogBoxProcedures := nil;

         // INFORMO A DIMENSÃO DO array COM O TOTAL DE OPÇÕES DO MENU
         SetLength(arrayPopUpDialogBox, 07); {TArray<String>}
         SetLength(arrayPopUpDialogBoxProcedures, 07); {Array of Procedure of object}

         // INFORMO AS OPÇÕES DO MENU
         arrayPopUpDialogBox[0] := aMensagem00;
         arrayPopUpDialogBox[1] := aMensagem01;
         arrayPopUpDialogBox[2] := aMensagem02;
         arrayPopUpDialogBox[3] := aMensagem03;
         arrayPopUpDialogBox[4] := aMensagem04;
         arrayPopUpDialogBox[5] := aMensagem05;
         arrayPopUpDialogBox[6] := aMensagem06;

         // INFORMO AS ROTINAS QUE SERÃO EXECUTADAS EM CADA ListBoxItem
         arrayPopUpDialogBoxProcedures[0] := aExecutarRotina00;
         arrayPopUpDialogBoxProcedures[1] := aExecutarRotina01;
         arrayPopUpDialogBoxProcedures[2] := aExecutarRotina02;
         arrayPopUpDialogBoxProcedures[3] := aExecutarRotina03;
         arrayPopUpDialogBoxProcedures[4] := aExecutarRotina04;
         arrayPopUpDialogBoxProcedures[5] := aExecutarRotina05;
         arrayPopUpDialogBoxProcedures[6] := aExecutarRotina06;

         // ADICIONA OS ÍTENS AO MENU E EXECUTA A TELA PopUpDialogBox
         xFrameTelaPopUpDialogBox.ExecutarTelaPopUpDialogBox(arrayPopUpDialogBox,
                                                             aMensagemDialogBox,
                                                             aParent);
      except
      end;
   end);
end;

class procedure TPopUpDialogBox.RotinaNaoExecutaNadaPopUpDialogBox;
begin
   // NÃO EXECUTA NADA, POIS É QUANDO A OPÇÃO NÃO TEM NADA A EXECUTAR, ÓBVIO, KKKKK
end;

class procedure TPopUpDialogBox.MensagemAviso(aMensagem: String; aParent: TForm);
begin
   // EXECUTA O PopUpDialogBox COM AS OPÇÕES DO MENU
   TPopUpDialogBox.PerguntaComOpcoes(aMensagem,
                                     EmptyStr,
                                     EmptyStr,
                                     EmptyStr,
                                     EmptyStr,
                                     EmptyStr,
                                     EmptyStr,
                                     EmptyStr,
                                     RotinaNaoExecutaNadaPopUpDialogBox,
                                     RotinaNaoExecutaNadaPopUpDialogBox,
                                     RotinaNaoExecutaNadaPopUpDialogBox,
                                     RotinaNaoExecutaNadaPopUpDialogBox,
                                     RotinaNaoExecutaNadaPopUpDialogBox,
                                     RotinaNaoExecutaNadaPopUpDialogBox,
                                     RotinaNaoExecutaNadaPopUpDialogBox,
                                     aParent);
end;

end.

