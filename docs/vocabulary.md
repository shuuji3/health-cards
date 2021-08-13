# Verifiable Credential (VC) Types

* `https://smarthealth.cards#health-card`: A VC designed to convey a "Health Card" (i.e. clinical data bound to a subject's identity)

### More Granular Sub-types

* `https://smarthealth.cards#covid19`: A Health Card designed to convey COVID-19 details
* `https://smarthealth.cards#immunization`: A Health Card designed to convey immunization details
* `https://smarthealth.cards#laboratory`: A Health Card designed to convey laboratory results

##### Additional disease-specific sub-types
For immunizations, additional sub-types can be constructed as follows:

1. Look up vaccine group names at https://www2a.cdc.gov/vaccines/iis/iisstandards/vaccines.asp?rpt=vg
2. Convert to lower case and strip punctuation
3. Prepend with `https://smarthealth.cards#`

For example, the MMRV vaccine with CVX `94` belongs to two groups ("MMR" and "VARICELLA"), and so a Health Card reflecting doses of MMRV vaccine would be represented with a types array that includes:

* `https://smarthealth.cards#health-card`
* `https://smarthealth.cards#immunization`
* `https://smarthealth.cards#mmr`
* `https://smarthealth.cards#varicella`
