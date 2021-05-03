# Changelog (unreleased)

## [Unreleased]

### Added
 
- in `ereal.v`:
  + lemmas `big_nat_widenl`, `big_geq_mkord`
  + lemmas `lee_sum_nneg_natr`, `lee_sum_nneg_natl`
  + lemmas `ereal_sup_gt`, `ereal_inf_lt`
- in `sequences.v`:
  + notations `\sum_(i <oo) F i`
  + lemmas `ereal_pseries_sum_nat`, `lte_lim`
  + lemmas `is_cvg_ereal_nneg_natsum_cond`, `is_cvg_ereal_nneg_natsum`
  + lemma `ereal_pseriesD`, `ereal_pseries0`, `eq_ereal_pseries`
- in `classical_sets.v`
  + lemma `subset_bigsetU_cond`
  + lemma `eq_imagel`
- in `measure.v`:
  + lemma `eq_bigcupB_of_bigsetU`
  + definitions `caratheodory_type`
  + definition `caratheodory_measure` and lemma `caratheodory_measure_complete`
  + internal definitions and lemmas that may be deprecated and hidden in the future:
    * `caratheodory_measurable`, notation `... .-measurable`,
    * `le_caratheodory_measurable`, `outer_measure_bigcup_lim`,
      `caratheodory_measurable_{set0,setC,setU_le,setU,bigsetU,setI,setD}`
      `disjoint_caratheodoryIU`, `caratheodory_additive`,
          `caratheodory_lim_lee`, `caratheodory_measurable_trivIset_bigcup`,
      `caratheodory_measurable_bigcup`
- file `csum.v`:
  + lemmas `ereal_pseries_pred0`, `ub_ereal_sup_adherent_img`
  + definition `fsets`, lemmas `fsets_set0`, `fsets_self`, `fsetsP`, `fsets_img`
  + definition `fsets_ord`, lemmas `fsets_ord_nat`, `fsets_ord_subset`
  + definition `csum`, lemmas `csum0`, `csumE`, `csum_ge0`, `csum_fset`
    `csum_image`, `ereal_pseries_csum`, `csum_bigcup`
  + notation `\csum_(i in S) a i`
  + definition `gsum`, lemmas `gsum0`, `gsumE`, `gsum_ge0`, `gsum_fset`
    `gsum_image`, `gsum_nat_lim`, `gsum_bigcup`
  + notation `\gsum_(i in S) a i`
  + lemma `ub_ereal_sup_adherent2`
  + definition `csum`, lemmas `csum0`, `csum_ge0`, `csum_fset`,
    `csum_countable`, `csum_nat_lim`, `csum_bigcup`
- file `cardinality.v`
  + lemmas `in_inj_comp`, `enum0`, `enum_recr`, `eq_set0_nil`, `eq_set0_fset0`,
    `image_nat_maximum`, `fset_nat_maximum`
  + defintion `surjective`, lemmas `surjective_id`, `surjective_set0`,
    `surjective_image`, `surjective_image_eq0`, `surjective_comp`
  + definition `set_bijective`,
  + lemmas `inj_of_bij`, `sur_of_bij`, `set_bijective1`, `set_bijective_image`,
    `set_bijective_subset`, `set_bijective_comp`
  + definition `inverse`
  + lemmas `injective_left_inverse`, `injective_right_inverse`,
    `surjective_right_inverse`,
  + defintion `surjective`, lemmas `surjective_id`, `surjective_set0`,
    `surjective_image`, `surjective_image_eq0`, `surjective_comp`
  + definition `set_bijective`
  + definition `inverse`
  + lemmas `inj_left_inverse`, `inj_right_inverse`, `sur_right_inverse`,
  + notation `` `I_n ``
  + lemmas `II0`, `II1`, `IIn_eq0`, `II_recr`
  + lemmas `set_bijective_D1`, `pigeonhole`, `Cantor_Bernstein`
  + definition `card_le`, notation `_ #<= _`
  + lemmas `card_le_surj`, `surj_card_le`, `card_lexx`, `card_le0x`,
    `card_le_trans`, `card_le0P`, `card_le_II`
  + definition `card_eq`, notation `_ #= _`
  + lemmas `card_eq_sym`, `card_eq_trans`, `card_eq00`, `card_eqP`, `card_eqTT`,
    `card_eq_II`, `card_eq_le`, `card_eq_ge`, `card_leP`
  + lemmas `card_le_surj`, `card_lexx`, `card_le0x`, `card_le_trans`, `card_le0P`,
    `card_le_II`
  + definition `card_eq`, notation `_ #= _`
  + lemmas `card_eq_sym`, `card_eq_trans`, `card_eq00`, `card_eqP`, `card_eqTT`,
    `card_eq_II`, `card_eq_le`
  + lemma `card_leP`
  + lemma `set_bijective_inverse`
  + definition `countable`
  + lemmas `countable0`, `countable_injective`, `countable_trans`
  + definition `set_finite`
  + lemmas `set_finiteP`, `set_finite_seq`, `set_finite_countable`, `set_finite0`
  + lemma `set_finite_bijective`
  + lemmas `subset_set_finite`, `subset_card_le`
  + lemmas `injective_set_finite`, `injective_card_le`, `set_finite_preimage`
  + lemmas `surjective_set_finite`, `surjective_card_le`
  + lemmas `set_finite_diff`, `card_le_diff`
  + lemmas `set_finite_inter_set0_union`, `set_finite_inter`
  + lemmas `ex_in_D`, definitions `min_of_D`, `min_of_D_seq`, `infsub_enum`, lemmas
    `min_of_D_seqE`, `increasing_infsub_enum`, `sorted_infsub_enum`,
   `injective_infsub_enum`, `subset_infsub_enum`, `infinite_nat_subset_countable`
  + definition `enumeration`, lemmas `enumeration_id`, `enumeration_set0`.
  + lemma `ex_enum_notin`, definitions `min_of`, `minf_of_e_seq`, `smallest_of`
  + definition `enum_wo_rep`, lemmas `enum_wo_repE`, `min_of_e_seqE`,
    `smallest_of_e_notin_enum_wo_rep`, `injective_enum_wo_rep`, `surjective_enum_wo_rep`,
    `set_bijective_enum_wo_rep`, `enumration_enum_wo_rep`, `countable_enumeration`
  + lemmas `infinite_nat`, `infinite_prod_nat`, `countable_prod_nat`,
    `countably_infinite_prod_nat`
- in `measure.v`:
  + definition `measure_is_complete`
- in `ereal.v`:
  + notation `0`/`1` for `0%R%:E`/`1%R:%E` in `ereal_scope`
  + lemmas `injective_set_finite`, `injective_card_le`
  + lemmas `surjective_set_finite`, `surjective_card_le`
  + lemmas `set_finite_diff`, `card_le_diff`
  + lemmas `set_finite_inter_set0_union`, `set_finite_inter`
  + definitions `enumeration`, `enum_wo_rep`
  + lemmas `infinite_nat`, `infinite_prod_nat`

- in `sequences.v`:
  + lemmas `seriesN`, `seriesD`, `seriesZ`, `is_cvg_seriesN`, `lim_seriesN`,
    `is_cvg_seriesZ`, `lim_seriesZ`, `is_cvg_seriesD`, `lim_seriesD`,
    `is_cvg_seriesB`, `lim_seriesB`, `lim_series_le`, `lim_series_norm`
- in `classical_sets.v`:
  + lemmas `bigcup_image`, `bigcup_of_set1`
- in `boolp.v`:
  + definitions `equality_mixin_of_Type`, `choice_of_Type`
- in `measure.v`:
  + HB.mixin `AlgebraOfSets_from_RingOfSets`
  + HB.structure `AlgebraOfSets` and notation `algebraOfSetsType`
  + HB.instance `T_isAlgebraOfSets` in HB.builders `isAlgebraOfSets`
  + lemma `bigcup_set_cond`
- in `classical_sets.v`:
  + lemmas `bigcupD1`, `bigcapD1`

### Changed

- in `measure.v`:
  + generalize lemma `eq_bigcupB_of`
- in `ereal.v`, definition `adde_undef` changed to `adde_def`
  + consequently, the following lemmas changed:
    * in `ereal.v`, `adde_undefC` renamed to `adde_defC`,
      `fin_num_adde_undef` renamed to `fin_num_adde_def`
    * in `sequences.v`, `ereal_cvgD` and `ereal_limD` now use hypotheses with `adde_def`
- in `sequences.v`:
  + generalize `{in,de}creasing_seqP`, `non{in,de}creasing_seqP` from `numDomainType`
    to `porderType`
- in `measure.v`:
  + HB.mixin `Measurable_from_ringOfSets` changed to `Measurable_from_algebraOfSets`
  + HB.instance `T_isRingOfSets` becomes `T_isAlgebraOfSets` in HB.builders `isMeasurable`
  + lemma `measurableC` now applies to `algebraOfSetsType` instead of `measureableType`
- in `normedtype.v`:
  + lemma `cvg_bounded_real`
  + lemma `pseudoMetricNormedZModType_hausdorff`

### Changed

- in `normedtype.v`:
  + generalized from `normedModType` to `pseudoMetricNormedZmodType`:
    * `nbhs_le_nbhs_norm`
    * `nbhs_norm_le_nbhs`
    * `nbhs_nbhs_norm`
    * `nbhs_normP`
    * `filter_from_norm_nbhs`
    * `nbhs_normE`
    * `filter_from_normE`
    * `near_nbhs_norm`
    * `nbhs_norm_ball_norm`
    * `nbhs_ball_norm`
    * `ball_norm_dec`
    * `ball_norm_sym`
    * `ball_norm_le`
    * `cvg_distP`
    * `cvg_dist`
    * `nbhs_norm_ball`
    * `dominated_by`
    * `strictly_dominated_by`
    * `sub_dominatedl`
    * `sub_dominatedr`
    * `dominated_by1`
    * `strictly_dominated_by1`
    * `ex_dom_bound`
    * `ex_strict_dom_bound`
    * `bounded_near`
    * `boundedE`
    * `sub_boundedr`
    * `sub_boundedl`
    * `ex_bound`
    * `ex_strict_bound`
    * `ex_strict_bound_gt0`
    * `norm_hausdorff`
    * `norm_closeE`
    * `norm_close_eq`
    * `norm_cvg_unique`
    * `norm_cvg_eq`
    * `norm_lim_id`
    * `norm_cvg_lim`
    * `norm_lim_near_cst`
    * `norm_lim_cst`
    * `norm_cvgi_unique`
    * `norm_cvgi_map_lim`
    * `distm_lt_split`
    * `distm_lt_splitr`
    * `distm_lt_splitl`
    * `normm_leW`
    * `normm_lt_split`
    * `cvg_distW`
    * `continuous_cvg_dist`
    * `add_continuous`
- moved from `normedtype.v` to `reals.v`:
  + lemmas `inf_lb_strict`, `sup_ub_strict`
- moved from `sequences.v` to `reals.v`:
  + lemma `has_ub_image_norm`

### Renamed

- in `measure.v`:
  + `isRingOfSets` -> `isAlgebraOfSets`
- in `classical_sets.v`:
  + `bigcup_mkset` -> `bigcup_set`
  + `bigsetU` -> `bigcup`
  + `bigsetI` -> `bigcap`
  + `trivIset_bigUI` -> `trivIset_bigsetUI`
- in `measure.v`:
  + `B_of` -> `seqD`
  + `trivIset_B_of` -> `trivIset_seqD`
  + `UB_of` -> `setU_seqD`
  + `bigUB_of` -> `bigsetU_seqD`
  + `eq_bigsetUB_of` -> `eq_bigsetU_seqD`
  + `eq_bigcupB_of` -> `eq_bigcup_seqD`
  + `eq_bigcupB_of_bigsetU` -> `eq_bigcup_seqD_bigsetU`

### Removed

- in `nngnum.v`:
  + lemma `filter_andb`

### Infrastructure

### Misc
