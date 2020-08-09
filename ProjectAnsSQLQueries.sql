--Quest 1
select Profiles.profile_id, CONCAT(Profiles.first_name,' ',Profiles.last_name) as FullName,
 Profiles.phone from Profiles
 inner join Tenancy_histories
 on Profiles.profile_id=Tenancy_histories.profile_id
 where Profiles.profile_id in
 (select profile_id from
  (select top(1) datediff(dd, move_in_date,move_out_date)as a,profile_id from 
 Tenancy_histories) as b)

 --Quest 2
 
select CONCAT(Profiles.first_name,' ',Profiles.last_name) as FullName, Profiles.email,
 Profiles.phone from Profiles
 inner join Tenancy_histories
 on Profiles.profile_id=Tenancy_histories.profile_id
 where  Tenancy_histories.rent>9000 and Profiles.profile_id in
 (select profile_id from profiles where marital_status='Y')

 --Quest 3
  select p.profile_id, CONCAT(p.first_name,' ',p.last_name) as FullName, p.phone, p.email,
  p.[city(hometown)], t.house_id, t.move_in_date, t.move_out_date, t.rent, e.latest_employer,
  e.Occupational_category, COALESCE(r.NumberOfrefferals,0) from Tenancy_histories as t
   inner join Profiles as p
   on t.profile_id=p.profile_id
   inner join Employment_details as e
   on p.profile_id=e.profile_id
	left join(select COUNT(*) as NumberOfrefferals, referrer_id from Referrals
  where referral_valid=1
  group by referrer_id) as r
   on p.profile_id=r.referrer_id
      where
   p.[city(hometown)] in('Bangalore', 'Pune') and 
   (t.move_in_date between '2015-01-01' and '2016-01-31') or
  (t.move_out_date between '2015-01-01' and '2016-01-31') or
  (t.move_in_date <= '2015-01-01' and t.move_out_date>= '2016-01-31')
  order by rent desc

  --Quest 4
  
 select CONCAT(p.first_name,' ',p.last_name) as FullName, p.email, 
 p.phone, r.referrer_id, r.TotalReferralBonus from Profiles as p
 inner join (select referrer_id,sum(referrer_bonus_amount) as TotalReferralBonus from Referrals
 where referral_valid=1
 group by referrer_id) as r
 on p.profile_id=r.referrer_id

 --Quest 5
 
select distinct(p.[city(hometown)]), sum(t.rent) over (partition by [city(hometown)] ) as CityTotalRent, 
SUM(rent) over() as TotalRent from Profiles as p
inner join Tenancy_histories as t
on t.profile_id=p.profile_id
--Quest6

create view vw_tenant as
select profile_id, rent, move_in_date, h.house_type, h.beds_vacant, a.description, a.city
 from Tenancy_histories as t
inner join Houses as h
on t.house_id=h.house_id
inner join Addresses as a
on a.house_id=h.house_id
 where move_in_date>='2015-04-30' 
and move_out_date is null and
h.beds_vacant>0

select * from vw_tenant

--Quest 7

select top(1)
 ref_id,referrer_id,valid_till,DATEADD(m,1,valid_till) as extended_valid_till from Referrals
 where referrer_id in (select referrer_id from Referrals
group by referrer_id
having  COUNT(*) >2)
order by valid_till desc

--Quest 8

select p.profile_id, CONCAT(p.first_name,' ',p.last_name) as FullName,
 p.phone, iif(t.rent>10000,'Grade A',iif(t.rent<7500,'Grade C', 'Grade B')) as 'Customer Segment' from Profiles as p
 inner join Tenancy_histories as t
 on t.profile_id=p.profile_id


 --Quest 9
 
select CONCAT(p.first_name,' ',p.last_name) as FullName,
 p.phone, p.[city(hometown)], h.house_type, h.bhk_details, h.bed_count, h.furnishing_type, h.Beds_vacant
  from Profiles as p
 inner join Tenancy_histories as t
 on t.profile_id=p.profile_id
 inner join Houses as h
 on t.house_id=h.house_id
 where p.profile_id not in (select referrer_id from Referrals)


--Quest 10
select * from Houses where SUBSTRING(bhk_details,1,1) in(
select top(1) SUBSTRING(bhk_details,1,1) as occupancy from Houses order by bhk_details desc )

