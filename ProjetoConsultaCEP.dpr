program ProjetoConsultaCEP;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Principal.ConsultaCEP in 'MVC\View\View.Principal.ConsultaCEP.pas' {frmPrincipal},
  View.Frame.PopUpDialogBox in 'MVC\View\View.Frame.PopUpDialogBox.pas' {frameTelaPopUpDialogBox: TFrame},
  Controller.Ferramentas.Format in 'MVC\Controller\Controller.Ferramentas.Format.pas',
  Model.Endereco in 'MVC\Model\Model.Endereco.pas',
  Controller.ConsultarCEP in 'MVC\Controller\Controller.ConsultarCEP.pas',
  Controller.Ferramentas.AparenciaAPP in 'MVC\Controller\Controller.Ferramentas.AparenciaAPP.pas',
  Controller.Ferramentas.Objects.Synchronize in 'MVC\Controller\Controller.Ferramentas.Objects.Synchronize.pas',
  Controller.Records.API.CEP in 'MVC\Controller\Controller.Records.API.CEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
