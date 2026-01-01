import type { RuleblockInput } from 'picorules-compiler-js-core';

/**
 * Sample ruleblocks for database validation testing
 * These ruleblocks use simplified EADV data that can be easily set up in test databases
 */

export const basicRuleblocks: RuleblockInput[] = [
  {
    name: 'basic_test',
    text: `
      lab_count => eadv.lab_result.val.count();
      lab_last => eadv.lab_result.val.last();
    `,
    isActive: true,
  },
];

export const aggregationRuleblocks: RuleblockInput[] = [
  {
    name: 'aggregation_test',
    text: `
      result_sum => eadv.lab_result.val.sum();
      result_avg => eadv.lab_result.val.avg();
      result_min => eadv.lab_result.val.min();
      result_max => eadv.lab_result.val.max();
      result_count => eadv.lab_result.val.count();
      result_distinct => eadv.lab_result.val.distinct_count();
    `,
    isActive: true,
  },
];

export const windowRuleblocks: RuleblockInput[] = [
  {
    name: 'window_test',
    text: `
      result_first => eadv.lab_result.val.first();
      result_last => eadv.lab_result.val.last();
      result_2nd => eadv.lab_result.val.nth(2);
      result_lastdv => eadv.lab_result._.lastdv();
      result_firstdv => eadv.lab_result._.firstdv();
    `,
    isActive: true,
  },
];

export const computeRuleblocks: RuleblockInput[] = [
  {
    name: 'compute_test',
    text: `
      result_last => eadv.lab_result.val.last();
      is_high : {result_last > 100 => 1}, {=> 0};
      category : {result_last < 50 => 1}, {result_last < 100 => 2}, {=> 3};
    `,
    isActive: true,
  },
];

export const crossReferenceRuleblocks: RuleblockInput[] = [
  {
    name: 'base_data',
    text: `
      lab_last => eadv.lab_result.val.last();
      lab_count => eadv.lab_result.val.count();
    `,
    isActive: true,
  },
  {
    name: 'derived_data',
    text: `
      previous_value => rout_base_data.lab_last.val.bind();
      previous_count => rout_base_data.lab_count.val.bind();
      has_data : {previous_count > 0 => 1}, {=> 0};
    `,
    isActive: true,
  },
];

export const stringRuleblocks: RuleblockInput[] = [
  {
    name: 'string_test',
    text: `
      result_serialize => eadv.lab_result.val.serialize(',');
      result_serializedv => eadv.lab_result._.serializedv('|');
    `,
    isActive: true,
  },
];

export const existsRuleblocks: RuleblockInput[] = [
  {
    name: 'exists_test',
    text: `
      has_lab => eadv.lab_result.val.exists();
      has_vital => eadv.vital_sign.val.exists();
    `,
    isActive: true,
  },
];

export const statisticalRuleblocks: RuleblockInput[] = [
  {
    name: 'stats_test',
    text: `
      slope => eadv.lab_result.val.regr_slope();
      intercept => eadv.lab_result.val.regr_intercept();
      r2 => eadv.lab_result.val.regr_r2();
    `,
    isActive: true,
  },
];

export const medianRuleblocks: RuleblockInput[] = [
  {
    name: 'median_test',
    text: `
      result_median => eadv.lab_result.val.median();
    `,
    isActive: true,
  },
];

/**
 * All test suites combined
 */
export const allTestRuleblocks = {
  basic: basicRuleblocks,
  aggregation: aggregationRuleblocks,
  window: windowRuleblocks,
  compute: computeRuleblocks,
  crossReference: crossReferenceRuleblocks,
  string: stringRuleblocks,
  exists: existsRuleblocks,
  statistical: statisticalRuleblocks,
  median: medianRuleblocks,
};
