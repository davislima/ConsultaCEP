unit Controller.ConsultarCEP;

interface

uses
  System.Classes,
  System.JSON,
  System.SysUtils,
  REST.Types,
  REST.Client,
  Model.Endereco,
  Controller.Records.API.CEP;

type
   TConsultarCEP = class

   private
      FEndereco: TEndereco;

      procedure SetEndereco(const Value: TEndereco);
      procedure ConsultarCEP(pAPICEP: TAPICEP; pEndereco: TEndereco);
      function TirarPontosTracosCEP(pCEP: String): String;
      function AdicionarTracoCEP(pCEP: String): String;
      function PopularAPICEP(pAPICEP: tpAPICEP; pCEP: String): TAPICEP;

   public
      constructor Create;
      destructor Destroy; override;

      property Endereco: TEndereco read FEndereco write SetEndereco;

      procedure ConsultarAPIsCEP(pCEP: String; pEndereco: TEndereco);
end;

implementation

{ TConsultarCEP }

constructor TConsultarCEP.Create;
begin
   FEndereco := TEndereco.Create;
end;

destructor TConsultarCEP.Destroy;
begin
  inherited;

  if Assigned(FEndereco) then FreeAndNil(FEndereco);
end;

procedure TConsultarCEP.SetEndereco(const Value: TEndereco);
begin
   FEndereco := Value;
end;

procedure TConsultarCEP.ConsultarCEP(pAPICEP: TAPICEP; pEndereco: TEndereco);
var
   JSONResponse:             TJSONObject;
   RESTClient_ConsultaCEP:   TRESTClient;
   RESTRequest_ConsultaCEP:  TRestRequest;
   RESTResponse_ConsultaCEP: TRESTResponse;
begin
   try
      try
         RESTResponse_ConsultaCEP         := TRESTResponse.Create (nil);
         RESTClient_ConsultaCEP           := TRESTClient.Create(pAPICEP.URL);
         RESTRequest_ConsultaCEP          := TRestRequest.Create(nil);
         RESTRequest_ConsultaCEP.Client   := RESTClient_ConsultaCEP;
         RESTRequest_ConsultaCEP.Response := RESTResponse_ConsultaCEP;
         RESTRequest_ConsultaCEP.Method   := rmGET;

         RESTRequest_ConsultaCEP.Params.Clear;
         RESTRequest_ConsultaCEP.Body.ClearBody;

         RESTRequest_ConsultaCEP.Execute;

         JSONResponse := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes (RESTResponse_ConsultaCEP.Content), 0) as TJSONObject;

         try
            if RESTResponse_ConsultaCEP.StatusCode = 200 then
            begin
               if JSONResponse.GetValue<String>('erro', EmptyStr) <> EmptyStr then
               begin
                  pEndereco.Status := 404;
                  exit;
               end;

               pEndereco.CEP      := JSONResponse.GetValue<String>(pAPICEP.CEP,      EmptyStr);
               pEndereco.Endereco := JSONResponse.GetValue<String>(pAPICEP.Endereco, EmptyStr);
               pEndereco.Bairro   := JSONResponse.GetValue<String>(pAPICEP.Bairro,   EmptyStr);
               pEndereco.Cidade   := JSONResponse.GetValue<String>(pAPICEP.Cidade,   EmptyStr);
               pEndereco.Estado   := JSONResponse.GetValue<String>(pAPICEP.Estado,   EmptyStr);
               pEndereco.Status   := 200;
            end
            else
               pEndereco.Status := 404;
         finally
            if Assigned(JSONResponse) then FreeAndNil(JSONResponse);
         end;
      except
         pEndereco.Status := 500;
      end;
   finally
      if Assigned(RESTClient_ConsultaCEP) then FreeAndNil(RESTClient_ConsultaCEP);
      if Assigned(RESTRequest_ConsultaCEP) then FreeAndNil(RESTRequest_ConsultaCEP);
      if Assigned(RESTResponse_ConsultaCEP) then FreeAndNil(RESTResponse_ConsultaCEP);
   end;
end;

procedure TConsultarCEP.ConsultarAPIsCEP(pCEP: String; pEndereco: TEndereco);
var
   i:       Integer;
   xAPICEP: TAPICEP;
begin
   for i := 0 to Ord(High(tpAPICEP)) do
   begin
      xAPICEP := PopularAPICEP(CodigoTotpAPICEP[Ord(i)], pCEP);

      ConsultarCEP(xAPICEP, pEndereco);

      if pEndereco.Status = 200 then
         Break;
   end;
end;

function TConsultarCEP.PopularAPICEP(pAPICEP: tpAPICEP; pCEP: String): TAPICEP;
var
   xCEP: String;
begin
   xCEP := TirarPontosTracosCEP(pCEP);

   case pAPICEP of
      tpBrasilAPI:
      begin
         Result.URL      := 'https://brasilapi.com.br/api/cep/v1/' + xCEP;
         Result.CEP      := 'cep';
         Result.Endereco := 'street';
         Result.Bairro   := 'neighborhood';
         Result.Cidade   := 'city';
         Result.Estado   := 'state';
      end;
      tpViaCEP:
      begin
         Result.URL      := 'https://viacep.com.br/ws/' + xCEP + '/json/';
         Result.CEP      := 'cep';
         Result.Endereco := 'logradouro';
         Result.Bairro   := 'bairro';
         Result.Cidade   := 'localidade';
         Result.Estado   := 'uf';
      end;
      tpApiCEPcom:
      begin
         Result.URL      := 'https://cdn.apicep.com/file/apicep/' + AdicionarTracoCEP(xCEP) + '.json';
         Result.CEP      := 'code';
         Result.Endereco := 'address';
         Result.Bairro   := 'district';
         Result.Cidade   := 'city';
         Result.Estado   := 'state';
      end;
   end;
end;

function TConsultarCEP.TirarPontosTracosCEP(pCEP: String): String;
begin
   Result := StringReplace(pCEP,   '.', '', [rfReplaceAll]);
   Result := StringReplace(Result, '-', '', [rfReplaceAll]);
end;

function TConsultarCEP.AdicionarTracoCEP(pCEP: String): String;
begin
   Result := Copy(pCEP, 1, 5) + '-' + Copy(pCEP, 6, 3);
end;

end.
