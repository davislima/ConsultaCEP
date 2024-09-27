unit Model.Endereco;

interface

uses
   System.SysUtils,
   System.DateUtils,
   System.Generics.Collections;

type
   TEndereco = class

   private
      FCEP:      String;
      FEndereco: String;
      FBairro:   String;
      FCidade:   String;
      FEstado:   String;
      FStatus:   Integer;

      procedure SetCEP(const Value: String);
      procedure SetEndereco(const Value: String);
      procedure SetBairro(const Value: String);
      procedure SetCidade(const Value: String);
      procedure SetEstado(const Value: String);
      procedure SetStatus(const Value: Integer);

   public
      constructor Create;
      destructor Destroy; override;

      property CEP:      String  read FCEP      write SetCEP;
      property Endereco: String  read FEndereco write SetEndereco;
      property Bairro:   String  read FBairro   write SetBairro;
      property Cidade:   String  read FCidade   write SetCidade;
      property Estado:   String  read FEstado   write SetEstado;
      property Status:   INteger read FStatus   write SetStatus;

end;

implementation

constructor TEndereco.Create;
begin

end;

destructor TEndereco.Destroy;
begin
  inherited;

end;

procedure TEndereco.SetCEP(const Value: String);
begin
   FCEP := Value;
end;

procedure TEndereco.SetEndereco(const Value: String);
begin
   FEndereco := Value;
end;

procedure TEndereco.SetBairro(const Value: String);
begin
   FBairro := Value;
end;

procedure TEndereco.SetCidade(const Value: String);
begin
   FCidade := Value;
end;

procedure TEndereco.SetEstado(const Value: String);
begin
   FEstado := Value;
end;

procedure TEndereco.SetStatus(const Value: Integer);
begin
   FStatus := Value;
end;

end.

