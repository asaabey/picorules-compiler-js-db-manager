# Picorules Test Report

**Generated:** 2026-01-03T00:40:31.909Z
**Dialect:** postgresql
**Mode:** Full Execution

## Summary

| Metric | Value |
|--------|-------|
| Total .prb files | 168 |
| Loaded successfully | 168 |
| Load errors | 0 |
| Load time | 29ms |

| Compilation | SUCCESS |
| SQL statements generated | 168 |
| Compilation time | 43ms |

| Executed | 85 |
| Passed | 3 |
| Failed | 82 |
| Skipped | 83 |
| Success rate | 3.5% |
| Execution time | 6059ms |

## Execution Failures

| Ruleblock | Target Table | Dependencies | Error |
|-----------|--------------|--------------|-------|
| rrt | srout_rrt | - | column "loc" does not exist |
| dmg | srout_dmg | - | relation "rout_dmg" already exists |
| ckd_egfr_metrics | srout_ckd_egfr_metrics | - | column "egfr_l_dt" does not exist |
| ckd_uacr_metrics | srout_ckd_uacr_metrics | - | column "acr_l_dt" does not exist |
| ckd_c_gn | srout_ckd_c_gn | - | relation "rout_ckd_c_gn" already exists |
| ckd_c_tid | srout_ckd_c_tid | - | relation "rout_ckd_c_tid" already exists |
| ckd_c_rnm | srout_ckd_c_rnm | - | relation "rout_ckd_c_rnm" already exists |
| dmg_loc | srout_dmg_loc | - | column "loc" does not exist |
| dmg_hrn | srout_dmg_hrn | - | relation "rout_dmg_hrn" already exists |
| engmnt_renal | srout_engmnt_renal | - | relation "rout_engmnt_renal" already exists |
| ckd_access | srout_ckd_access | - | relation "rout_ckd_access" already exists |
| cd_dm_dx | srout_cd_dm_dx | - | relation "rout_cd_dm_dx" already exists |
| cd_htn | srout_cd_htn | - | relation "rout_cd_htn" already exists |
| cd_cardiac_ix | srout_cd_cardiac_ix | - | relation "rout_cd_cardiac_ix" already exists |
| cd_obesity | srout_cd_obesity | - | relation "rout_cd_obesity" already exists |
| cd_hepb_coded | srout_cd_hepb_coded | - | column "hepb_icpc_code" does not exist |
| rx_av_nrti | srout_rx_av_nrti | - | relation "rout_rx_av_nrti" already exists |
| ckd_dense | srout_ckd_dense | - | operator does not exist: text = integer |
| dmg_residency | srout_dmg_residency | - | relation "rout_dmg_residency" already exists |
| ca_breast | srout_ca_breast | - | relation "rout_ca_breast" already exists |
| ca_careplan | srout_ca_careplan | - | relation "rout_ca_careplan" already exists |
| ca_crc | srout_ca_crc | - | relation "rout_ca_crc" already exists |
| ca_endometrial | srout_ca_endometrial | - | relation "rout_ca_endometrial" already exists |
| ca_lung | srout_ca_lung | - | relation "rout_ca_lung" already exists |
| ca_mets | srout_ca_mets | - | relation "rout_ca_mets" already exists |
| ca_misc | srout_ca_misc | - | column "ca_att" does not exist |
| ca_ovarian | srout_ca_ovarian | - | relation "rout_ca_ovarian" already exists |
| ca_prostate | srout_ca_prostate | - | relation "rout_ca_prostate" already exists |
| ca_rcc | srout_ca_rcc | - | relation "rout_ca_rcc" already exists |
| ca_skin_melanoma | srout_ca_skin_melanoma | - | relation "rout_ca_skin_melanoma" already exists |
| ca_thyroid | srout_ca_thyroid | - | relation "rout_ca_thyroid" already exists |
| cd_cardiac_rx | srout_cd_cardiac_rx | - | relation "rout_cd_cardiac_rx" already exists |
| cd_cardiac_device | srout_cd_cardiac_device | - | relation "rout_cd_cardiac_device" already exists |
| cd_cardiac_enc | srout_cd_cardiac_enc | - | relation "rout_cd_cardiac_enc" already exists |
| cd_cardiac_vte | srout_cd_cardiac_vte | - | relation "rout_cd_cardiac_vte" already exists |
| cd_cirrhosis | srout_cd_cirrhosis | - | relation "rout_cd_cirrhosis" already exists |
| cd_cns | srout_cd_cns | - | relation "rout_cd_cns" already exists |
| cd_cns_ch | srout_cd_cns_ch | - | relation "rout_cd_cns_ch" already exists |
| cd_cva | srout_cd_cva | - | relation "rout_cd_cva" already exists |
| cd_endo_hypothyroid | srout_cd_endo_hypothyroid | - | relation "rout_cd_endo_hypothyroid" already exists |
| cd_haem | srout_cd_haem | - | relation "rout_cd_haem" already exists |
| cd_hepb | srout_cd_hepb | - | WITH query name "sq_e_ab" specified more than once |
| cd_imm_vasculitis | srout_cd_imm_vasculitis | - | relation "rout_cd_imm_vasculitis" already exists |
| cd_pulm_copd | srout_cd_pulm_copd | - | relation "rout_cd_pulm_copd" already exists |
| cd_pulm_bt | srout_cd_pulm_bt | - | relation "rout_cd_pulm_bt" already exists |
| cd_nutr_low | srout_cd_nutr_low | - | column "wt_dt" does not exist |
| cd_pulm | srout_cd_pulm | - | relation "rout_cd_pulm" already exists |
| cd_rheum_gout | srout_cd_rheum_gout | - | relation "rout_cd_rheum_gout" already exists |
| cd_rheum_ra | srout_cd_rheum_ra | - | relation "rout_cd_rheum_ra" already exists |
| cd_rheum_sle | srout_cd_rheum_sle | - | relation "rout_cd_rheum_sle" already exists |
| opa_sep | srout_opa_sep | - | relation "rout_opa_sep" already exists |
| ckd_ttem | srout_ckd_ttem | - | column "rrt_dt_min" does not exist |
| vacc_covid | srout_vacc_covid | - | relation "rout_vacc_covid" already exists |
| cmidx_charlson | srout_cmidx_charlson | - | relation "rout_cmidx_charlson" already exists |
| core_info_entropy | srout_core_info_entropy | - | relation "rout_core_info_entropy" already exists |
| dmg_eid_alt | srout_dmg_eid_alt | - | relation "rout_dmg_eid_alt" already exists |
| dmg_loc2 | srout_dmg_loc2 | - | column "loc" does not exist |
| dmg_loc_origin | srout_dmg_loc_origin | - | column "loc" does not exist |
| dmg_tkcuser_interact | srout_dmg_tkcuser_interact | - | relation "rout_dmg_tkcuser_interact" already exists |
| ipa_icu | srout_ipa_icu | - | relation "rout_ipa_icu" already exists |
| pregnancy | srout_pregnancy | - | column "us_ld" does not exist |
| egfr_metrics | srout_egfr_metrics | - | column "egfr_rn_dt" does not exist |
| id_cap | srout_id_cap | - | relation "rout_id_cap" already exists |
| id_covid19 | srout_id_covid19 | - | relation "rout_id_covid19" already exists |
| id_hcv | srout_id_hcv | - | relation "rout_id_hcv" already exists |
| id_htlv | srout_id_htlv | - | relation "rout_id_htlv" already exists |
| id_sti | srout_id_sti | - | relation "rout_id_sti" already exists |
| id_tb | srout_id_tb | - | relation "rout_id_tb" already exists |
| id_uti | srout_id_uti | - | relation "rout_id_uti" already exists |
| kpi_uncategorised | srout_kpi_uncategorised | - | relation "rout_kpi_uncategorised" already exists |
| mbs_billing_history | srout_mbs_billing_history | - | relation "rout_mbs_billing_history" already exists |
| ortho_amputation | srout_ortho_amputation | - | relation "rout_ortho_amputation" already exists |
| ortho_fractures | srout_ortho_fractures | - | relation "rout_ortho_fractures" already exists |
| rrt_hd_loc | srout_rrt_hd_loc | - | column "loc" does not exist |
| rrt_new3_wip | srout_rrt_new3_wip | - | column "loc" does not exist |
| rrt_pd | srout_rrt_pd | - | relation "rout_rrt_pd" already exists |
| rx_is_sot | srout_rx_is_sot | - | relation "rout_rx_is_sot" already exists |
| rx_cv_common | srout_rx_cv_common | - | relation "rout_rx_cv_common" already exists |
| rx_cv_lmd | srout_rx_cv_lmd | - | relation "rout_rx_cv_lmd" already exists |
| rx_desc_ptr | srout_rx_desc_ptr | - | relation "rout_rx_desc_ptr" already exists |
| rx_rrt_common | srout_rx_rrt_common | - | relation "rout_rx_rrt_common" already exists |
| sx_abdo | srout_sx_abdo | - | relation "rout_sx_abdo" already exists |

## Skipped Ruleblocks

These ruleblocks were skipped due to dependency failures or execution stopping:

- acr_graph
- dmg_source
- ckd_careplan
- ckd
- tg4100
- ad_aki
- cd_cardiac_cad
- cd_cardiac_rhd
- cd_hep_b_sero
- cd_hepb_master
- at_risk
- at_risk_dense
- bi_vm
- cd_careplan
- cvra
- cd_htn_bp_control
- bp_graph
- ca_solid
- cd_dyslip
- cardiac_cad_card
- cd_cardiac_vhd
- cd_cardiac_chf
- cd_cardiac_af
- cd_dm_comp
- cd_dm_glyc_cntrl
- cd_dm_mx
- cd_dm_rx_rcm
- cd_htn_card
- cd_htn_rcm
- cd_multi_m1
- cd_rheum_aps
- ckd_anaemia
- ckd_journey
- ckd_diagnostics
- tg4630
- ckd_card
- ckd_cause
- ckd_complications
- ckd_labs
- ckd_prog_vm
- ckd_shpt
- cm_vm
- cvra_predict1_aus
- dm_card
- dmg_vm
- egfr_graph2
- frm_func_assm
- global
- hb_graph
- hba1c_graph
- kfre
- mbs715
- obs_vm
- pcd
- periop_nsqip
- phos_graph
- rrt_hd_adequacy
- rrt_1_metrics
- rrt_hd_param
- rrt_1_card
- rrt_assert
- rrt_hd_acc_iv
- rrt_hd_acc_card
- rrt_hd_location
- rrt_hd_prog_vm
- rrt_journey
- rrt_labs_euc
- rrt_panel_vm
- rrt_pd_card
- rrt_tx
- rrt_tx_card
- tg2610
- tg4110
- tg4122
- tg4123
- tg4410
- tg4420
- tg4610
- tg4620
- tg4660
- tg4720
- tg4722
- tg4810

## Execution Order

Ruleblocks in topological order (dependencies first):

| Order | Ruleblock | Dependencies | Status |
|-------|-----------|--------------|--------|
| 1 | rrt | - | FAIL |
| 2 | acr_graph | rrt | SKIPPED |
| 3 | acr_metrics | - | PASS |
| 4 | dmg | - | FAIL |
| 5 | ckd_egfr_metrics | - | FAIL |
| 6 | ckd_uacr_metrics | - | FAIL |
| 7 | ckd_c_gn | - | FAIL |
| 8 | ckd_c_tid | - | FAIL |
| 9 | ckd_c_rnm | - | FAIL |
| 10 | dmg_loc | - | FAIL |
| 11 | dmg_hrn | - | FAIL |
| 12 | dmg_source | rrt, dmg_loc, dmg_hrn | SKIPPED |
| 13 | ckd_careplan | dmg_source | SKIPPED |
| 14 | ckd_coded_dx | - | PASS |
| 15 | engmnt_renal | - | FAIL |
| 16 | ckd_access | - | FAIL |
| 17 | ckd | rrt, ckd_egfr_metrics, ckd_uacr_metrics, ckd_c_gn, ckd_c_tid, ckd_c_rnm, ckd_careplan, ckd_coded_dx, engmnt_renal, ckd_access | SKIPPED |
| 18 | tg4100 | dmg, rrt, ckd, dmg_source | SKIPPED |
| 19 | ad_aki | tg4100 | SKIPPED |
| 20 | cd_dm_dx | - | FAIL |
| 21 | cd_htn | - | FAIL |
| 22 | cd_cardiac_ix | - | FAIL |
| 23 | cd_cardiac_cad | cd_cardiac_ix | SKIPPED |
| 24 | cd_obesity | - | FAIL |
| 25 | cd_cardiac_rhd | cd_cardiac_ix | SKIPPED |
| 26 | cd_hep_b_sero | dmg | SKIPPED |
| 27 | cd_hepb_coded | - | FAIL |
| 28 | rx_av_nrti | - | FAIL |
| 29 | cd_hepb_master | cd_hep_b_sero, cd_hepb_coded, rx_av_nrti | SKIPPED |
| 30 | at_risk | ckd, rrt, cd_dm_dx, cd_htn, cd_cardiac_cad, tg4100, cd_obesity, cd_cardiac_rhd, cd_hepb_master, dmg | SKIPPED |
| 31 | ckd_dense | - | FAIL |
| 32 | at_risk_dense | ckd_dense | SKIPPED |
| 33 | dmg_residency | - | FAIL |
| 34 | bi_vm | dmg_hrn, dmg_loc, dmg_residency, dmg, at_risk, ckd, ckd_access, rrt | SKIPPED |
| 35 | cd_careplan | dmg_source | SKIPPED |
| 36 | cvra | ckd, cd_dm_dx, cd_careplan, dmg_source | SKIPPED |
| 37 | cd_htn_bp_control | cvra, cd_htn, rrt | SKIPPED |
| 38 | bp_graph | rrt, cd_htn, cd_htn_bp_control | SKIPPED |
| 39 | ca_breast | - | FAIL |
| 40 | ca_careplan | - | FAIL |
| 41 | ca_crc | - | FAIL |
| 42 | ca_endometrial | - | FAIL |
| 43 | ca_lung | - | FAIL |
| 44 | ca_mets | - | FAIL |
| 45 | ca_misc | - | FAIL |
| 46 | ca_ovarian | - | FAIL |
| 47 | ca_prostate | - | FAIL |
| 48 | ca_rcc | - | FAIL |
| 49 | ca_skin_melanoma | - | FAIL |
| 50 | ca_thyroid | - | FAIL |
| 51 | ca_solid | ca_mets, ca_breast, ca_prostate, ca_rcc, ca_crc, ca_lung, ca_thyroid, ca_endometrial, ca_ovarian, ca_careplan | SKIPPED |
| 52 | cd_dyslip | cvra, dmg, cd_cardiac_cad | SKIPPED |
| 53 | cardiac_cad_card | dmg, cd_cardiac_cad, cd_dyslip | SKIPPED |
| 54 | cd_cardiac_rx | - | FAIL |
| 55 | cd_cardiac_vhd | cd_cardiac_rx, cd_cardiac_ix | SKIPPED |
| 56 | cd_cardiac_chf | cd_cardiac_ix | SKIPPED |
| 57 | cd_cardiac_af | cd_cardiac_vhd, cd_cardiac_cad, cd_cardiac_chf, cd_htn, cd_dm_dx, cd_cardiac_rx, cd_cardiac_ix | SKIPPED |
| 58 | cd_cardiac_device | - | FAIL |
| 59 | cd_cardiac_enc | - | FAIL |
| 60 | cd_cardiac_vte | - | FAIL |
| 61 | cd_cirrhosis | - | FAIL |
| 62 | cd_cns | - | FAIL |
| 63 | cd_cns_ch | - | FAIL |
| 64 | cd_cva | - | FAIL |
| 65 | cd_dm_comp | cd_dm_dx | SKIPPED |
| 66 | cd_dm_glyc_cntrl | cd_dm_dx | SKIPPED |
| 67 | cd_dm_mx | cd_dm_dx | SKIPPED |
| 68 | cd_dm_rx_rcm | cd_dm_dx, cd_obesity | SKIPPED |
| 69 | cd_endo_hypothyroid | - | FAIL |
| 70 | cd_haem | - | FAIL |
| 71 | cd_hepb | - | FAIL |
| 72 | cd_htn_card | cd_htn, cd_htn_bp_control | SKIPPED |
| 73 | cd_htn_rcm | ckd, cd_htn, cd_cardiac_cad | SKIPPED |
| 74 | cd_imm_vasculitis | - | FAIL |
| 75 | cd_pulm_copd | - | FAIL |
| 76 | cd_pulm_bt | - | FAIL |
| 77 | cd_multi_m1 | ckd, rrt, cd_dm_dx, cd_htn, cd_cardiac_cad, cd_obesity, cd_cardiac_rhd, cd_hepb, cd_cirrhosis, ca_breast, cd_pulm_copd, cd_pulm_bt | SKIPPED |
| 78 | cd_nutr_low | - | FAIL |
| 79 | cd_pulm | - | FAIL |
| 80 | cd_rheum_aps | cd_cardiac_rx | SKIPPED |
| 81 | cd_rheum_gout | - | FAIL |
| 82 | cd_rheum_ra | - | FAIL |
| 83 | cd_rheum_sle | - | FAIL |
| 84 | ckd_anaemia | ckd, rrt | SKIPPED |
| 85 | ckd_journey | rrt, ckd | SKIPPED |
| 86 | ckd_diagnostics | ckd | SKIPPED |
| 87 | tg4630 | dmg, rrt, dmg_source, cd_dm_dx, ckd | SKIPPED |
| 88 | ckd_card | ckd, rrt, ckd_egfr_metrics, ckd_uacr_metrics, ckd_journey, ckd_access, ckd_diagnostics, tg4630 | SKIPPED |
| 89 | ckd_cause | cd_dm_dx, cd_htn, ckd, rrt, cd_rheum_sle, ckd_c_gn, ckd_c_tid, ckd_c_rnm | SKIPPED |
| 90 | ckd_complications | ckd | SKIPPED |
| 91 | ckd_labs | rrt, ckd | SKIPPED |
| 92 | ipa_sep | - | PASS |
| 93 | opa_sep | - | FAIL |
| 94 | ckd_prog_vm | dmg, dmg_source, ckd, rrt, engmnt_renal, ckd_access, ckd_labs, cd_htn, cd_htn_bp_control, cd_dm_dx, cd_dm_glyc_cntrl, ckd_journey, ckd_careplan, ckd_complications, ipa_sep, opa_sep | SKIPPED |
| 95 | ckd_shpt | ckd, rrt | SKIPPED |
| 96 | ckd_ttem | - | FAIL |
| 97 | vacc_covid | - | FAIL |
| 98 | cmidx_charlson | - | FAIL |
| 99 | cm_vm | vacc_covid, cmidx_charlson, rrt, cvra, cd_cardiac_cad | SKIPPED |
| 100 | core_info_entropy | - | FAIL |
| 101 | cvra_predict1_aus | ckd, cd_dm_dx, cd_careplan, dmg_source, dmg, cd_obesity, cd_cardiac_af, cd_htn, cd_cardiac_rx | SKIPPED |
| 102 | dm_card | cd_dm_dx, cd_dm_glyc_cntrl, cd_dm_comp, cd_dm_mx | SKIPPED |
| 103 | dmg_eid_alt | - | FAIL |
| 104 | dmg_loc2 | - | FAIL |
| 105 | dmg_loc_origin | - | FAIL |
| 106 | dmg_tkcuser_interact | - | FAIL |
| 107 | ipa_icu | - | FAIL |
| 108 | pregnancy | - | FAIL |
| 109 | dmg_vm | dmg_loc, dmg_hrn, dmg_source, ipa_sep, opa_sep, ipa_icu, pregnancy | SKIPPED |
| 110 | egfr_graph2 | rrt | SKIPPED |
| 111 | egfr_metrics | - | FAIL |
| 112 | frm_func_assm | at_risk, ckd, rrt, cd_dm_dx | SKIPPED |
| 113 | global | at_risk, dmg_loc | SKIPPED |
| 114 | hb_graph | rrt | SKIPPED |
| 115 | hba1c_graph | cd_dm_dx | SKIPPED |
| 116 | id_cap | - | FAIL |
| 117 | id_covid19 | - | FAIL |
| 118 | id_hcv | - | FAIL |
| 119 | id_htlv | - | FAIL |
| 120 | id_sti | - | FAIL |
| 121 | id_tb | - | FAIL |
| 122 | id_uti | - | FAIL |
| 123 | kfre | ckd, dmg | SKIPPED |
| 124 | kpi_uncategorised | - | FAIL |
| 125 | mbs715 | dmg, rrt, ckd, cd_dm_dx, cd_htn, cd_cardiac_cad, cd_cva, cd_cardiac_rhd, cd_pulm_copd | SKIPPED |
| 126 | mbs_billing_history | - | FAIL |
| 127 | obs_vm | cd_obesity, cd_htn_bp_control | SKIPPED |
| 128 | ortho_amputation | - | FAIL |
| 129 | ortho_fractures | - | FAIL |
| 130 | pcd | ckd, cd_dm_dx, cvra | SKIPPED |
| 131 | periop_nsqip | cd_cardiac_cad, cd_cardiac_vhd, cd_htn, cd_pulm, rrt, ckd, cd_obesity, cd_nutr_low | SKIPPED |
| 132 | phos_graph | rrt | SKIPPED |
| 133 | rrt_hd_adequacy | rrt | SKIPPED |
| 134 | rrt_1_metrics | rrt | SKIPPED |
| 135 | rrt_hd_param | rrt | SKIPPED |
| 136 | rrt_1_card | rrt, rrt_hd_adequacy, rrt_1_metrics, rrt_hd_param | SKIPPED |
| 137 | rrt_assert | rrt | SKIPPED |
| 138 | rrt_hd_acc_iv | rrt, ckd_access | SKIPPED |
| 139 | rrt_hd_acc_card | rrt, rrt_hd_acc_iv | SKIPPED |
| 140 | rrt_hd_loc | - | FAIL |
| 141 | rrt_hd_location | rrt | SKIPPED |
| 142 | rrt_hd_prog_vm | dmg, dmg_source, rrt, engmnt_renal, ipa_sep, opa_sep, rrt_hd_param, cd_htn_bp_control, rrt_hd_adequacy | SKIPPED |
| 143 | rrt_journey | rrt | SKIPPED |
| 144 | rrt_labs_euc | rrt | SKIPPED |
| 145 | rrt_new3_wip | - | FAIL |
| 146 | rrt_panel_vm | rrt, rrt_hd_location, rrt_labs_euc, ckd_shpt, ckd_anaemia, rrt_hd_acc_iv, rrt_hd_param, rrt_hd_adequacy, rrt_1_metrics, rrt_hd_prog_vm, cd_htn_bp_control | SKIPPED |
| 147 | rrt_pd | - | FAIL |
| 148 | rrt_pd_card | rrt | SKIPPED |
| 149 | rrt_tx | rrt | SKIPPED |
| 150 | rx_is_sot | - | FAIL |
| 151 | rrt_tx_card | rrt, rrt_tx, rx_is_sot | SKIPPED |
| 152 | rx_cv_common | - | FAIL |
| 153 | rx_cv_lmd | - | FAIL |
| 154 | rx_desc_ptr | - | FAIL |
| 155 | rx_rrt_common | - | FAIL |
| 156 | sx_abdo | - | FAIL |
| 157 | tg2610 | dmg, dmg_source, cd_dm_dx, cd_dm_glyc_cntrl, ckd | SKIPPED |
| 158 | tg4110 | dmg, dmg_source | SKIPPED |
| 159 | tg4122 | dmg, ckd, engmnt_renal, dmg_source | SKIPPED |
| 160 | tg4123 | dmg, ckd, engmnt_renal, dmg_source | SKIPPED |
| 161 | tg4410 | dmg, dmg_source, rrt, cd_dm_dx, ckd, engmnt_renal | SKIPPED |
| 162 | tg4420 | dmg, dmg_source, rrt, engmnt_renal | SKIPPED |
| 163 | tg4610 | dmg, ckd, dmg_source, engmnt_renal | SKIPPED |
| 164 | tg4620 | dmg, ckd, ckd_egfr_metrics, engmnt_renal, dmg_source | SKIPPED |
| 165 | tg4660 | ckd, dmg, dmg_source, cd_dm_dx | SKIPPED |
| 166 | tg4720 | dmg, dmg_source | SKIPPED |
| 167 | tg4722 | dmg, dmg_source | SKIPPED |
| 168 | tg4810 | dmg, dmg_source | SKIPPED |

## Timing Breakdown

| Stage | Time (ms) |
|-------|-----------|
| Loading | 29 |
| Parsing | 8 |
| Linking | 10 |
| Transform | 0 |
| SQL Generation | 21 |
| Execution | 6059 |

---

*Generated by picorules-compiler-js-db-validator*