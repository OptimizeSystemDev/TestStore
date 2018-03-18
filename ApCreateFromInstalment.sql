USE [dbsiw1]
GO
/****** Object:  StoredProcedure [dbo].[APcreateFromInstalment]    Script Date: 03/18/2018 21:59:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[APcreateFromInstalment]  
(
	@pRecordcode 	char(4)
	,@pPOdoctype 	char(20)
	,@pPOdocid	int
	,@pPOBranchCode	char(10)
	,@pdocdate	char(10)
	,@pdoctime	char(6)
	,@pPoSubdoctype char(10)
	,@pPOsubdocid	int
	,@pSupplier	char(20)
	,@pQuantity	float
	,@pUnitPrice	float
	,@pTOtal	float
	,@pVatdocument	char(20)
	,@pVatdate	datetime
	,@pvat		float
	,@VatBranchCode char(10)
	
)

as 
--TSETAAAAAAAAA
--TTTTTTTTTTTTTTT
--GGGGGGGGGGGGGG
--exec transferonedocapCharIhead  'AP' , @apbranchcode ,@pdocdate ,@pdocdate,'2' ,@precordcode,'OTH',@running

declare @apbranchcode char(4)
set @apbranchcode='0000'
declare @recordcode char(4)
declare @doctype char(20)
declare @seq 	int
declare @docdate datetime
declare @doctime char(6)
declare @Pobranchcode char(5)
declare @salecode	char(2)
declare @subdoctype char(20)
declare @subdocid int 
declare @supplier char(20)
declare @chassis char(20)
declare @itemidlabour char(20)
declare @quantity float
declare @unitprice float
declare @producttotal float
declare @section	char(1)
declare @year int 
declare @month int 
declare @day int 
declare @runing char(20)
declare @rundigit int
declare @book char(2)
declare @running char(20)
declare @iddescription char(50)
declare @vatdocument char(20)
declare @vatdate datetime
declare @vatdatechar char(10)
declare @vat float
declare @docclass char(2)
declare @creditterm int
declare @vatrate int 
declare @ihmemo char(50)

set @docdate=@pdocdate
set @year =year(@docdate)
set @month=month(@docdate)
set @day=day(@docdate)
set @rundigit=(select runnodigit from acrunningoth where runrecordcode=@precordcode and runyear=@year and runmonth=@month and runbranch=@apbranchcode)
--set @vatdatechar =str(@year)+'-'+right('00'+str(@month),2)+'-'+right('00'+str(day(@pdocdate)),2)
set @vatdatechar =ltrim(str(@year))+'-'+right('00'+ltrim(str(@month)),2)+'-'+right('00'+ltrim(str(@day)),2)
set @book='1'
set @section='A'
set @salecode='20'
set @itemidlabour='1191-11-004'
set @docclass='5' --
set @chassis=(select TOP 1  hd.order_no from dbsltoram..sl_header hd inner join dbsltoram..sl_detail dt on hd.doc_type=dt.sub_doctype and hd.doc_id=dt.sub_dicid and dt.doc_type=@pPOdoctype and dt.doc_id=@pPOdocid)

--set @supplier=(select top 1 isnull(supp_cust_no,'') from dbsltoram..sl_detail where doc_type=@pPOdoctype and doc_id=@pPOdocid)
set @supplier=@psupplier
set @creditterm=(select isnull(term_of_payment,0) from suppliers where id=@supplier)
set @vatrate =(select top 1 isnull(vat_rate,0) from  doctype where id_doc_code='1214' )
set @ihmemo='จ่ายค่างวด '+ltrim(@pPOsubdoctype)+RIGHT ('000000000'+LTRIM((str(@pPOsubdocid))) ,9)





begin tran
update acrunningoth  set runno=runno+1 	where runyear=@year and runmonth=@month  and runrecordcode=@precordcode and runbranch=@apbranchcode and runbook=@book
set @running =(select rtrim(runformat)+right('000000000'+ ltrim(str(runno,9)),@rundigit) from acrunningoth where runyear=@year and runmonth=@month and   runrecordcode=@precordcode and runbranch=@apbranchcode)
set @doctype=@running
set @seq=10

set @recordcode=@pRecordcode
set @subdoctype=@pPOdoctype
set @subdocid=@pPOdocid
set @docdate=@pdocdate
set @doctime=@pdoctime
set @pobranchcode=@pPOBranchCode
set @quantity=1
--set @supplier=@pSupplier	
set @unitprice=@pUnitPrice
set @producttotal=@pTotal	
set @vatdocument=@pVatdocument
set @vatdate=@pVatDate
set @vat=@pVat



set @iddescription=(select payname from payment where payment=@itemidlabour)
--insert into idetail 

insert into idetail (
	[idRecordCode] ,	--1
	[idDocType] ,		--2
	[idDocId],		--3
	[idTerm],		--4
	[idSeq] ,		--5
	[idDocDate],		--6
	[idocTime],		--7
	[idBranchCode],		--8
	[idSaleCode],		--9
	[idJobType],		--10
	[idSubDocType],		--11
	[idSubDocNo],		--12
	[idChassisId],		--13
	[idItemIdPart],		--14
	[idItemIdLabour],	--15	
	[idItemIdBypass],	--16
	[idItemDescription],	--17
	[idItemType],		--18
	[idQtyBeforePost],	--19
	[idInOut],		--20
	[idQuantity],		--21
	[idUnitCost],		--22
	[idUnitPrice],		--23
	[idDiscount1],		--24
	[idDiscount2],		--25
	[idSpecialDiscount],	--26
	[idProductTotal],	--27
	[idCostTotal],		--28
	[idTechnician],		--29
	[idWorkingHours],	--30	
	[idSBrand],		--31
	[idSGroup],		--32 *****
	[idSType] ,		--33
	[idSection],		--34
	[idPmc],		--35
	[idFlagVat],		--36
	[idFlagCn],		--37
	[idFlagBypass],		--38
	[idFlagOilBypassNormal],--39
	[idFlagBypassToBill],	--40
	[idMemo],		--41
	[idCustPrice],		--42
	[idInsPrice],		--43
	[idDiscount],		--44
	[idAcceptFlag],		--45
	[idQtyFeedback],	--46	
	[idVatrate],		--47
	[idWhtRate],		--48
	[idWhtType],		--49
	[idVat],		--50
	[idWHT],		--51
	[idCurrency],		--52
	[idCurrencyRate],	--53	
	[idUnit],		--54
	[idReference],		--55
	[idChoose],		--56
	[idMode],		--57
	[idTransfer],		--58
	[idGroup],		--59
	[idSubGroup] 		--60
 
)


select 	@recordcode		--1
	,@doctype		--2
	,0			--3
	,0			--4
	,@seq			--5
	,@docdate		--6
	,@doctime		--7
	,@apbranchcode		--8


	,@salecode		--9
	,null			--10
	,@subdoctype		--11
	,@subdocid		--12
	,@chassis		--13
	,null			--14
	,@itemidLabour		--15
	,null			--16	
	,@iddescription		--17
	,'L'			--18
	,null			--19
	,null			--20
	,@quantity		--21
	,0			--22
	,@unitprice		--23
	,0			--24
	,0			--25
	,0			--26
	,@producttotal		--27
	,0			--28
	,null			--29
	,null			--30
	,@vatdocument		--31 --idsbrand
	,@vatdatechar		--32 --idstype
	,@pobranchcode		--33 --
	,@section		--34
	,null			--35
	,null			--36
	,null			--37
	,null			--38
	,null			--39
	,null			--40
	,null			--41
	,@unitprice		--42
	,null			--43
	,null			--44
	,null			--45
	,null			--46
	,@vatrate		--47
	,0			--48
	,null			--49
	,@vat			--50
	,0			--51
	,'TH'			--52
	,1			--53
	,null			--54
	,@supplier		--55
	,null			--56
	,null			--57
	,null			--58
	,null			--59
	,null			--60


			

insert into ihead (
	[ihRecordCode],		--1			
	[ihDocType],		--2
	[ihDocId],		--3
	[ihTerm] ,		--4
	[ihDocDate],		--5
	[ihDocTime],		--6
	[ihBranchCode],		--7
	[ihSaleCode],		--8
	[ihSubDocType],		--9
	[ihSubDocNo],		--10
	[ihReference1],		--11
	[ihReferenceDate1],	--12	
	[ihReference2],		--13
	[ihReferenceDate2],	--14
	[ihJobType],		--15
	[ihChassis],		--16
	[ihCustomer],		--17
	[ihSupplier],		--19
	[ihPaymentType],	--20	
	[ihPaymentReference],	--21
	[ihPaymentDate],	--22				
	[ihPaymentBank],	--23
	[ihPaymentBankBranch],	--24
	[ihDueDate],		--25
	[ihEmployee],		--26
	[ihAmountSum],		--27
	[ihAmountDiscount],	--28
	[ihAmountTax],		--29
	[ihAmountTotalIncludeTax],--30
	[ihDeduction],		--31
	[ihSpecialDiscount],	--32
	[ihPaymentTotal],	--33	
	[ihPaymentStatus],	--34
	[ihCreditNote],		--35
	[ihCreditNoteAfterReceive],--36
	[ihCostTotal],		--37
	[ihLabourTotal],	--38	
	[ihLabourDiscount],	--39
	[ihLabourCost],		--40
	[ihBypassLabour],	--41	
	[ihBypassLabourCost],	--42
	[ihPartTotal],		--43
	[ihPartDiscount],	--44
	[ihPartCost],		--45
	[ihBypassPart],		--46
	[ihBypassPartCost],	--47
	[ihOilTotal],		--48
	[ihOilCost],		--49
	[ihFlagVat],		--50
	[ihFlagCancel],		--51
	[ihVatRate],		--52
	[ihVatType],		--53
	[ihLastLineNOPart],	--54
	[ihLastLIneNOLabour],	--55
	[ihMemo],		--56
	[ihCustAmountSum],	--57	
	[ihInsAmountSum],	--58	
	[ihInsAmountDiscount],	--59
	[ihInsSpecialDiscount],	--60
	[ihInsAmountTotal],	--61
	[ihInsAmountTax],	--62
	[ihInsAmountTotalIncludeTax],--63
	[ihInsDiscountAfterTax],--64
	[ihInsPayment],		--65
	[ihInsException],	--66
	[ihCustAmountDiscount],	--67
	[ihCustSpecialDiscount],--68
	[ihCustAmountTotal],	--69
	[ihCustAmountTax],	--70
	[ihCustAmountTotalIncludeTax],--71
	[ihCustDiscountAfterTax],--72
	[ihCustPayment],	--73	
	[ihCustException],	--74
	[ihExceptionPreValue],	--75
	[ihExceptionFlag] ,	--76
	[ihExceptionValue] ,	--77
	[ihInsNetPriceFlag],	--78
	[ihInsNetPrice],	--79
	[ihWHT],		--80
	[ihTransferFlag],	--81
	[ihOther] ,		--82
	[ihChoose] 		--83
) 
select 
	@recordcode,		--1			
	@running,		--2
	0,			--3
	0,			--4
	@docdate,		--5
	@doctime,		--6
	@apbranchcode,		--7
	@salecode,		--8
	@subdoctype,		--9
	@subdocid,		--10
	@vatdocument,		--11
	@vatdate,		--12	
	null,			--13
	null,			--14
	null,			--15
	@chassis,		--16
	null,			--17
	@Supplier,		--19
	@docclass,		--20	
	null,			--21
	null,			--22				
	null,			--23
	@vatbranchcode,		--24
	dateadd(dd,@creditterm,@docdate) ,		--25
	null,			--26
	@producttotal,		--27
	0,			--28
	@vat,			--29
	@producttotal+@vat,	--30
	0,			--31
	0,			--32
	0,			--33	
	null,			--34
	null,			--35
	null,			--36
	null,			--37
	null,			--38	
	null,			--39
	null,			--40
	null,			--41	
	null,			--42
	null,			--43
	null,			--44
	null,			--45
	null,			--46
	null,			--47
	null,			--48
	null,			--49
	null,			--50
	null,			--51
	@vatrate,		--52
	'E',			--53
	null,			--54
	null,			--55
	@ihmemo,		--56
	null,			--57	
	null,			--58	
	null,			--59
	null,			--60
	null,			--61
	null,			--62
	null,			--63
	null,			--64
	null,			--65
	null,			--66
	null,			--67
	null,			--68
	null,			--69
	null,			--70
	null,			--71
	null,			--72
	null,			--73	
	null,			--74
	null,			--75
	null,			--76
	null,			--77
	null,			--78
	null,			--79
	null,			--80  ihwht
	null,			--81
	null,			--82
	null 			--83
	

--exec
update #search set feedbackihead =@running where idsearch=@ppodoctype   and instalment=@ppodocid 
exec transferonedocapCharIhead  'AP' , @apbranchcode ,@pdocdate ,@pdocdate,'2' ,@precordcode,'OTH',@running
if (@@ERROR=0)

	COMMIT
ELSE 
	ROLLBACK



