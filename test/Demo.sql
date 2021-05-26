STS       - 2e1a92ece2e016569e193207c7c8cdb0d4ca5305
DOLARAMA  - 86d99a9d1e13ee1fdc33173c3b91ad0a1a7f3ab8
BANK      - 8e34e4472142a8f18ec33c4aa10e6b7d0dd2a5d0

Demo scenario
-------------
1. Create accounts at nodes RBRU, STS, DOLARAMA
On DB mirror1:
 insert into public."DEALS_ACCOUNTS"("BankAccount","BankBIC","Description")
 	values('2','044525700','Current') ;
 select max("Id") from public."DEALS_ACCOUNTS" --> <mirror1-account-id>
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 	values('AddAccount','2','NEW') ; -- Substitution Data='<mirror1-account-id>'='2'
 select "BlockChainId" from public."DEALS_ACCOUNTS" where "Id"=2 --> <mirror1-account-address> = 8e34e4472142a8f18ec33c4aa10e6b7d0dd2a5d0

On DB mirror3:
 insert into public."DEALS_ACCOUNTS"("BankAccount","BankBIC","Description")
 	values('2','044525700','Current') ;
 select max("Id") from public."DEALS_ACCOUNTS" --> <mirror3-account-id>
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 	values('AddAccount','2','NEW') ; -- Substitution Data='<mirror3-account-id>'='2'
 select "BlockChainId" from public."DEALS_ACCOUNTS" where "Id"=2 --> <mirror3-account-address> = 86d99a9d1e13ee1fdc33173c3b91ad0a1a7f3ab8

On DB mirror4:
 insert into public."DEALS_ACCOUNTS"("BankAccount","BankBIC","Description")
 		values('2','044525700','Current') ;
 select max("Id") from public."DEALS_ACCOUNTS" --> <mirror4-account-id>
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 	values('AddAccount','2','NEW') ; -- Substitution Data='<mirror4-account-id>'='2'
 select "BlockChainId" from public."DEALS_ACCOUNTS" where "Id"=2 --> <mirror4-account-address> = 2e1a92ece2e016569e193207c7c8cdb0d4ca5305

2. Update balance in accounts of STS, DOLARAMA +1000
On DB mirror3:
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 		values('UpdateBalance','{"Id":"2","Amount":"1000"}','NEW') ;

On DB mirror4:
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 		values('UpdateBalance','{"Id":"2","Amount":"1000"}','NEW') ;

3. Create deal for RBRU, STS, DOLARAMA on node STS
On DB mirror4:
 insert into public."DEALS"("Kind","Data") values('DealPayments','{"Title":"Test deal for payments"}') ;
 select max("Id") from public."DEALS" --> <mirror4-deal-id>=3336
 insert into public."DEALS_PARTIES"("DealId","PartyId","Role") values('3336','RBRU','Bank') ;
 insert into public."DEALS_PARTIES"("DealId","PartyId","Role") values('3336','DOLARAMA','Client-1') ;
 insert into public."DEALS_PARTIES"("DealId","PartyId","Role") values('3336','STS','Client-2') ;
 insert into public."DEALS_ACTIONS"("Action","Data","Status") values('AddDeal','3336','NEW') ;

4. Load payments to deal:
    - STS -> RBRU +500 at status "Stage-1"
	- RBRU -> DOLARAMA -> +450 at status "Stage-2"
	- STS -> RBRU +50 at status "Stage-2"

	On DB mirror4:
 insert into public."DEALS_PAYMENTS"("DealId","UID","Account_from","Account_to","Amount","Status")
 		values('3336','1','2e1a92ece2e016569e193207c7c8cdb0d4ca5305','8e34e4472142a8f18ec33c4aa10e6b7d0dd2a5d0',500,'Stage-1') ;
 insert into public."DEALS_PAYMENTS"("DealId","UID","Account_from","Account_to","Amount","Status")
 		values('3336','2','8e34e4472142a8f18ec33c4aa10e6b7d0dd2a5d0','86d99a9d1e13ee1fdc33173c3b91ad0a1a7f3ab8',450,'Stage-2') ;
 insert into public."DEALS_PAYMENTS"("DealId","UID","Account_from","Account_to","Amount","Status")
 		values('3336','3','2e1a92ece2e016569e193207c7c8cdb0d4ca5305','8e34e4472142a8f18ec33c4aa10e6b7d0dd2a5d0', 50,'Stage-2') ;
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 		values('AddPayments','{"Id":"3336","Payments":"1,2,3"}','NEW') ;

6. Approve payments on nodes STS, RBRU
-- "Id" in Data received from column Id at table DEALS_PAYMENTS
On DB mirror1:
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 		values('ApprovePayment','{"Id":"1", "Approve":"Y"}','NEW') ;

On DB mirror4:
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 		values('ApprovePayment','{"Id":"13", "Approve":"Y"}','NEW') ;
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 		values('ApprovePayment','{"Id":"15", "Approve":"Y"}','NEW') ;

6. Set deal state to "Stage-1" (from "New") by STS
On DB mirror4:
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 		values('SetStatus','{"Id":"3336","Status":"Stage-1","Remark":"Set state Stage-1"}','NEW') ;

7. Set deal state to "Stage-2" (from "Stage-1") by DOLARAMA
On DB mirror3:
 insert into public."DEALS_ACTIONS"("Action","Data","Status")
 		values('SetStatus','{"Id":"3411","Status":"Stage-2","Remark":"Set state Stage-2"}','NEW') ;

8. Check accounts balances in table DEALS_ACCOUNTS at nodes RBRU, STS, DOLARAMA
