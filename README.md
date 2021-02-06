# VirtualSettlement

--- Механизм корпоративных взаиморасчетов на смарт-контрактах. based on smart contracts

## Purpose 
Разработка механизма корпоративных взаиморасчетов для группы компаний, а также её реализации для Платформы на основе абстрактных бизнес-объектов R-Chain.
Design and development of corporate settlements mechanism for a group of companies based on R-Chain abstract business objects.


## Objectives 
•	Развитие существующей концепции абстрактных сделок на платформе R-Chain. Доработка программного кода адаптера Mirror только в части расчетов.
Improvement of the existing "abstract deals" concept on the R-Chain platform. Modification of the smart-contracts and adapter program code in terms of settlement only.
•	Анализ различных вариантов архитектуры - с центральным учетным смарт-контрактом и с выделенным узлом взаимозачетов - Оракулом. Определение преимуществ и недостатков обеих вариантов, а также возможных границ их применимости.
Design and analysis different options of the settlement mechanism : first - with a central accounting smart contract, second - with a dedicated node - Oracle. It will be necessary to determine advantages and disadvantages of both options, as well as the possible boundaries of their applicability


## Методические материалы и обеспечивающие работы со стороны Райффайзенбанка.

1.	Нужно предварительно проанализировать:  sg-fsi-project-ubin-report.pdf - расчетная система Сингапура на блокчейне Quorum, в части архитектуры платформы по расчетам
Suggested reading: sg-fsi-project-ubin-report.pdf - Singapore settlement system (project Ubin) on the Quorum blockchain: parts about platform architecture and monetary model
2.	https://github.com/project-ubin - код проекта Ubin : В системы происходит депонирование банками денежных средств в качестве залога в обмен на цифровую валюту, эмитентом которой является ЦБ. Банки-участники могут проводить финансовые транзакции между собой цифровой валютой напрямую, без платежной системы валютного государственного управления, а также могут проводить обратную операцию с цифровой валютой, выкупив за нее депонированные ранее денежные средства.
https://github.com/project-ubin - Ubin project code : Banks deposit money into the system as collateral in exchange for digital currency, the issuer of which is the Central Bank. Participating banks can conduct financial transactions among themselves with digital currency directly, without the payment system of the foreign exchange, and can also conduct a reverse transaction with digital currency by redeeming previously deposited funds for it.
3.	Смарт-контракты описания абстрактной сделки.
Smart contracts of an abstract deal.
4.	Исходные коды адаптера R-Chain в части работы с абстрактной сделкой.
Source codes of the R-Chain adapter regarding an abstract deal
