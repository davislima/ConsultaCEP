unit Controller.Records.API.CEP;

interface

type
   tpAPICEP = (tpBrasilAPI, tpViaCEP, tpApiCEPcom);

   TAPICEP = record
      URL,
      CEP,
      Endereco,
      Bairro,
      Cidade,
      Estado: String;
   end;

var CodigoTotpAPICEP: Array[0..Ord(High(tpAPICEP))] of tpAPICEP = (tpBrasilAPI, tpViaCEP, tpApiCEPcom);

implementation

end.
