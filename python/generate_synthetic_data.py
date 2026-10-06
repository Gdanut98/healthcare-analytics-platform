from pathlib import Path
import numpy as np
import pandas as pd

SEED = 5052026
rng = np.random.default_rng(SEED)
OUT = Path(__file__).resolve().parents[1] / 'data' / 'raw'
OUT.mkdir(parents=True, exist_ok=True)

FIRST = ['Avery','Jordan','Taylor','Morgan','Casey','Riley','Cameron','Alex','Jamie','Drew','Sam','Parker','Quinn','Reese','Hayden']
LAST = ['Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Wilson','Anderson','Thomas','Moore','Martin','Lee','Clark']
CITIES = [('Phoenix','AZ','85004'),('Scottsdale','AZ','85251'),('Tempe','AZ','85281'),('Mesa','AZ','85201'),('Glendale','AZ','85301')]
PAYERS = ['Aetna','Cigna','UnitedHealthcare','Blue Cross Blue Shield','Medicare','Self Pay']
SPECIALTIES = ['Orthopedics','Sports','Neurologic','Geriatric','General PT']
VISITS = ['Initial Evaluation','Follow-up','Re-evaluation']
SERVICES = [
 ('97110','Therapeutic Exercise','Therapeutic','97110',55,15),
 ('97112','Neuromuscular Reeducation','Therapeutic','97112',62,15),
 ('97140','Manual Therapy','Manual','97140',68,15),
 ('97530','Therapeutic Activities','Therapeutic','97530',64,15),
 ('97116','Gait Training','Mobility','97116',58,15),
 ('97010','Hot/Cold Pack','Modality','97010',22,15),
]

def name(n):
    return rng.choice(FIRST,n), rng.choice(LAST,n)

# Patients
n_patients=1200
pf,pl=name(n_patients)
loc=[CITIES[i] for i in rng.integers(0,len(CITIES),n_patients)]
patients=pd.DataFrame({
 'patient_id':np.arange(10001,10001+n_patients), 'first_name':pf,'last_name':pl,
 'date_of_birth':pd.to_datetime(rng.integers(pd.Timestamp('1940-01-01').value//10**9,pd.Timestamp('2010-01-01').value//10**9,n_patients),unit='s').date,
 'city':[x[0] for x in loc], 'state':[x[1] for x in loc], 'zip_code':[x[2] for x in loc],
 'insurance_provider':rng.choice(PAYERS,n_patients,p=[.17,.14,.22,.23,.17,.07])
})
patients.to_csv(OUT/'patient.csv',index=False)

# Therapists
n_therapists=28
tf,tl=name(n_therapists)
therapists=pd.DataFrame({'therapist_id':np.arange(501,501+n_therapists),'first_name':tf,'last_name':tl,
 'specialty':rng.choice(SPECIALTIES,n_therapists),'employment_status':rng.choice(['Active','Active','Active','PRN'],n_therapists),
 'hire_date':pd.to_datetime(rng.integers(pd.Timestamp('2012-01-01').value//10**9,pd.Timestamp('2025-01-01').value//10**9,n_therapists),unit='s').date})
therapists.to_csv(OUT/'therapist.csv',index=False)

services=pd.DataFrame(SERVICES,columns=['service_code','service_name','service_category','billing_code','standard_fee','default_duration_minutes'])
services.to_csv(OUT/'service.csv',index=False)

# Appointments across 2024-2026
n_appts=18000
start=pd.Timestamp('2024-01-01'); end=pd.Timestamp('2026-09-30')
days=(end-start).days
appt_dates=start+pd.to_timedelta(rng.integers(0,days+1,n_appts),unit='D')+pd.to_timedelta(rng.choice([8,9,10,11,13,14,15,16],n_appts),unit='h')
status=rng.choice(['Completed','Cancelled','No Show','Scheduled'],n_appts,p=[.79,.09,.06,.06])
appointments=pd.DataFrame({'appointment_id':np.arange(200001,200001+n_appts),'patient_id':rng.choice(patients.patient_id,n_appts),
 'therapist_id':rng.choice(therapists.therapist_id,n_appts),'appointment_datetime':appt_dates,'duration_minutes':rng.choice([30,45,60],n_appts,p=[.15,.55,.30]),
 'appointment_status':status,'visit_type':rng.choice(VISITS,n_appts,p=[.18,.72,.10]),'room_number':rng.integers(1,13,n_appts)})
appointments.to_csv(OUT/'appointment.csv',index=False)

# Appointment services only for completed visits
rows=[]
for a in appointments.loc[appointments.appointment_status.eq('Completed')].itertuples(index=False):
    for code in rng.choice(services.service_code,size=int(rng.integers(1,4)),replace=False):
        s=services.loc[services.service_code.eq(code)].iloc[0]
        units=int(rng.integers(1,4)); fee=float(round(s.standard_fee*rng.uniform(.95,1.08),2))
        rows.append((a.appointment_id,code,units,fee))
appt_service=pd.DataFrame(rows,columns=['appointment_id','service_code','units_provided','unit_charge'])
appt_service.to_csv(OUT/'appointment_service.csv',index=False)

# Invoice one per completed appointment; service charges drive totals
charge=appt_service.assign(ext=lambda x:x.units_provided*x.unit_charge).groupby('appointment_id',as_index=False).ext.sum()
completed=appointments.loc[appointments.appointment_status.eq('Completed'),['appointment_id','patient_id','appointment_datetime']].merge(charge,on='appointment_id')
patient_payer=patients[['patient_id','insurance_provider']]
inv=completed.merge(patient_payer,on='patient_id')
inv['invoice_id']=np.arange(300001,300001+len(inv))
inv['invoice_date']=pd.to_datetime(inv.appointment_datetime).dt.date
inv['total_amount']=inv.ext.round(2)
selfpay=inv.insurance_provider.eq('Self Pay')
share=np.where(selfpay,0,rng.uniform(.72,.92,len(inv)))
inv['insurance_amount']=(inv.total_amount*share).round(2)
inv['patient_amount']=(inv.total_amount-inv.insurance_amount).round(2)
inv['due_date']=(pd.to_datetime(inv.invoice_date)+pd.Timedelta(days=30)).dt.date
inv['invoice_status']='Open'
invoices=inv[['invoice_id','appointment_id','invoice_date','total_amount','insurance_amount','patient_amount','due_date','insurance_provider','invoice_status']].copy()

# Payments: most invoices paid, with payer-specific delay tendencies
payer_delay={'Aetna':28,'Cigna':34,'UnitedHealthcare':31,'Blue Cross Blue Shield':25,'Medicare':21,'Self Pay':45}
pays=[]; pid=400001
for row in invoices.itertuples(index=False):
    paid = rng.random() < (0.92 if row.insurance_provider!='Self Pay' else 0.78)
    if not paid: continue
    mean=payer_delay[row.insurance_provider]
    delay=max(1,int(rng.normal(mean,10)))
    amount=round(float(row.total_amount)*rng.uniform(.96,1.0),2)
    pays.append((pid,row.invoice_id,pd.Timestamp(row.invoice_date)+pd.Timedelta(days=delay),amount,'Electronic' if row.insurance_provider!='Self Pay' else rng.choice(['Card','ACH']),'Insurance' if row.insurance_provider!='Self Pay' else 'Patient'))
    pid+=1
payments=pd.DataFrame(pays,columns=['payment_id','invoice_id','payment_date','payment_amount','payment_method','payment_source'])
paid_ids=set(payments.invoice_id)
invoices['invoice_status']=np.where(invoices.invoice_id.isin(paid_ids),'Paid','Open')
invoices.to_csv(OUT/'invoice.csv',index=False)
payments.to_csv(OUT/'payment.csv',index=False)

# Treatment plans
n_plans=2200
plans=pd.DataFrame({'plan_id':np.arange(600001,600001+n_plans),'patient_id':rng.choice(patients.patient_id,n_plans),
 'therapist_id':rng.choice(therapists.therapist_id,n_plans),'start_date':(start+pd.to_timedelta(rng.integers(0,days,n_plans),unit='D')).date,
 'diagnosis_code':rng.choice(['M54.50','M25.561','M25.562','M25.511','M25.512','M62.81'],n_plans),
 'visits_per_week':rng.choice([1,2,3],n_plans,p=[.2,.6,.2]),'total_authorized_visits':rng.choice([6,8,12,16,20],n_plans),'plan_status':rng.choice(['Active','Completed','Discharged'],n_plans,p=[.25,.55,.20])})
plans['end_date']=(pd.to_datetime(plans.start_date)+pd.to_timedelta(plans.total_authorized_visits/plans.visits_per_week*7,unit='D')).dt.date
plans.to_csv(OUT/'treatment_plan.csv',index=False)

print('Synthetic healthcare source data created in', OUT)
for p in sorted(OUT.glob('*.csv')):
    print(f'{p.name}: {sum(1 for _ in open(p, encoding="utf-8"))-1:,} rows')
