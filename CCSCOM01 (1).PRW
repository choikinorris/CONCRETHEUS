#include 'protheus.ch'
#include 'totvs.ch'
#include 'topconn.ch'
/*
+---------------------------------------------------------------------------------------+
|Programa:CCSCOM01   |Autor:Luis Henrique Robusto                     |Data: 25/10/2004 |
+---------------------------------------------------------------------------------------+
|Desc.:  Impressใo do Pedido de Comprsa Grแfico    	            						|
|                                                                                       |
|                                                                                       |
+---------------------------------------------------------------------------------------+
|Uso: Modulo Compras  					           										|
+---------------------------------------------------------------------------------------+
|Alteracoes:						                                                    |
|Data    |Responsavel |Motivo		                                                    |
|26/08/21|Odair Arruda| Altera็ใo p/ tambem imprimir automaticamente na inclusใo do PC  |
+---------------------------------------------------------------------------------------+
*/
*****************************************************************************************
User Function CCSCOM01(cNPC)   // EM MODO PAISAGEM  //
	*****************************************************************************************
	Private	cNumPed  		// Pedido de Compras
	Private	lImpPrc			// Imprime os Precos ?
	Private	nTitulo 		// Titulo do Relatorio ?
	Private	cObserv1		// 1a Linha de Observacoes
	Private	cObserv2		// 2a Linha de Observacoes
	Private	cObserv3		// 3a Linha de Observacoes
	Private	cObserv4		// 4a Linha de Observacoes
	Private	lPrintCodFor	// (mv_par08==1)	// Imprime o Codigo do produto no fornecedor ?
	Private cPar09      	// (mv_par09==1)
	Private cPar10
	Private cPar11

	Private	lEnd	:= .f.,;
		aAreaSC7	:= SC7->(GetArea()),;
		aAreaSA2	:= SA2->(GetArea()),;
		aAreaSA5	:= SA5->(GetArea()),;
		aAreaSF4	:= SF4->(GetArea()),;
		cPerg		:= PADR('CCSCOM01',10)
	//	aAreaSZF	:= SZF->(GetArea()),;


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta os parametros.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	IF Empty(cNPC)

		AjustaSX1(cPerg)

		If	( ! Pergunte(cPerg,.T.) )
			Return
		Else
			cNumPed  	:= mv_par01			// Numero do Pedido de Compras
			lImpPrc		:= (mv_par02==2)	// Imprime os Precos ?
			nTitulo 	:= mv_par03			// Titulo do Relatorio ?
			cObserv1	:= mv_par04			// 1a Linha de Observacoes
			cObserv2	:= mv_par05			// 2a Linha de Observacoes
			cObserv3	:= mv_par06			// 3a Linha de Observacoes
			cObserv4	:= mv_par07			// 4a Linha de Observacoes
			lPrintCodFor:= 1 //(mv_par08==1)// Imprime o Codigo do produto no fornecedor ?
			cPar09      := 1 //(mv_par09==1)
			cPar10      := mv_par10
			cPar11      := mv_par11
		EndIf
	Else
		cNumPed  	:= cNPC 						// Numero do Pedido de Compras
		lImpPrc		:= 1            				// Imprime os Precos ?
		nTitulo 	:= 1							// Titulo do Relatorio ?
		cObserv1	:= "Pedido de Compras Grafico"	// 1a Linha de Observacoes
		cObserv2	:= " "							// 2a Linha de Observacoes
		cObserv3	:= " "							// 3a Linha de Observacoes
		cObserv4	:= " "							// 4a Linha de Observacoes
		lPrintCodFor:= 1							// Imprime o Codigo do produto no fornecedor ?
		cPar09      := 1
		cPar10      := Space(6)
		cPar11      := Space(4)
	EndIf

	DbSelectArea('SC7')
	SC7->(DbSetOrder(1))
	If	( ! SC7->(DbSeek(xFilial('SC7') + cNumPed)) )
		Help('',1,'CCSCOM01',,OemToAnsi('Pedido nใo encontrado.'),1)
		Return .f.
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a rotina de impressao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a area anterior ao processamento. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	RestArea(aAreaSC7)
	RestArea(aAreaSA2)
	RestArea(aAreaSA5)
//	RestArea(aAreaSZF)
	RestArea(aAreaSF4)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณLuis Henrique Robustoบ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a Duplicata...                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRel()
	Local cCCusto := ''
	Local nComp   := 1
	//Private cFileLogo 	:= "\system\lgrl01_MMT.bmp",; //FisxLogo("1")
	Private cFileLogo 	:= "\system\lgrl01_MMT.bmp"
	Private	oPrint	:= TMSPrinter():New(OemToAnsi('Pedido de Compras')),;
		oBrush		:= TBrush():New(,4),;
		oPen		:= TPen():New(0,5,CLR_BLACK),;
		oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
		oFont12		:= TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
		oFont12n	:= TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.),;
		oFont13		:= TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
		oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
		oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
		oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
		oFont16		:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
		oFont20		:= TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
		oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

	Private	lFlag	:= .t.,;	// Controla a impressao do fornecedor
	nLinha			:= 3000,;	// Controla a linha por extenso
	nLinFim			:= 0,;		// Linha final para montar a caixa dos itens
	lPrintDesTab	:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)
	cRepres			:= Space(80)

	Private	_nQtdReg := 0,;		// Numero de registros para intruir a regua
	_nValMerc 		 := 0,;		// Valor das mercadorias
	_nValIPI		 := 0,;		// Valor do I.P.I.
	_nValDesc		 := 0,;		// Valor de Desconto
	_nTotAcr		 := 0,;		// Valor total de acrescimo
	_nTotSeg		 := 0,;		// Valor de Seguro
	_nTotFre	     := 0,;		// Valor de Frete
	_nTotIcmsRet	 := 0		// Valor do ICMS Retido

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona nos arquivos necessarios. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea('SA2')
	SA2->(DbSetOrder(1))
	If	! SA2->(DbSeek(xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA)))
		Help('',1,'REGNOIS')
		Return .f.
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//oPrint:SetPortrait()                  
	oPrint:SetLandScape()
	oPrint:SetPaperSize(9)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta query !ณ    //SC7.C7_CODPRF,
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cSELECT :=	'SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, '+;
		'SC7.C7_ITEM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_QUANT, '+;
		'SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA, '+;
		'SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_ICMSRET, SC7.C7_COND,'+;
		'C7_UM,C7_USER,C7_DATPRF,C7_CC,C7_RATEIO, C7_XGARANT '

	cFROM   :=	RetSqlName('SC7') + ' SC7 '

	cWHERE  :=	'SC7.D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
		'SC7.C7_FILIAL  =    '+CHR(39) + xFilial('SC7') +CHR(39) + ' AND '+;
		'SC7.C7_NUM     =    '+CHR(39) + cNumPed        +CHR(39) + ' AND '
	cWHERE  +=	" SC7.C7_CONAPRO = 'L' "
	cORDER  :=	'SC7.C7_FILIAL, SC7.C7_ITEM '

	cQuery  :=	' SELECT '   + cSELECT + ;
		' FROM '     + cFROM   + ;
		' WHERE '    + cWHERE  + ;
		' ORDER BY ' + cORDER

	TCQUERY cQuery NEW ALIAS 'TRA'

	If	! USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf
	If cPar09 == 1
		//oPrint	:= TMSPrinter():New(OemToAnsi('Pedido de Compras para Faturamento Direto'))
		oPrint	:= TMSPrinter():New(OemToAnsi('Pedido de Compras'))
	Endif
	DbSelectArea('TRA')
	Count to _nQtdReg
	ProcRegua(_nQtdReg)
	TRA->(DbGoTop())

	While 	TRA->( ! Eof() )

		xVerPag()

		If	( lFlag )
			//ฺฤฤฤฤฤฤฤฤฤฤฟ
			//ณFornecedorณ
			//ภฤฤฤฤฤฤฤฤฤฤู
			oPrint:Say(0530,0100,OemToAnsi('Fornecedor:'),oFont10)
			oPrint:Say(0520,0430,AllTrim(substr(SA2->A2_NOME,1,30)) + '  ('+AllTrim(SA2->A2_COD)+'/'+AllTrim(SA2->A2_LOJA)+')',oFont13)
			oPrint:Say(0580,0100,OemToAnsi('Endere็o:'),oFont10)
			oPrint:Say(0580,0430,SA2->A2_END,oFont11)
			oPrint:Say(0630,0100,OemToAnsi('Municํpio/U.F.:'),oFont10)
			oPrint:Say(0630,0430,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
			oPrint:Say(0630,1200,OemToAnsi('Cep:'),oFont10)
			oPrint:Say(0630,1370,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
			oPrint:Say(0680,0100,OemToAnsi('Telefone:'),oFont10)
			oPrint:Say(0680,0430,SA2->A2_TEL,oFont11)
			oPrint:Say(0680,1200,OemToAnsi('Fax:'),oFont10)
			oPrint:Say(0680,1370,SA2->A2_FAX,oFont11)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณNumero/Emissaoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//oPrint:Box(0530,1900,0730,2300)
			//oPrint:FillRect({0530,1900,0730,2300},oBrush)
			oPrint:Say(0535,1960,OemToAnsi('Filial / Numero Pedido'),oFont08)
			oPrint:Say(0570,2000,SC7->C7_FILIAL+"/"+SC7->C7_NUM,oFont18)
			oPrint:Say(0650,2000,Dtoc(SC7->C7_EMISSAO),oFont12)
			lFlag := .f.
		EndIf

		If	( lPrintDesTab )
			nCol := 250   // Espacamento para aumentar o tamanhda coluna descri็ใo.

			// Linha superior dos titulos - ITENS //
			//oPrint:Line(nLinha,0100,nLinha,2820+nCol)
			oPrint:Line(nLinha,0100,nLinha,3120+nCol)

			// Colunas entre os titulos - ITENS //
			oPrint:Line(nLinha,0100,nLinha+70,100)
			oPrint:Line(nLinha,0290,nLinha+70,290)
			oPrint:Line(nLinha,0640,nLinha+70,640)
			oPrint:Line(nLinha,1390+nCol,nLinha+70,1390+nCol)
			oPrint:Line(nLinha,1590+nCol,nLinha+70,1590+nCol)
			oPrint:Line(nLinha,1840+nCol,nLinha+70,1840+nCol)
			oPrint:Line(nLinha,2040+nCol,nLinha+70,2040+nCol)
			oPrint:Line(nLinha,2300+nCol,nLinha+70,2300+nCol)
			oPrint:Line(nLinha,2560+nCol,nLinha+70,2560+nCol)
			oPrint:Line(nLinha,2820+nCol,nLinha+70,2820+nCol)
			oPrint:Line(nLinha,3120+nCol,nLinha+70,3120+nCol)

			// Linha de titulos - ITENS //
			oPrint:Say(nLinha,0120,OemToAnsi('Item'),oFont12)
			oPrint:Say(nLinha,0300,OemToAnsi('C๓digo'),oFont12)
			oPrint:Say(nLinha,0650,OemToAnsi('Descri็ใo'),oFont12)
			oPrint:Say(nLinha,1400+nCol,OemToAnsi('Qtde'),oFont12)
			oPrint:Say(nLinha,1620+nCol,OemToAnsi('Vlr.Unit.'),oFont12)
			oPrint:Say(nLinha,1850+nCol,OemToAnsi('IPI (%)'),oFont12)
			oPrint:Say(nLinha,2050+nCol,OemToAnsi('Valor Total'),oFont12)
			oPrint:Say(nLinha,2320+nCol,OemToAnsi('Data Entr.'),oFont12)
			oPrint:Say(nLinha,2600+nCol,OemToAnsi('CC'),oFont12)
			oPrint:Say(nLinha,2920+nCol,OemToAnsi('Garantia'),oFont12)
			lPrintDesTab := .f.
			nLinha += 70
			// Linha inferior dos titulos - ITENS
			oPrint:Line(nLinha,100,nLinha,3120+nCol)
		EndIf

		// Barra coluna do Titulo do Item //
		oPrint:Line(nLinha,100,nLinha+60,100)
		oPrint:Line(nLinha,290,nLinha+60,290)
		oPrint:Line(nLinha,640,nLinha+60,640)
		oPrint:Line(nLinha,1390+nCol,nLinha+60,1390+nCol)
		oPrint:Line(nLinha,1590+nCol,nLinha+60,1590+nCol)
		oPrint:Line(nLinha,1840+nCol,nLinha+60,1840+nCol)
		oPrint:Line(nLinha,2040+nCol,nLinha+60,2040+nCol)
		oPrint:Line(nLinha,2300+nCol,nLinha+60,2300+nCol)
		oPrint:Line(nLinha,2560+nCol,nLinha+60,2560+nCol)
		oPrint:Line(nLinha,2820+nCol,nLinha+60,2820+nCol)
		oPrint:Line(nLinha,3120+nCol,nLinha+60,3120+nCol)

		xVerPag()

		//// **** INCLUSรO COLUNA GARANTIA DO PRODUTO ****   ////
		//// ****    POR SANDRO ALBUQUERQUE - EM: 14/03/2023 ****     ////
		cGarantia := ''
		If Empty(TRA->C7_XGARANT)
			cGarantia := ""

		ElseIf Alltrim(TRA->C7_XGARANT ) = '1'
			cGarantia += "1 M๊s"

		ElseIf Alltrim(TRA->C7_XGARANT ) = '2'
			cGarantia += "2 Meses"

		ElseIf Alltrim(TRA->C7_XGARANT ) = '3'
			cGarantia += "3 Meses"

		ElseIf Alltrim(TRA->C7_XGARANT ) = '6'
			cGarantia += "6 Meses"

		ElseIf Alltrim(TRA->C7_XGARANT ) = '7'
			cGarantia += "1 Ano"

		ElseIf Alltrim(TRA->C7_XGARANT ) = '8'
			cGarantia += "2 Anos"

		ElseIf Alltrim(TRA->C7_XGARANT ) = '9'
			cGarantia += "5 Anos"

		ElseIf Alltrim(upper(TRA->C7_XGARANT)) = 'X'
			cGarantia += "Nใo Aplica"

		EndIF
		/// *** ATE AQUI *** ///

		oPrint:Say(nLinha,0120,TRA->C7_ITEM,oFont12n)
		If	( lPrintCodFor )
			DbSelectArea('SA5')
			SA5->(DbSetOrder(1))
			If	SA5->(DbSeek(xFilial('SA5') + SA2->A2_COD + SA2->A2_LOJA + TRA->C7_PRODUTO)) .and. ( ! Empty(SA5->A5_CODPRF) )
				oPrint:Say(nLinha,0300,SA5->A5_CODPRF,oFont12n)
			Else
				oPrint:Say(nLinha,0300,TRA->C7_PRODUTO,oFont12n)
			EndIf
		Else
			oPrint:Say(nLinha,0300,TRA->C7_PRODUTO,oFont12n)
		EndIf
		If	SB5->(DbSeek(xFilial("SB5")+TRA->C7_PRODUTO))
			//aDescricao := U_TrataMemo(AllTrim(SB5->B5_CEME)+" - "+TRA->C7_UM,30)
			aDescricao := U_TrataMemo(AllTrim(SB5->B5_CEME)+" - "+TRA->C7_UM,80)
		Else
			//aDescricao := U_TrataMemo(alltrim(TRA->C7_DESCRI)+" - "+TRA->C7_UM,30)
			aDescricao := U_TrataMemo(alltrim(TRA->C7_DESCRI)+" - "+TRA->C7_UM,80)
		Endif
		//oPrint:Say(nLinha,0650,ALLTRIM(aDescricao[1,1]),oFont12n)
		oPrint:Say(nLinha,0650,ALLTRIM(aDescricao[1,1]),oFont10n)
		oPrint:Say(nLinha,1560+nCol,AllTrim(TransForm(TRA->C7_QUANT,'@E 99,999.99')),oFont12n,,,,1)
		If	( lImpPrc )
			cCCusto := ''
			oPrint:Say(nLinha,1805+nCol,AllTrim(TransForm(TRA->C7_PRECO,'@R 999,999.9999')),oFont12n,,,,1)
			oPrint:Say(nLinha,2005+nCol,AllTrim(TransForm(TRA->C7_IPI,'@R 999,999.99')),oFont12n,,,,1)
			oPrint:Say(nLinha,2260+nCol,AllTrim(TransForm(TRA->C7_TOTAL,'@R 999,999.99')),oFont12n,,,,1)
			oPrint:Say(nLinha,2515+nCol,Dtoc(STOD(TRA->C7_DATPRF)),oFont12n,,,,1)
			//************************ TRATAMENTO INICIAL IMPRESSAO DO RATEIO ************************//
			IF TRA->C7_RATEIO <> '1' 	// Diferente de 1=Sim  /  2=Nao
				cCCusto := Alltrim(TRA->C7_CC)
			Else
				// (SCH) - INDICE 1 = CH_FILIAL+CH_PEDIDO+CH_FORNECE+CH_LOJA+CH_ITEMPD+CH_ITEM
				IF SCH->(DbSeek(xFilial("SCH")+TRA->C7_NUM+TRA->C7_FORNECE+TRA->C7_LOJA+TRA->C7_ITEM))
					IF INT(SCH->CH_PERC) == 100
						cCCusto := Alltrim(SCH->CH_CC)		// Se for 100% o rateio pega a classe de valor
					Else
						cCCusto := '**'   				// Item com rateio para mais de uma unidade
					EndIf
				EndIf
			EndIf
			oPrint:Say(nLinha,2730+nCol,Alltrim(cCCusto),oFont12n,,,,1)
		EndIf
		oPrint:Say(nLinha,3050+nCol,Alltrim(cGarantia),oFont12n,,,,1)
		//************************ POR SANDRO ALBUQUERQUE  ************************//
		nLinha += 60
		oPrint:Line(nLinha,100,nLinha,3120+nCol)
		If len(aDescricao) > 1
			For nComp := 2 to len(aDescricao)
				xVerPag()
				If len(aDescricao) >= nComp
					oPrint:Say(nLinha,0650,AllTrim(aDescricao[nComp][1]),oFont11)
				Endif
				oPrint:Line(nLinha,0100,nLinha+60,0100)
				oPrint:Line(nLinha,0640,nLinha+60,0640)
				oPrint:Line(nLinha,1390+nCol,nLinha+60,1390+nCol)
				oPrint:Line(nLinha,2300+nCol,nLinha+60,2300+nCol)
				oPrint:Line(nLinha,2560+nCol,nLinha+60,2560+nCol)
				oPrint:Line(nLinha,2820+nCol,nLinha+60,2820+nCol)
				oPrint:Line(nLinha,3120+nCol,nLinha+60,3120+nCol)
				nLinha += 60
				oPrint:Line(nLinha,0100,nLinha,3120+nCol)
			Next nComp
		Else
			nLinha += 60
		EndIf

		// Linha acima dos Totais
		oPrint:Line(nLinha,0100,nLinha,3120+nCol)

		_nValMerc 		+= TRA->C7_TOTAL
		_nValIPI		+= (TRA->C7_TOTAL * TRA->C7_IPI) / 100
		_nValDesc		+= TRA->C7_VLDESC
		_nTotAcr		+= TRA->C7_DESPESA
		_nTotSeg		+= TRA->C7_SEGURO
		_nTotFre		+= TRA->C7_VALFRE
		If	( Empty(TRA->C7_TES) )
			_nTotIcmsRet	+= TRA->C7_ICMSRET
		Else
			DbSelectArea('SF4')
			SF4->(DbSetOrder(1))
			If	SF4->(DbSeek(xFilial('SF4') + TRA->C7_TES))
				If	( AllTrim(SF4->F4_INCSOL) == 'S' )
					_nTotIcmsRet	+= TRA->C7_ICMSRET
				EndIf
			EndIf
		EndIf
		xVerPag()
		IncProc()
		TRA->(DbSkip())
		xVerPag()
	EndDo
	TRA->(DbGotop())
	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE MERCADORIASณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( lImpPrc )
		oPrint:Line(nLinha,1390+nCol,nLinha+80,1390+nCol)
		oPrint:Line(nLinha,1840+nCol,nLinha+80,1840+nCol)
		oPrint:Line(nLinha,2300+nCol,nLinha+80,2300+nCol)
		oPrint:Say(nLinha+10,1420+nCol,'Valor Mercadorias ',oFont12)
		oPrint:Say(nLinha+10,1985+nCol,TransForm(_nValMerc,'@R 9,999,999.99'),oFont13)
		nLinha += 80
		oPrint:Line(nLinha,1390+nCol,nLinha,2300+nCol)
	EndIf

	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE I.P.I. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( lImpPrc ) .and. ( _nValIpi > 0 )
		oPrint:Line(nLinha,1390+nCol,nLinha+80,1390+nCol)
		oPrint:Line(nLinha,1840+nCol,nLinha+80,1840+nCol)
		oPrint:Line(nLinha,2300+nCol,nLinha+80,2300+nCol)
		oPrint:Say(nLinha+10,1420+nCol,'Valor I.P.I. (+)',oFont12)
		oPrint:Say(nLinha+10,2000+nCol,TransForm(_nValIpi,'@R 9,999,999.99'),oFont13)
		nLinha += 80
		oPrint:Line(nLinha,1390+nCol,nLinha,2300+nCol)
	EndIf

	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE DESCONTOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( lImpPrc ) .and. ( _nValDesc > 0 )
		oPrint:Line(nLinha,1390+nCol,nLinha+80,1390+nCol)
		oPrint:Line(nLinha,1840+nCol,nLinha+80,1840+nCol)
		oPrint:Line(nLinha,2300+nCol,nLinha+80,2300+nCol)
		oPrint:Say(nLinha+10,1420+nCol,'Valor Desconto (-)',oFont12)
		oPrint:Say(nLinha+10,2000+nCol,TransForm(_nValDesc,'@R 9,999,999.99'),oFont13)
		nLinha += 80
		oPrint:Line(nLinha,1390+nCol,nLinha,2300+nCol)
	EndIf

	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE ACRESCIMO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( lImpPrc ) .and. ( _nTotAcr > 0 )
		oPrint:Line(nLinha,1390+nCol,nLinha+80,1390+nCol)
		oPrint:Line(nLinha,1840+nCol,nLinha+80,1840+nCol)
		oPrint:Line(nLinha,2300+nCol,nLinha+80,2300+nCol)
		oPrint:Say(nLinha+10,1420+nCol,'Valor Acresc. (+)',oFont12)
		oPrint:Say(nLinha+10,2000+nCol,TransForm(_nTotAcr,'@R 9,999,999.99'),oFont13)
		nLinha += 80
		oPrint:Line(nLinha,1390+nCol,nLinha,2300+nCol)
	EndIf

	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE SEGURO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( lImpPrc ) .and. ( _nTotSeg > 0 )
		oPrint:Line(nLinha,1390+nCol,nLinha+80,1390+nCol)
		oPrint:Line(nLinha,1840+nCol,nLinha+80,1840+nCol)
		oPrint:Line(nLinha,2300+nCol,nLinha+80,2300+nCol)
		oPrint:Say(nLinha+10,1420+nCol,'Valor Seguro (+)',oFont12)
		oPrint:Say(nLinha+10,2000+nCol,TransForm(_nTotSeg,'@R 9,999,999.99'),oFont13)
		nLinha += 80
		oPrint:Line(nLinha,1390+nCol,nLinha,2300+nCol)
	EndIf

	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE FRETE ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( lImpPrc ) .and. ( _nTotFre > 0 )
		oPrint:Line(nLinha,1390+nCol,nLinha+80,1390+nCol)
		oPrint:Line(nLinha,1840+nCol,nLinha+80,1840+nCol)
		oPrint:Line(nLinha,2300+nCol,nLinha+80,2300+nCol)
		oPrint:Say(nLinha+10,1420+nCol,'Valor Frete (+)',oFont12)
		oPrint:Say(nLinha+10,2000+nCol,TransForm(_nTotFre,'@R 9,999,999.99'),oFont13)
		nLinha += 80
		oPrint:Line(nLinha,1390+nCol,nLinha,2560+nCol)
	EndIf

	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime ICMS RETIDO    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( lImpPrc ) .and. ( _nTotIcmsRet > 0 )
		oPrint:Line(nLinha,1390+nCol,nLinha+80,1390+nCol)
		oPrint:Line(nLinha,1840+nCol,nLinha+80,1840+nCol)
		oPrint:Line(nLinha,2300+nCol,nLinha+80,2300+nCol)
		oPrint:Say(nLinha+10,1420+nCol,'Valor ICMS Retido',oFont12)
		oPrint:Say(nLinha+10,2000+nCol,TransForm(_nTotIcmsRet,'@R 9,999,999.99'),oFont13)
		nLinha += 80
		oPrint:Line(nLinha,1390+nCol,nLinha,2300+nCol)
	EndIf

	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o VALOR TOTAL !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//oPrint:FillRect({nLinha,1390,nLinha+80,2300},oBrush)
	oPrint:Line(nLinha,1390+nCol,nLinha+80,1390+nCol)
	oPrint:Line(nLinha,1840+nCol,nLinha+80,1840+nCol)
	oPrint:Line(nLinha,2300+nCol,nLinha+80,2300+nCol)
	oPrint:Say(nLinha+10,1420+nCol,'VALOR TOTAL       ',oFont12)
	If	( lImpPrc )
		oPrint:Say(nLinha+10,1950+nCol,TransForm(_nValMerc + _nValIPI - _nValDesc + _nTotAcr	+ _nTotSeg + _nTotFre + _nTotIcmsRet,'@R 9,999,999.99'),oFont14)
	EndIf
	nLinha += 80
	xVerPag()
	oPrint:Line(nLinha,1390+nCol,nLinha,2300+nCol)
	nLinha += 70

	xVerPag()
	If cPar09 == 1
		/*
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+cPAR10+cPAR11)
		oPrint:Say(nLinha,0100,OemToAnsi('Faturamento/Responsavel pelo Pagamento:'),oFont10)
		oPrint:Say(nLinha,0800,AllTrim(SA1->A1_NOME),oFont13)
		nLinha += 60
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ:'),oFont10)
		oPrint:Say(nLinha,0800,SA1->A1_CGC,oFont11)
		nLinha += 60
		oPrint:Say(nLinha,0100,OemToAnsi('INSC. EST.:'),oFont10)
		oPrint:Say(nLinha,0800,AllTrim(SA1->A1_INSCR),oFont11)
		nLinha += 60
		oPrint:Say(nLinha,0100,OemToAnsi('End. Faturamento:'),oFont10)
		oPrint:Say(nLinha,0800,ALLTRIM(SA1->A1_END)+" - "+ALLTRIM(SA1->A1_BAIRRO)+" - "+ALLTRIM(SA1->A1_MUN)+" - "+ALLTRIM(SA1->A1_EST)+" - CEP:"+ALLTRIM(SA1->A1_CEP),oFont11)
		nLinha += 60
		oPrint:Say(nLinha,0100,OemToAnsi('End. de Cobranca:'),oFont10)
		oPrint:Say(nLinha,0800,ALLTRIM(SA1->A1_ENDCOB)+" - "+ALLTRIM(SA1->A1_X_COMPC)+" - "+ALLTRIM(SA1->A1_BAIRROC)+" - "+ALLTRIM(SA1->A1_MUNC)+" - "+ALLTRIM(SA1->A1_ESTC)+" - CEP:"+ALLTRIM(SA1->A1_CEPC),oFont11)
		nLinha += 60
		oPrint:Say(nLinha,0100,OemToAnsi('Telefone:'),oFont10)
		oPrint:Say(nLinha,0800,ALLTRIM(SA1->A1_DDD)+" - "+ALLTRIM(SA1->A1_TEL),oFont11)
		nLinha += 60
		oPrint:Say(nLinha,0100,OemToAnsi('Email:'),oFont10)
		oPrint:Say(nLinha,0800,ALLTRIM(SA1->A1_EMAIL),oFont11)
		nLinha += 60
		oPrint:Say(nLinha,0100,OemToAnsi('End. de Entrega:'),oFont10)
		oPrint:Say(nLinha,0800,ALLTRIM(SA1->A1_ENDENT)+" - "+ALLTRIM(SA1->A1_BAIRROE)+" - "+ALLTRIM(SA1->A1_X_MUNE)+" - "+ALLTRIM(SA1->A1_X_UFE)+" - CEP:"+ALLTRIM(SA1->A1_X_CEPE),oFont11)
		nLinha += 80
		*/
	EndIf
	xVerPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime as observacoes dos parametros. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLinha += 80
	oPrint:Say(nLinha,0100,OemToAnsi('Observa็๕es:'),oFont12)
	oPrint:Say(nLinha,0500,cObserv1,oFont12n)
	nLinha += 60
	xVerPag()
	If	( ! Empty(cObserv2) )
		oPrint:Say(nLinha,0500,cObserv2,oFont12n)
		nLinha += 60
		xVerPag()
	EndIf
	If	( ! Empty(cObserv3) )
		oPrint:Say(nLinha,0500,cObserv3,oFont12n)
		xVerPag()
		nLinha += 60
	EndIf
	If	( ! Empty(cObserv4) )
		oPrint:Say(nLinha,0500,cObserv4,oFont12n)
		xVerPag()
		nLinha += 60
		xVerPag()
	EndIf

	nLinha += 20
	xVerPag()
	nLinha += 20
	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime a linha de prazo pagamento/entrega!ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:Say(nLinha,0100,OemToAnsi('Prazo Pagamento:'),oFont12)
	oPrint:Say(nLinha,0520,Posicione("SE4",1,xFilial("SE4")+TRA->C7_COND,"E4_DESCRI"),oFont12n)
	oPrint:Say(nLinha,1120,OemToAnsi('Prazo Entrega:'),oFont12)
	oPrint:Say(nLinha,1530,STR(stod(TRA->C7_DATPRF)-stod(TRA->C7_EMISSAO))+" DIA(S)",oFont12n)
	nLinha += 60
	xVerPag()

	nLinha += 20
	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime a linha de transportadora !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oPrint:Say(nLinha,0100,OemToAnsi('Transportadora:'),oFont12)
	//oPrint:Say(nLinha,0500,'________________________________________________________________',oFont12n)
	//nLinha += 60

	xVerPag()

	oPrint:Say(nLinha,0100,OemToAnsi('Comprador:'),oFont12)
	oPrint:Say(nLinha,0500,UsrFullName(SC7->C7_USER),oFont12n)

	oPrint:Say(nLinha,1120,OemToAnsi('Aprovador:'),oFont12)
	oPrint:Say(nLinha,1620,UsrFullName(SC7->C7_APROV),oFont12n)

	cStatus := IIF(Alltrim(SC7->C7_ENCER)= 'E','Atendido','AguarSdando')
	oPrint:Say(nLinha,2000,OemToAnsi('Status Pedido:'),oFont12)
	oPrint:Say(nLinha,2500,cStatus,oFont12n)

	nLinha += 100
	xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o Contato.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( ! Empty(SA2->A2_CONTATO) )
		oPrint:Say(nLinha,0100,OemToAnsi('Contato: '),oFont12)
		oPrint:Say(nLinha,0500,SA2->A2_CONTATO,oFont12n)
		nLinha += 60
		xVerPag()
	EndIf

	oPrint:Line(nLinha,0100,nLinha,2820+nCol)
	nLinha += 10
	xVerPag()
	/*
	oPrint:Say(nLinha,0100,OemToAnsi('Endereco de entrega'),oFont14)
	nLinha += 50
	If ALLTRIM(cCCusto)  <> "4000"
		oPrint:Say(nLinha,0100,OemToAnsi('Rua : ')+SM0->M0_ENDENT,oFont12)
		nLinha += 50
		oPrint:Say(nLinha,0100,OemToAnsi('Estado : ')+SM0->M0_CIDENT,oFont12)
		nLinha += 50
		oPrint:Say(nLinha,0100,OemToAnsi('CEP : ')+SM0->M0_CEPENT,oFont12)
		nLinha += 50
		oPrint:Say(nLinha,0100,OemToAnsi('Cidade : ')+SM0->M0_ESTENT,oFont12)
		nLinha += 50
		xVerPag()
		if xfilial("SC7")  == "00"
			oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0001-72 '),oFont12)
		endif
	Else
		oPrint:Say(nLinha,0100,OemToAnsi('Rua : EST. JOSE FLORIANO S/N - KM 13'),oFont12)
		nLinha += 50
		oPrint:Say(nLinha,0100,OemToAnsi('Estado : SP'),oFont12)
		nLinha += 50
		oPrint:Say(nLinha,0100,OemToAnsi('CEP : 18250-000'),oFont12)
		nLinha += 50
		oPrint:Say(nLinha,0100,OemToAnsi('Cidade : GUAREI'),oFont12)
		nLinha += 50
		xVerPag()
	EndIf
	if xfilial("SC7")  == "01"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ :  .453/0002-53 '),oFont12)
	endif

	if xfilial("SC7")  == "02"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0003-34 '),oFont12)
	endif

	if xfilial("SC7")  == "03"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0006-87 '),oFont12)
	endif

	if xfilial("SC7")  == "04"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0008-49 '),oFont12)
	endif

	if xfilial("SC7")  == "05"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0001-72 '),oFont12)
	endif

	if xfilial("SC7")  == "06"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0012-25 '),oFont12)
	endif

	if xfilial("SC7")  == "12"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0013-06 '),oFont12)
	endif

	if xfilial("SC7")  == "15"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0014-97 '),oFont12)
	endif

	if xfilial("SC7")  == "16"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0010-63 '),oFont12)
	endif

	if xfilial("SC7")  == "07"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0009-20 '),oFont12)
	endif

	if xfilial("SC7")  == "10"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0007-68 '),oFont12)
	endif

	if xfilial("SC7")  == "11"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0006-87 '),oFont12)
	endif

	if xfilial("SC7")  == "09"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0003-34 '),oFont12)
	endif
	if xfilial("SC7")  == "17"
		oPrint:Say(nLinha,0100,OemToAnsi('CNPJ : 06.262.453/0015-78 '),oFont12)
	endif
	nLinha += 50
	xVerPag()
	oPrint:Line(nLinha,0100,nLinha,2820+nCol)
	*/

	nLinha += 50
	xVerPag()
	
	_cMsg1 := "ษ  de  responsabilidade do  fornecedor fazer sua inscri็ใo na plataforma V360, atrav้s do link concreserv.com.br/fornecedores, e garantir que todas as Notas Fiscais"
	_cMsg2 := "por ele emitidas em face da CONCRESERV constem na plataforma, observada aprova็ใo e aceite pela CONCRESERV. O prazo para pagamento terแ inํcio apenas ap๓s o efetivo"
	_cMsg3 := "cadastramento na plataforma V360."
	//
	_cMsg4 := "O fornecedor declara que teve conhecimento e concorda com as clแusulas e condi็๕es do Contrato de Presta็ใo de Servi็os / Fornecimento de Materiais/Produtos"
	_cMsg5 := "registrado  no  xxบ  Oficial de  Registro de Tํtulos e Documentos e Civil de Pessoa Jurํdica da Capital – SP sob o nบ xx, em xx/0x/2023, disponํvel na ํntegra no"
	_cMsg6 := "endere็o: https://www.concreserv.com.br/xxxx"
	
	// Bloco 1 - de mensagens //
	oPrint:Say(nLinha,0100,OemToAnsi(_cMsg1),oFont12)
	nLinha += 70
	oPrint:Say(nLinha,0100,OemToAnsi(_cMsg2),oFont12)
	nLinha += 70
	oPrint:Say(nLinha,0100,OemToAnsi(_cMsg3),oFont12)
	// Bloco 2 de mensagens //
	xVerPag()

	nLinha += 100
	oPrint:Say(nLinha,0100,OemToAnsi(_cMsg4),oFont12)
	nLinha += 70
	oPrint:Say(nLinha,0100,OemToAnsi(_cMsg5),oFont12)
	nLinha += 70
	oPrint:Say(nLinha,0100,OemToAnsi(_cMsg6),oFont12)
	nLinha += 50
	/*
	oPrint:Say(nLinha,0100,OemToAnsi('E obrigatorio o envio do arquivo xml ao e-mail nfe@concreserv.com.br e da nota fiscal e comprovante de entrega com nome '),oFont12)
	nLinha += 70
	oPrint:Say(nLinha,0100,OemToAnsi('e RG legํvel ao e-mail? compras@concreserv.com.br.'),oFont12)
	nLinha += 70
	oPrint:Say(nLinha,0100,OemToAnsi('O prazo de pagamento terแ inํcio apenas ap๓s o efetivo recebimento desses documentos.'),oFont12)
	nLinha += 50
*/
	TRA->(DbCloseArea())

	xRodape()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime em Video, e finaliza a impressao. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCabec()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o cabecalho da empresa. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLinCab := 30
	//oPrint:SayBitmap(050,100,cFileLogo,50,50)
	oPrint:SayBitmap(050,100,cFileLogo,1180,310)
	oPrint:Say(050,1300,"DADOS PARA FATURAMENTO: ",oFont12n)
	oPrint:Say(080+nLinCab,1300,AllTrim(Upper(SM0->M0_NOMECOM)),oFont12n)
	oPrint:Say(135+nLinCab,1300,AllTrim(SM0->M0_ENDCOB),oFont11)
	oPrint:Say(180+nLinCab,1300,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' + AllTrim(SM0->M0_TEL),oFont11)
	oPrint:Say(225+nLinCab,1300,AllTrim('www.concreserv.com.br'),oFont11)

	oPrint:Line(285+nLinCab,1300,285+nLinCab,2300)

	oPrint:Say(300+nLinCab,1300,'CNPJ: '+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12)
	oPrint:Say(300+nLinCab,1850,'INSC. EST.: '+SM0->M0_INSC,oFont12)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTitulo do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( nTitulo == 1 ) // Cotacao
		oPrint:Say(0400,0800,OemToAnsi('Cota็ใo de Mercadorias'),oFont22)
	Else
		IF cPar09 == 1
			oPrint:Say(0400,0100,OemToAnsi('Pedido de Compras - '+ TRA->C7_NUM),oFont20)
		Else
			oPrint:Say(0400,0800,OemToAnsi('Pedido de Mercadorias - '+ TRA->C7_NUM),oFont22)
		Endif
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRodape()
	Local aArea := GetArea()

	oPrint:Line(3100,0100,3100,2560)
	DbSelectarea("SC7")
	oPrint:Say(3120,1050,UsrFullName(SC7->C7_USER),oFont16)
	oPrint:Line(3200,0100,3200,2560)

	Restarea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xVerPag()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xVerPag()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia a montagem da impressao.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( nLinha >= 2000 )

		If	( ! lFlag )
			xRodape()
			oPrint:EndPage()
			nLinha:= 600
		Else
			nLinha:= 800
		EndIf
		oPrint:SetLandscape()
		oPrint:StartPage()
		xCabec()

		lPrintDesTab := .t.

	EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta o SX1 - Arquivo de Perguntas..                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1(cPerg)
	Local aRegs   := {}
	//Local _sAlias := Alias()
	Local nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampos a serem grav. no SX1ณ
//ณaRegs[nx][01] - X1_GRUPO   ณ
//ณaRegs[nx][02] - X1_ORDEM   ณ
//ณaRegs[nx][03] - X1_PERGUNTEณ
//ณaRegs[nx][04] - X1_PERSPA  ณ
//ณaRegs[nx][05] - X1_PERENG  ณ
//ณaRegs[nx][06] - X1_VARIAVL ณ
//ณaRegs[nx][07] - X1_TIPO    ณ
//ณaRegs[nx][08] - X1_TAMANHO ณ
//ณaRegs[nx][09] - X1_DECIMAL ณ
//ณaRegs[nx][10] - X1_PRESEL  ณ
//ณaRegs[nx][11] - X1_GSC     ณ
//ณaRegs[nx][12] - X1_VALID   ณ
//ณaRegs[nx][13] - X1_VAR01   ณ
//ณaRegs[nx][14] - X1_DEF01   ณ
//ณaRegs[nx][15] - X1_DEF02   ณ
//ณaRegs[nx][16] - X1_DEF03   ณ
//ณaRegs[nx][17] - X1_F3      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria uma array, contendo todos os valores...ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aRegs,{cPerg,'01','Numero do Pedido   ?','Numero do Pedido   ?','Numero do Pedido   ?'		,'mv_ch1','C', 6,0,0,'G','','mv_par01','','','',''})
	aAdd(aRegs,{cPerg,'02','Imprime precos     ?','Imprime precos     ?','Imprime precos     ?'		,'mv_ch2','N', 1,0,1,'C','','mv_par02',OemToAnsi('Nใo'),'Sim','',''})
	aAdd(aRegs,{cPerg,'03','Titulo do Relatorio?','Titulo do Relatorio?','Titulo do Relatorio?'		,'mv_ch3','N', 1,0,1,'C','','mv_par03',OemToAnsi('Cota็ใo'),'Pedido','',''})
	aAdd(aRegs,{cPerg,'04',OemToAnsi('Observa็๕es'),'Observa็๕es         ','Observa็๕es       '		,'mv_ch4','C',70,0,1,'G','','mv_par04','','','',''})
	aAdd(aRegs,{cPerg,'05','                    ','                    ','                    '		,'mv_ch5','C',70,0,1,'G','','mv_par05','','','',''})
	aAdd(aRegs,{cPerg,'06','                    ','                    ','                    '		,'mv_ch6','C',70,0,0,'G','','mv_par06','','','',''})
	aAdd(aRegs,{cPerg,'07','                    ','                    ','                    '		,'mv_ch7','C',70,0,0,'G','','mv_par07','','','',''})
	aAdd(aRegs,{cPerg,'08','Imp. Cod. Prod. For?','Imp. Cod. Prod. For?','Imp. Cod. Prod. For?'		,'mv_ch8','N', 1,0,1,'C','','mv_par08',OemToAnsi('Sim'),OemToAnsi('Nใo'),'',''})
	aAdd(aRegs,{cPerg,'09','Faturamento Direto?' ,'Faturamento Direto?' ,'Faturamento Direto?' 		,'mv_ch9','N', 1,0,1,'C','','mv_par09',OemToAnsi('Sim'),OemToAnsi('Nใo'),'',''})
	aAdd(aRegs,{cPerg,'10','Cliente Fat.Diret.?','Fornecedor Fat.Diret.?','Fornecedor Fat.Diret.?'	,'mv_cha','C',6,0,1,'G','','mv_par10',,,'',''})
	aAdd(aRegs,{cPerg,'11','Loja Fat.Diret.?','Loja Fat.Diret.?','Loja Fat.Diret.?'					,'mv_chb','C',4,0,1,'G','','mv_par11',,,'',''})

	DbSelectArea('SX1')
	SX1->(DbSetOrder(1))

	For nX:=1 to Len(aRegs)
		If	RecLock('SX1',Iif(!SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02])),.t.,.f.))
			Replace SX1->X1_GRUPO		With aRegs[nx][01]
			Replace SX1->X1_ORDEM   	With aRegs[nx][02]
			Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
			Replace SX1->X1_PERSPA		With aRegs[nx][04]
			Replace SX1->X1_PERENG		With aRegs[nx][05]
			Replace SX1->X1_VARIAVL		With aRegs[nx][06]
			Replace SX1->X1_TIPO		With aRegs[nx][07]
			Replace SX1->X1_TAMANHO		With aRegs[nx][08]
			Replace SX1->X1_DECIMAL		With aRegs[nx][09]
			Replace SX1->X1_PRESEL		With aRegs[nx][10]
			Replace SX1->X1_GSC			With aRegs[nx][11]
			Replace SX1->X1_VALID		With aRegs[nx][12]
			Replace SX1->X1_VAR01		With aRegs[nx][13]
			Replace SX1->X1_DEF01		With aRegs[nx][14]
			Replace SX1->X1_DEF02		With aRegs[nx][15]
			Replace SX1->X1_DEF03		With aRegs[nx][16]
			Replace SX1->X1_F3   		With aRegs[nx][17]
			MsUnlock('SX1')
		Else
			Help('',1,'REGNOIS')
		Endif
	Next nX

Return
