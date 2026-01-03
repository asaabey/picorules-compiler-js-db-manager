# Picorules Test Report

**Generated:** 2026-01-03T00:30:50.665Z
**Dialect:** postgresql
**Mode:** Compilation Only

## Summary

| Metric | Value |
|--------|-------|
| Total .prb files | 168 |
| Loaded successfully | 168 |
| Load errors | 0 |
| Load time | 26ms |

| Compilation | SUCCESS |
| SQL statements generated | 168 |
| Compilation time | 33ms |


## Execution Order

Ruleblocks in topological order (dependencies first):

| Order | Ruleblock | Dependencies | Status |
|-------|-----------|--------------|--------|
| 1 | rrt | - | NOT EXECUTED |
| 2 | acr_graph | rrt | NOT EXECUTED |
| 3 | acr_metrics | - | NOT EXECUTED |
| 4 | dmg | - | NOT EXECUTED |
| 5 | ckd_egfr_metrics | - | NOT EXECUTED |
| 6 | ckd_uacr_metrics | - | NOT EXECUTED |
| 7 | ckd_c_gn | - | NOT EXECUTED |
| 8 | ckd_c_tid | - | NOT EXECUTED |
| 9 | ckd_c_rnm | - | NOT EXECUTED |
| 10 | dmg_loc | - | NOT EXECUTED |
| 11 | dmg_hrn | - | NOT EXECUTED |
| 12 | dmg_source | rrt, dmg_loc, dmg_hrn | NOT EXECUTED |
| 13 | ckd_careplan | dmg_source | NOT EXECUTED |
| 14 | ckd_coded_dx | - | NOT EXECUTED |
| 15 | engmnt_renal | - | NOT EXECUTED |
| 16 | ckd_access | - | NOT EXECUTED |
| 17 | ckd | rrt, ckd_egfr_metrics, ckd_uacr_metrics, ckd_c_gn, ckd_c_tid, ckd_c_rnm, ckd_careplan, ckd_coded_dx, engmnt_renal, ckd_access | NOT EXECUTED |
| 18 | tg4100 | dmg, rrt, ckd, dmg_source | NOT EXECUTED |
| 19 | ad_aki | tg4100 | NOT EXECUTED |
| 20 | cd_dm_dx | - | NOT EXECUTED |
| 21 | cd_htn | - | NOT EXECUTED |
| 22 | cd_cardiac_ix | - | NOT EXECUTED |
| 23 | cd_cardiac_cad | cd_cardiac_ix | NOT EXECUTED |
| 24 | cd_obesity | - | NOT EXECUTED |
| 25 | cd_cardiac_rhd | cd_cardiac_ix | NOT EXECUTED |
| 26 | cd_hep_b_sero | dmg | NOT EXECUTED |
| 27 | cd_hepb_coded | - | NOT EXECUTED |
| 28 | rx_av_nrti | - | NOT EXECUTED |
| 29 | cd_hepb_master | cd_hep_b_sero, cd_hepb_coded, rx_av_nrti | NOT EXECUTED |
| 30 | at_risk | ckd, rrt, cd_dm_dx, cd_htn, cd_cardiac_cad, tg4100, cd_obesity, cd_cardiac_rhd, cd_hepb_master, dmg | NOT EXECUTED |
| 31 | ckd_dense | - | NOT EXECUTED |
| 32 | at_risk_dense | ckd_dense | NOT EXECUTED |
| 33 | dmg_residency | - | NOT EXECUTED |
| 34 | bi_vm | dmg_hrn, dmg_loc, dmg_residency, dmg, at_risk, ckd, ckd_access, rrt | NOT EXECUTED |
| 35 | cd_careplan | dmg_source | NOT EXECUTED |
| 36 | cvra | ckd, cd_dm_dx, cd_careplan, dmg_source | NOT EXECUTED |
| 37 | cd_htn_bp_control | cvra, cd_htn, rrt | NOT EXECUTED |
| 38 | bp_graph | rrt, cd_htn, cd_htn_bp_control | NOT EXECUTED |
| 39 | ca_breast | - | NOT EXECUTED |
| 40 | ca_careplan | - | NOT EXECUTED |
| 41 | ca_crc | - | NOT EXECUTED |
| 42 | ca_endometrial | - | NOT EXECUTED |
| 43 | ca_lung | - | NOT EXECUTED |
| 44 | ca_mets | - | NOT EXECUTED |
| 45 | ca_misc | - | NOT EXECUTED |
| 46 | ca_ovarian | - | NOT EXECUTED |
| 47 | ca_prostate | - | NOT EXECUTED |
| 48 | ca_rcc | - | NOT EXECUTED |
| 49 | ca_skin_melanoma | - | NOT EXECUTED |
| 50 | ca_thyroid | - | NOT EXECUTED |
| 51 | ca_solid | ca_mets, ca_breast, ca_prostate, ca_rcc, ca_crc, ca_lung, ca_thyroid, ca_endometrial, ca_ovarian, ca_careplan | NOT EXECUTED |
| 52 | cd_dyslip | cvra, dmg, cd_cardiac_cad | NOT EXECUTED |
| 53 | cardiac_cad_card | dmg, cd_cardiac_cad, cd_dyslip | NOT EXECUTED |
| 54 | cd_cardiac_rx | - | NOT EXECUTED |
| 55 | cd_cardiac_vhd | cd_cardiac_rx, cd_cardiac_ix | NOT EXECUTED |
| 56 | cd_cardiac_chf | cd_cardiac_ix | NOT EXECUTED |
| 57 | cd_cardiac_af | cd_cardiac_vhd, cd_cardiac_cad, cd_cardiac_chf, cd_htn, cd_dm_dx, cd_cardiac_rx, cd_cardiac_ix | NOT EXECUTED |
| 58 | cd_cardiac_device | - | NOT EXECUTED |
| 59 | cd_cardiac_enc | - | NOT EXECUTED |
| 60 | cd_cardiac_vte | - | NOT EXECUTED |
| 61 | cd_cirrhosis | - | NOT EXECUTED |
| 62 | cd_cns | - | NOT EXECUTED |
| 63 | cd_cns_ch | - | NOT EXECUTED |
| 64 | cd_cva | - | NOT EXECUTED |
| 65 | cd_dm_comp | cd_dm_dx | NOT EXECUTED |
| 66 | cd_dm_glyc_cntrl | cd_dm_dx | NOT EXECUTED |
| 67 | cd_dm_mx | cd_dm_dx | NOT EXECUTED |
| 68 | cd_dm_rx_rcm | cd_dm_dx, cd_obesity | NOT EXECUTED |
| 69 | cd_endo_hypothyroid | - | NOT EXECUTED |
| 70 | cd_haem | - | NOT EXECUTED |
| 71 | cd_hepb | - | NOT EXECUTED |
| 72 | cd_htn_card | cd_htn, cd_htn_bp_control | NOT EXECUTED |
| 73 | cd_htn_rcm | ckd, cd_htn, cd_cardiac_cad | NOT EXECUTED |
| 74 | cd_imm_vasculitis | - | NOT EXECUTED |
| 75 | cd_pulm_copd | - | NOT EXECUTED |
| 76 | cd_pulm_bt | - | NOT EXECUTED |
| 77 | cd_multi_m1 | ckd, rrt, cd_dm_dx, cd_htn, cd_cardiac_cad, cd_obesity, cd_cardiac_rhd, cd_hepb, cd_cirrhosis, ca_breast, cd_pulm_copd, cd_pulm_bt | NOT EXECUTED |
| 78 | cd_nutr_low | - | NOT EXECUTED |
| 79 | cd_pulm | - | NOT EXECUTED |
| 80 | cd_rheum_aps | cd_cardiac_rx | NOT EXECUTED |
| 81 | cd_rheum_gout | - | NOT EXECUTED |
| 82 | cd_rheum_ra | - | NOT EXECUTED |
| 83 | cd_rheum_sle | - | NOT EXECUTED |
| 84 | ckd_anaemia | ckd, rrt | NOT EXECUTED |
| 85 | ckd_journey | rrt, ckd | NOT EXECUTED |
| 86 | ckd_diagnostics | ckd | NOT EXECUTED |
| 87 | tg4630 | dmg, rrt, dmg_source, cd_dm_dx, ckd | NOT EXECUTED |
| 88 | ckd_card | ckd, rrt, ckd_egfr_metrics, ckd_uacr_metrics, ckd_journey, ckd_access, ckd_diagnostics, tg4630 | NOT EXECUTED |
| 89 | ckd_cause | cd_dm_dx, cd_htn, ckd, rrt, cd_rheum_sle, ckd_c_gn, ckd_c_tid, ckd_c_rnm | NOT EXECUTED |
| 90 | ckd_complications | ckd | NOT EXECUTED |
| 91 | ckd_labs | rrt, ckd | NOT EXECUTED |
| 92 | ipa_sep | - | NOT EXECUTED |
| 93 | opa_sep | - | NOT EXECUTED |
| 94 | ckd_prog_vm | dmg, dmg_source, ckd, rrt, engmnt_renal, ckd_access, ckd_labs, cd_htn, cd_htn_bp_control, cd_dm_dx, cd_dm_glyc_cntrl, ckd_journey, ckd_careplan, ckd_complications, ipa_sep, opa_sep | NOT EXECUTED |
| 95 | ckd_shpt | ckd, rrt | NOT EXECUTED |
| 96 | ckd_ttem | - | NOT EXECUTED |
| 97 | vacc_covid | - | NOT EXECUTED |
| 98 | cmidx_charlson | - | NOT EXECUTED |
| 99 | cm_vm | vacc_covid, cmidx_charlson, rrt, cvra, cd_cardiac_cad | NOT EXECUTED |
| 100 | core_info_entropy | - | NOT EXECUTED |
| 101 | cvra_predict1_aus | ckd, cd_dm_dx, cd_careplan, dmg_source, dmg, cd_obesity, cd_cardiac_af, cd_htn, cd_cardiac_rx | NOT EXECUTED |
| 102 | dm_card | cd_dm_dx, cd_dm_glyc_cntrl, cd_dm_comp, cd_dm_mx | NOT EXECUTED |
| 103 | dmg_eid_alt | - | NOT EXECUTED |
| 104 | dmg_loc2 | - | NOT EXECUTED |
| 105 | dmg_loc_origin | - | NOT EXECUTED |
| 106 | dmg_tkcuser_interact | - | NOT EXECUTED |
| 107 | ipa_icu | - | NOT EXECUTED |
| 108 | pregnancy | - | NOT EXECUTED |
| 109 | dmg_vm | dmg_loc, dmg_hrn, dmg_source, ipa_sep, opa_sep, ipa_icu, pregnancy | NOT EXECUTED |
| 110 | egfr_graph2 | rrt | NOT EXECUTED |
| 111 | egfr_metrics | - | NOT EXECUTED |
| 112 | frm_func_assm | at_risk, ckd, rrt, cd_dm_dx | NOT EXECUTED |
| 113 | global | at_risk, dmg_loc | NOT EXECUTED |
| 114 | hb_graph | rrt | NOT EXECUTED |
| 115 | hba1c_graph | cd_dm_dx | NOT EXECUTED |
| 116 | id_cap | - | NOT EXECUTED |
| 117 | id_covid19 | - | NOT EXECUTED |
| 118 | id_hcv | - | NOT EXECUTED |
| 119 | id_htlv | - | NOT EXECUTED |
| 120 | id_sti | - | NOT EXECUTED |
| 121 | id_tb | - | NOT EXECUTED |
| 122 | id_uti | - | NOT EXECUTED |
| 123 | kfre | ckd, dmg | NOT EXECUTED |
| 124 | kpi_uncategorised | - | NOT EXECUTED |
| 125 | mbs715 | dmg, rrt, ckd, cd_dm_dx, cd_htn, cd_cardiac_cad, cd_cva, cd_cardiac_rhd, cd_pulm_copd | NOT EXECUTED |
| 126 | mbs_billing_history | - | NOT EXECUTED |
| 127 | obs_vm | cd_obesity, cd_htn_bp_control | NOT EXECUTED |
| 128 | ortho_amputation | - | NOT EXECUTED |
| 129 | ortho_fractures | - | NOT EXECUTED |
| 130 | pcd | ckd, cd_dm_dx, cvra | NOT EXECUTED |
| 131 | periop_nsqip | cd_cardiac_cad, cd_cardiac_vhd, cd_htn, cd_pulm, rrt, ckd, cd_obesity, cd_nutr_low | NOT EXECUTED |
| 132 | phos_graph | rrt | NOT EXECUTED |
| 133 | rrt_hd_adequacy | rrt | NOT EXECUTED |
| 134 | rrt_1_metrics | rrt | NOT EXECUTED |
| 135 | rrt_hd_param | rrt | NOT EXECUTED |
| 136 | rrt_1_card | rrt, rrt_hd_adequacy, rrt_1_metrics, rrt_hd_param | NOT EXECUTED |
| 137 | rrt_assert | rrt | NOT EXECUTED |
| 138 | rrt_hd_acc_iv | rrt, ckd_access | NOT EXECUTED |
| 139 | rrt_hd_acc_card | rrt, rrt_hd_acc_iv | NOT EXECUTED |
| 140 | rrt_hd_loc | - | NOT EXECUTED |
| 141 | rrt_hd_location | rrt | NOT EXECUTED |
| 142 | rrt_hd_prog_vm | dmg, dmg_source, rrt, engmnt_renal, ipa_sep, opa_sep, rrt_hd_param, cd_htn_bp_control, rrt_hd_adequacy | NOT EXECUTED |
| 143 | rrt_journey | rrt | NOT EXECUTED |
| 144 | rrt_labs_euc | rrt | NOT EXECUTED |
| 145 | rrt_new3_wip | - | NOT EXECUTED |
| 146 | rrt_panel_vm | rrt, rrt_hd_location, rrt_labs_euc, ckd_shpt, ckd_anaemia, rrt_hd_acc_iv, rrt_hd_param, rrt_hd_adequacy, rrt_1_metrics, rrt_hd_prog_vm, cd_htn_bp_control | NOT EXECUTED |
| 147 | rrt_pd | - | NOT EXECUTED |
| 148 | rrt_pd_card | rrt | NOT EXECUTED |
| 149 | rrt_tx | rrt | NOT EXECUTED |
| 150 | rx_is_sot | - | NOT EXECUTED |
| 151 | rrt_tx_card | rrt, rrt_tx, rx_is_sot | NOT EXECUTED |
| 152 | rx_cv_common | - | NOT EXECUTED |
| 153 | rx_cv_lmd | - | NOT EXECUTED |
| 154 | rx_desc_ptr | - | NOT EXECUTED |
| 155 | rx_rrt_common | - | NOT EXECUTED |
| 156 | sx_abdo | - | NOT EXECUTED |
| 157 | tg2610 | dmg, dmg_source, cd_dm_dx, cd_dm_glyc_cntrl, ckd | NOT EXECUTED |
| 158 | tg4110 | dmg, dmg_source | NOT EXECUTED |
| 159 | tg4122 | dmg, ckd, engmnt_renal, dmg_source | NOT EXECUTED |
| 160 | tg4123 | dmg, ckd, engmnt_renal, dmg_source | NOT EXECUTED |
| 161 | tg4410 | dmg, dmg_source, rrt, cd_dm_dx, ckd, engmnt_renal | NOT EXECUTED |
| 162 | tg4420 | dmg, dmg_source, rrt, engmnt_renal | NOT EXECUTED |
| 163 | tg4610 | dmg, ckd, dmg_source, engmnt_renal | NOT EXECUTED |
| 164 | tg4620 | dmg, ckd, ckd_egfr_metrics, engmnt_renal, dmg_source | NOT EXECUTED |
| 165 | tg4660 | ckd, dmg, dmg_source, cd_dm_dx | NOT EXECUTED |
| 166 | tg4720 | dmg, dmg_source | NOT EXECUTED |
| 167 | tg4722 | dmg, dmg_source | NOT EXECUTED |
| 168 | tg4810 | dmg, dmg_source | NOT EXECUTED |

## Timing Breakdown

| Stage | Time (ms) |
|-------|-----------|
| Loading | 26 |
| Parsing | 7 |
| Linking | 8 |
| Transform | 0 |
| SQL Generation | 16 |

---

*Generated by picorules-compiler-js-db-validator*