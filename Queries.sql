-- Fetch Rewards Queries


1. 

with t1 as (
select * from receipts,
 JSON_TABLE(rewardsReceiptItemList, '$[*]'
 COLUMNS (
            brandCode VARCHAR(40)  PATH '$.brandCode',
            barcode VARCHAR(100) PATH '$.barcode',
            competitorRewardsGroup VARCHAR(64) PATH '$.competitorRewardsGroup',
            description VARCHAR(100) PATH '$.description',
            discountedItemPrice decimal PATH '$.discountedItemPrice',
            finalPrice decimal PATH '$.finalPrice',
            itemPrice decimal PATH '$.itemPrice',
            originalReceiptItemText VARCHAR(100) PATH '$.originalReceiptItemText',
            partnerItemId VARCHAR(100) PATH '$.partnerItemId',
            quantityPurchased bigint PATH '$.quantityPurchased'
 ) items;
),
 top_codes as (
select brandCode, sum(quantityPurchased) as total_purchased
from t1
where MONTH(FROM_UNIXTIME(dateScanned ->> '$.Date')) = MONTH(CURRENT_DATE()) #most recent month
group by 1 
order by 2 
limit 5)
 select b.brandName from brands b
 join top_codes a on (a.brandCode = b.brandCode)

 2.
 	with recent_month_counts as(
 		select brandCode, count(distinct _id->>'$.oid') as num_transactions
 		from t1 
 		where MONTH(FROM_UNIXTIME(dateScanned ->> '$.Date')) = MONTH(CURRENT_DATE())
 		group by 1 
 		),
 	previous_month_counts as (
 		select brandCode, count(distinct _id->>'$.oid') as num_transactions
 		from t1 
 		where MONTH(FROM_UNIXTIME(dateScanned ->> '$.Date')) = MONTH(DATE_ADD(CURRENT_DATE(), INTERVAL -1 MONTH))
 		group by 1 
 		),
 	recent_month_ranks as(
 		select brandCode, rank() over(order by num_transactions desc) as rn 
 		from recent_month_counts
 		limit 5
 		),
 	previous_month_ranks as (
 		select brandCode, rank() over(order by num_transactions desc) as rn 
 		from previous_month_counts
 		)
 	select A.brandCode, C.name as brand_name, A.rn as recent_month_rank, B.rn as prev_month_rank
 	from recent_month_ranks A inner join previous_month_ranks B on (A.brandCode = B.brandCode)
 	join brands C on (A.brandCode = C.brandCode)

 3. 

  select rewardsReceiptStatus, avg(totalSpent)
  from receipts
  where rewardsReceiptStatus='Accepted' 
  or rewardsReceiptStatus = 'Rejected'
  group by 1
  order by 2 desc
  limit 1; 


  4. 

 select rewardsReceiptStatus, sum(purchasedItemCount)
 from receipts
 where rewardsReceiptStatus='Accepted' 
 or rewardsReceiptStatus = 'Rejected'
 group by 1
 order by 2 desc
 limit 1; 


 5.

 
 select A.brandCode, b.name,sum(A.itemPrice) from
 t1 A join users u on (A.user_id=u._id ->> '$.oid')
 join brand b on (A.brandCode=b.brandCode)
 where FROM_UNIXTIME(u.createDate->> '$.Date') >  DATEADD(CURRENT_DATE(), INTERVAL -6 MONTH)
 group by 1,2
 order by 3 desc
 limit 1;


6. Which brand has the most transactions 
   among users who were created within the 
   past 6 months?


 select A.brandCode, b.name, count(distinct A._id ->> '$.oid')
 from t1 A join brand b on (A.brandCode=b.brandCode)
 join users u on (A.userId= u._id ->> '$.oid')
 where FROM_UNIXTIME(u.createDate->> '$.Date') >  DATEADD(CURRENT_DATE(), INTERVAL -6 MONTH)
 group by 1,2
 order by 3 desc
 limit 1;

