use "spouse_sleep_main.dta", clear 

sort couple sex
egen pair = seq(), f(1) t(2)
rename pc* pc*_
keep projectID sex age_attendance1 assessment_centre1 pc1_-pc40_ chip chronotype_continuous chronotype1 sleepduration1 gettingup1 snoring1 insomnia1 acc_l5hr_AD_mn acc_sleep_dur_AD_mn acc_sleep_eff_AD_mn acc_n_noc_AD_mn age_actig_years couple pair *score

reshape wide projectID sex age_attendance1 assessment_centre1 pc1_-pc40_ chip chronotype_continuous chronotype1 sleepduration1 gettingup1 snoring1 insomnia1 acc_l5hr_AD_mn acc_sleep_dur_AD_mn acc_sleep_eff_AD_mn acc_n_noc_AD_mn age_actig_years couple pair, i(couple) j(pair) 

save "spouse_sleep_wide.dta", replace 

*phenotypic correlations
foreach exposure of varlist chronotype_continuous1 gettingup11 sleepduration11 insomnia11 snoring11 acc_l5hr_AD_mn1 acc_sleep_dur_AD_mn1 acc_sleep_eff_AD_mn1 acc_n_noc_AD_mn1{ 
foreach outcome of varlist chronotype_continuous2 gettingup12 sleepduration12 insomnia12 snoring12 acc_l5hr_AD_mn2 acc_sleep_dur_AD_mn2 acc_sleep_eff_AD_mn2 acc_n_noc_AD_mn2{

pcorr `outcome' `exposure' age_attendance11 age_attendance12 assessment_centre11

}
}

*genetic correlations 
foreach exposure of varlist chrono_score1 waking_score1 sleepduration_score1 insomnia_score1 snoring_score1{ 
foreach outcome of varlist chrono_score2 waking_score2 sleepduration_score2 insomnia_score2 snoring_score2 l5_score2 accsleepdur_score2 sleepeff_score2 episodes_score2{ 

pcorr `outcome' `exposure' age_attendance11 age_attendance12 assessment_centre11 chip1 chip2 pc1_1-pc10_1 pc1_2-pc10_2 
} 
}

foreach exposure of varlist l5_score1 accsleepdur_score1 sleepeff_score1 inactivity_score1 episodes_score1{ 
foreach outcome of varlist chrono_score2 waking_score2 sleepduration_score2 insomnia_score2 snoring_score2 l5_score2 accsleepdur_score2 sleepeff_score2 episodes_score2{ 

pcorr `outcome' `exposure' age_attendance11 age_attendance12 assessment_centre11 chip1 chip2 pc1_1-pc10_1 pc1_2-pc10_2 
} 
}

foreach exposure of varlist chrono_score2 waking_score2 sleepduration_score2 insomnia_score2 snoring_score2{ 
foreach outcome of varlist chrono_score1 waking_score1 sleepduration_score1 insomnia_score1 snoring_score1 l5_score1 accsleepdur_score1 sleepeff_score1 episodes_score1 { 

pcorr `outcome' `exposure' age_attendance11 age_attendance12 assessment_centre11 chip1 chip2 pc1_1-pc10_1 pc1_2-pc10_2 
} 
}

foreach exposure of varlist l5_score2 accsleepdur_score2 sleepeff_score2 inactivity_score2 episodes_score2{ 
foreach outcome of varlist chrono_score1 waking_score1 sleepduration_score1 insomnia_score1 snoring_score1 l5_score1 accsleepdur_score1 sleepeff_score1 episodes_score1{ 

pcorr `outcome' `exposure' age_attendance11 age_attendance12 assessment_centre11 chip1 chip2 pc1_1-pc10_1 pc1_2-pc10_2 
} 
}

*standardise continuous variables 
zscore chronotype_continuous* gettingup* sleepduration* insomnia* acc_l5hr_AD_mn* acc_sleep_dur_AD_mn* acc_sleep_eff_AD_mn* acc_n_noc_AD_mn*

*MR analysis
*chronotype 
*self-reported outcomes  
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (z_chronotype_continuous1 = chrono_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (z_chronotype_continuous2 = chrono_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (z_chronotype_continuous1 = chrono_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 z_acc_n_noc_AD_mn1{
ivreg2 `outcome' (z_chronotype_continuous2 = chrono_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 

*getting up  
*self-reported outcomes  
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (z_gettingup11 = waking_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (z_gettingup12 = waking_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (z_gettingup11 = waking_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 z_acc_n_noc_AD_mn1{
ivreg2 `outcome' (z_gettingup12 = waking_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 

*sleep duration 
*self-reported measures 
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (z_sleepduration11 = sleepduration_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (z_sleepduration12 = sleepduration_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (z_sleepduration11 = sleepduration_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 z_acc_n_noc_AD_mn1{
ivreg2 `outcome' (z_sleepduration12 = sleepduration_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 

*insomnia 
*self-reported measures 
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (z_insomnia11 = insomnia_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (z_insomnia12 = insomnia_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (z_insomnia11 = insomnia_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 z_acc_n_noc_AD_mn1{
ivreg2 `outcome' (z_insomnia12 = insomnia_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 

*snoring 
*self-reported measures 
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (snoring11 = snoring_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (snoring12 = snoring_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (snoring11 = snoring_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 z_acc_n_noc_AD_mn1{
ivreg2 `outcome' (snoring12 = snoring_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 

*L5 timing 
*self-reported measures 
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (z_acc_l5hr_AD_mn1 = l5_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (z_acc_l5hr_AD_mn2 = l5_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (z_acc_l5hr_AD_mn1 = l5_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 z_acc_n_noc_AD_mn1{
ivreg2 `outcome' (z_acc_l5hr_AD_mn2 = l5_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 

*acc sleep duration  
*self-reported measures 
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (z_acc_sleep_dur_AD_mn1 = accsleepdur_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (z_acc_sleep_dur_AD_mn2 = accsleepdur_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (z_acc_sleep_dur_AD_mn1 = accsleepdur_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 zz_acc_n_noc_AD_mn1{
ivreg2 `outcome' (z_acc_sleep_dur_AD_mn2 = accsleepdur_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 

*sleep efficiency 
*self-reported measures 
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (z_acc_sleep_eff_AD_mn1 = sleepeff_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (z_acc_sleep_eff_AD_mn2 = sleepeff_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (z_acc_sleep_eff_AD_mn1 = sleepeff_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 z_acc_n_noc_AD_mn1{
ivreg2 `outcome' (z_acc_sleep_eff_AD_mn2 = sleepeff_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 

*sleep episodes 
*self-reported measures 
foreach outcome of varlist z_chronotype_continuous2 z_gettingup12 z_sleepduration12 z_insomnia12 snoring12{
ivreg2 `outcome' (z_acc_n_noc_AD_mn1 = episodes_score1) age_attendance11 age_attendance12 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_chronotype_continuous1 z_gettingup11 z_sleepduration11 z_insomnia11 snoring11{
ivreg2 `outcome' (z_acc_n_noc_AD_mn2 = episodes_score2) age_attendance11 age_attendance12 i.assessment_centre11 chip2 pc1_2-pc10_2, ffirst 
} 

*accelerometer outcomes 
foreach outcome of varlist z_acc_l5hr_AD_mn2 z_acc_sleep_dur_AD_mn2 z_acc_sleep_eff_AD_mn2 z_acc_n_noc_AD_mn2{
ivreg2 `outcome' (z_acc_n_noc_AD_mn1 = episodes_score1) age_attendance11 age_actig_years2 i.assessment_centre11 chip1 pc1_1-pc10_1, ffirst 
} 

foreach outcome of varlist z_acc_l5hr_AD_mn1 z_acc_sleep_dur_AD_mn1 z_acc_sleep_eff_AD_mn1 z_acc_n_noc_AD_mn1{
ivreg2 `outcome' (z_acc_sleep_eff_AD_mn2 = episodes_score2) age_attendance12 age_actig_years1 i.assessment_centre12 chip2 pc1_2-pc10_2, ffirst 
} 
