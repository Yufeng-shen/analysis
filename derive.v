(* mathcomp analysis (c) 2017 Inria and AIST. License: CeCILL-C.              *)
Require Import Reals.
From mathcomp Require Import ssreflect ssrfun ssrbool ssrnat eqtype choice.
From mathcomp Require Import ssralg ssrnum fintype matrix.
Require Import boolp reals.
Require Import Rstruct Rbar set posnum topology hierarchy landau.

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.
Import GRing.Theory Num.Def Num.Theory.

Local Open Scope classical_set_scope.

Section Differential.

Context {K : absRingType} {V W : normedModType K}.

Definition diff (F : filter_on V) (_ : phantom (set (set V)) F) (f : V -> W) :=
  (get (fun (df : {linear V -> W}) => continuous df /\ forall x,
      f x = f (lim F) + df (x - lim F) +o_(x \near F) (x - lim F))).
Canonical diff_linear F phF f := [linear of @diff F phF f].
Canonical diff_raddf F phF f := [additive of @diff F phF f].

Notation "''d_' F" := (@diff _ (Phantom _ [filter of F]))
  (at level 0, F at level 0, format "''d_' F").

Definition differentiable_def (F : filter_on V) (_ : phantom (set (set V)) F)
  (f : V -> W) :=
  continuous ('d_F f) /\
  f = cst (f (lim F)) + 'd_F f \o center (lim F) +o_F (center (lim F)).

Notation differentiable F := (@differentiable_def _ (Phantom _ [filter of F])).

Lemma diffP (F : filter_on V) (f : V -> W) :
  differentiable F f <->
  continuous ('d_F f) /\
  (forall x, f x = f (lim F) + 'd_F f (x - lim F) +o_(x \near F) (x - lim F)).
Proof. by rewrite /differentiable_def funeqE. Qed.

Lemma diff_continuous (F : filter_on V) (f : V -> W) :
  differentiable F f -> continuous ('d_F f).
Proof. by move=> []. Qed.

Lemma diffE (F : filter_on V) (f : V -> W) :
  differentiable F f ->
  forall x, f x = f (lim F) + 'd_F f (x - lim F) +o_(x \near F) (x - lim F).
Proof. by move=> /diffP []. Qed.

Lemma littleo_shift (y x : V) (f : V -> W) (e : V -> V) :
  littleo (locally y) (f \o shift (x - y)) (e \o shift (x - y)) ->
  littleo (locally x) f e.
Proof.
move=> fe _/posnumP[eps]; rewrite near_simpl (near_shift y).
exact: filterS (fe _ [gt0 of eps%:num]).
Qed.

Lemma littleo_center0 (x : V) (f : V -> W) (e : V -> V) :
  [o_x e of f] = [o_ (0 : V) (e \o shift x) of f \o shift x] \o center x.
Proof.
rewrite /the_littleo /insubd /=; have [g /= _ <-{f}|/asboolP Nfe] /= := insubP.
  rewrite insubT //= ?comp_shiftK //; apply/asboolP; apply: (@littleo_shift x).
  by rewrite sub0r !comp_shiftK => ?; apply: littleoP.
rewrite insubF //; apply/asboolP => fe; apply: Nfe.
by apply: (@littleo_shift 0); rewrite subr0.
Qed.

Lemma diff_locallyxP (x : V) (f : V -> W) :
  differentiable x f <-> continuous ('d_x f) /\
  forall h, f (h + x) = f x + 'd_x f h +o_(h \near 0 : V) h.
Proof.
split=> [dxf|[dfc dxf]].
  split; first exact: diff_continuous.
  apply: eqaddoEx => h; have /diffE -> := dxf.
  rewrite lim_id addrK; congr (_ + _); rewrite littleo_center0 /= addrK.
  by congr ('o); rewrite funeqE => k /=; rewrite addrK.
apply/diffP; split=> //; apply: eqaddoEx; move=> y.
rewrite lim_id -[in LHS](subrK x y) dxf; congr (_ + _).
rewrite -(comp_centerK x id) -[X in the_littleo _ _ _ X](comp_centerK x).
by rewrite -[_ (y - x)]/((_ \o (center x)) y) -littleo_center0.
Qed.

Lemma diff_locallyx (x : V) (f : V -> W) : differentiable x f ->
  forall h, f (h + x) = f x + 'd_x f h +o_(h \near 0 : V) h.
Proof. by move=> /diff_locallyxP []. Qed.

Lemma diff_locallyP (x : V) (f : V -> W) :
  differentiable x f <->
  continuous ('d_x f) /\ (f \o shift x = cst (f x) + 'd_x f +o_ (0 : V) id).
Proof. by apply: iff_trans (diff_locallyxP _ _) _; rewrite funeqE. Qed.

Lemma diff_locally (x : V) (f : V -> W) : differentiable x f ->
  (f \o shift x = cst (f x) + 'd_x f +o_ (0 : V) id).
Proof. by move=> /diff_locallyP []. Qed.

End Differential.

Notation "''d_' F" := (@diff _ _ _ _ (Phantom _ [filter of F]))
  (at level 0, F at level 0, format "''d_' F").
Notation differentiable F := (@differentiable_def _ _ _ _ (Phantom _ [filter of F])).

Section jacobian.

Definition jacobian n m (R : absRingType) (f : 'rV[R]_n.+1 -> 'rV[R]_m.+1) p :=
  lin1_mx ('d_p f).

End jacobian.

Section DifferentialR.

Context {V W : normedModType R}.

(* split in multiple bits:
- a linear map which is locally bounded is a little o of 1
- the identity is a littleo of 1
*)
Lemma differentiable_continuous (x : V) (f : V -> W) :
  differentiable x f -> {for x, continuous f}.
Proof.
move=> /diff_locallyP [dfc]; rewrite -addrA.
rewrite (littleo_bigO_eqo (cst (1 : R^o))); last first.
  apply/eqOP; exists 1 => //; rewrite /cst mul1r [`|[1 : R^o]|]absr1.
  near=> y; [rewrite ltrW //; near: y|end_near].
  by apply/locally_normP; eexists=> [|?];
    last (rewrite /= ?sub0r ?normmN; apply).
rewrite addfo; first by move=> /eqolim; rewrite flim_shift add0r.
by apply/eqolim0P; apply: (flim_trans (dfc 0)); rewrite linear0.
Qed.

Section littleo_lemmas.

Variables X Y Z : normedModType R.

Lemma normm_littleo x (f : X -> Y) : `|[ [o_(x \near x) (1 : R^o) of f x]]| = 0.
Proof.
rewrite /cst /=; set e := 'o _; apply/eqP.
have /(_  (`|[e x]|/2) _)/locally_singleton /= := littleoP [littleo of e].
rewrite pmulr_lgt0 // [`|[1 : R^o]|]normr1 mulr1 [X in X <= _]splitr.
by rewrite ger_addr pmulr_lle0 // => /implyP; case: ltrgtP; rewrite ?normm_lt0.
Qed.

Lemma littleo_lim0 (f : X -> Y) (h : _ -> Z) (x : X) :
  f @ x --> (0 : Y) -> [o_x f of h] x = 0.
Proof.
move/eqolim0P => ->.
set k := 'o _; have /(_ _ [gt0 of 1])/= := littleoP [littleo of k].
by move=> /locally_singleton; rewrite mul1r normm_littleo normm_le0 => /eqP.
Qed.

End littleo_lemmas.

Section diff_locally_converse_tentative.
(* if there exist A and B s.t. f(a + h) = A + B h + o(h) then
   f is differentiable at a, A = f(a) and B = f'(a) *)
(* this is a consequence of diff_continuous and eqolim0 *)
(* indeed the differential beeing b *: idfun is locally bounded *)
(* and thus a littleo of 1, and so is id *)
(* This can be generalized to any dimension *)
Lemma diff_locally_converse_part1 (f : R^o -> R^o) (a b : R^o) (x : R^o) :
  f \o shift x = cst a + b *: idfun +o_ (0 : R^o) id -> f x = a.
Proof.
rewrite funeqE => /(_ 0) /=; rewrite add0r => ->.
by rewrite -[LHS]/(_ 0 + _ 0 + _ 0) /cst [X in a + X]scaler0 littleo_lim0 ?addr0.
Qed.

End diff_locally_converse_tentative.

Definition derive (f : V -> W) a v :=
  lim ((fun h => h^-1 *: ((f \o shift a) (h *: v) - f a)) @ locally' (0 : R^o)).

Lemma deriveE (f : V -> W) (a v : V) :
  differentiable a f -> derive f a v = 'd_a f v.
Proof.
rewrite /derive /jacobian => /diff_locally -> /=; set k := 'o _.
evar (g : R -> W); rewrite [X in X @ _](_ : _ = g) /=; last first.
  rewrite funeqE=> h; rewrite !scalerDr scalerN /cst /=.
  by rewrite addrC !addrA addNr add0r linearZ /= scalerA /g.
Admitted.

End DifferentialR.

Section DifferentialR2.
Implicit Type (V : normedModType R).

Lemma derivemxE m n (f : 'rV[R]_m.+1 -> 'rV[R]_n.+1) (a v : 'rV[R]_m.+1) :
  differentiable a f -> derive f a v = v *m jacobian f a.
Proof. by move=> /deriveE->; rewrite /jacobian mul_rV_lin1. Qed.

Definition derive1 V (f : R -> V) (a : R) :=
   lim ((fun h => h^-1 *: (f (h + a) - f a)) @ locally' (0 : R^o)).

Lemma derive1E V (f : R -> V) a : derive1 f a = derive (f : R^o -> _) a 1.
Proof.
rewrite /derive1 /derive; set d := (fun _ : R => _); set d' := (fun _ : R => _).
by suff -> : d = d' by []; rewrite funeqE=> h; rewrite /d /d' /= [h%:A](mulr1).
Qed.

(* Is it necessary? *)
Lemma derive1E' V f a : differentiable a (f : R^o -> V) ->
  derive1 f a = 'd_a f 1.
Proof. by move=> ?; rewrite derive1E deriveE. Qed.

End DifferentialR2.

Section DifferentialR3.

Variables (V W : normedModType R).

Lemma ler0P (R : realFieldType) (x : R) :
  reflect (forall e, e > 0 -> x <= e) (x <= 0).
Proof.
apply: (iffP idP) => [lex0 e egt0|lex0].
  by apply: ler_trans lex0 _; apply: ltrW.
case: (lerP x 0) => // lt0x.
have /midf_lt [_] := lt0x; rewrite ltrNge -eqbF_neg => /eqP<-.
by rewrite add0r; apply: lex0; rewrite -[x]/((PosNum lt0x)%:num).
Qed.

Lemma littleo_linear0 (f : {linear V -> W}) (x : V) :
  [o_x (center x) of f \o center x] = cst 0.
Proof.
rewrite littleo_center0 comp_centerK (comp_centerK x id).
suff -> : [o_ (0 : V) id of f] = cst 0 by [].
rewrite /the_littleo /insubd; case: (insubP _) => // _ /asboolP lino -> {x}.
rewrite /littleo in lino.
suff f0 : forall e, e > 0 -> forall x, `|[x]| > 0 -> `|[f x]| <= e * `|[x]|.
  rewrite funeqE => x; apply/eqP; rewrite -normm_le0.
  case: (lerP `|[x]| 0) => [|xn0].
    by rewrite !normm_le0 => /eqP ->; rewrite linear0.
  rewrite -(mul0r `|[x]|) -ler_pdivr_mulr //; apply/ler0P => e egt0.
  by rewrite ler_pdivr_mulr //; apply: f0.
move=> _ /posnumP[e] x xn0.
have /lino /locallyP [_ /posnumP[d] dfe] := posnum_gt0 e.
set k := ((d%:num / 2) / (PosNum xn0)%:num)^-1.
rewrite -[x in X in X <= _](@scalerKV _ _ k) // linearZZ.
apply: ler_trans (ler_normmZ _ _) _; rewrite -ler_pdivl_mull; last first.
  by rewrite absRE ger0_norm.
suff /dfe /ler_trans : ball 0 d%:num (k^-1 *: x).
  apply.
  rewrite -ler_pdivl_mull // mulrA [_ / _]mulrC -mulrA [_ * (e%:num * _)]mulrA.
  rewrite mulVf // mul1r.
  by apply: ler_trans (ler_normmZ _ _) _; rewrite !absRE normfV.
rewrite -ball_normE /ball_ normmB subr0 invrK.
apply: ler_lt_trans (ler_normmZ _ _) _; rewrite -ltr_pdivl_mulr //.
rewrite absRE ger0_norm // ltr_pdivr_mulr // -mulrA mulVf; last exact:lt0r_neq0.
by rewrite mulr1 [X in _ < X]splitr ltr_addl.
Qed.

Lemma diff_unique (f : V -> W) (df : {linear V -> W}) x :
  continuous df -> f \o shift x = cst (f x) + df +o_ (0 : V) id ->
  'd_x f = df :> (V -> W).
Proof.
move=> dfc dxf; suff dfef' : 'd_x f \- df =o_ (0 : V) id.
  rewrite funeqE => y; apply/subr0_eq.
  rewrite -[0]/(cst 0 y) -(littleo_linear0 [linear of 'd_x f \- df] 0) center0.
  by rewrite -dfef'.
rewrite littleoE => //; apply/eq_some_oP; rewrite funeqE => y /=.
have hdf h :
  (f \o shift x = cst (f x) + h +o_ (0 : V) id) ->
  h = f \o shift x - cst (f x) +o_ (0 : V) id.
  move=> hdf; apply: eqaddoE.
  rewrite hdf -addrA addrCA [cst _ + _]addrC addrK [_ + h]addrC.
  rewrite -addrA -[LHS]addr0; congr (_ + _).
  by apply/eqP; rewrite eq_sym addrC addr_eq0 oppo.
rewrite (hdf _ dxf).
suff /diff_locally /hdf -> : differentiable x f.
  by rewrite opprD addrCA -(addrA (_ - _)) addKr oppox addox.
rewrite /differentiable_def funeqE.
apply: (@getPex _ (fun (df : {linear V -> W}) => continuous df /\
  forall y, f y = f (lim x) + df (y - lim x) +o_(y \near x) (y - lim x))).
exists df; split=> //; apply: eqaddoEx => z.
rewrite (hdf _ dxf) !addrA lim_id /funcomp /= subrK [f _ + _]addrC addrK.
rewrite -addrA -[LHS]addr0; congr (_ + _).
apply/eqP; rewrite eq_sym addrC addr_eq0 oppox; apply/eqP.
rewrite littleo_center0 (comp_centerK x id) -[- _ in RHS](comp_centerK x) /=.
by congr ('o).
Qed.

Let dcst (a : W) (x : V) : continuous (0 : V -> W) /\
  cst a \o shift x = cst (cst a x) + \0 +o_ (0 : V) id.
Proof.
split; first exact: continuous_cst.
apply/eqaddoE; rewrite addr0 funeqE => ? /=; rewrite -[LHS]addr0; congr (_ + _).
by rewrite littleoE; last exact: littleo0_subproof.
Qed.

Lemma diff_cst a x : ('d_x (cst a) : V -> W) = 0.
Proof. by apply/diff_unique; have [] := dcst a x. Qed.

Lemma differentiable_cst (a : W) (x : V) : differentiable x (cst a).
Proof. by apply/diff_locallyP; rewrite diff_cst; have := dcst a x. Qed.

Let dadd (f g : V -> W) x :
  differentiable x f -> differentiable x g ->
  continuous ('d_x f \+ 'd_x g) /\
  (f + g) \o shift x = cst ((f + g) x) + ('d_x f \+ 'd_x g) +o_ (0 : V) id.
Proof.
move=> df dg; split.
  have /diff_continuous df_cont := df; have /diff_continuous dg_cont := dg.
  by move=> ?; apply: continuousD (df_cont _) (dg_cont _).
apply/eqaddoE; rewrite funeqE => y /=.
have /diff_locallyx dfx := df; have /diff_locallyx dgx := dg.
rewrite -[(f + g) _]/(_ + _) dfx dgx.
by rewrite addrA [_ + (g _ + _)]addrAC -addrA addox addrA addrACA addrA.
Qed.

Lemma diffD (f g : V -> W) x :
  differentiable x f -> differentiable x g ->
  'd_x (f + g) = 'd_x f \+ 'd_x g :> (V -> W).
Proof. by move=> df dg; apply/diff_unique; have [] := dadd df dg. Qed.

Lemma differentiableD (f g : V -> W) x :
  differentiable x f -> differentiable x g -> differentiable x (f + g).
Proof.
by move=> df dg; apply/diff_locallyP; rewrite diffD //; have := dadd df dg.
Qed.

Let dopp (f : V -> W) x :
  differentiable x f -> continuous (- ('d_x f : V -> W)) /\
  (- f) \o shift x = cst (- f x) \- 'd_x f +o_ (0 : V) id.
Proof.
move=> df; split.
  by move=> ?; apply: continuousN; apply: diff_continuous.
apply/eqaddoE; rewrite funeqE => y /=; have /diff_locallyx dfx := df.
by rewrite -[(- f) _]/(- (_ _)) dfx !opprD oppox.
Qed.

Lemma diffN (f : V -> W) x :
  differentiable x f -> 'd_x (- f) = - ('d_x f : V -> W) :> (V -> W).
Proof.
move=> df; have linB : linear (- ('d_x f : V -> W)).
  move=> k p q; rewrite -![(- _ : V -> W) _]/(- (_ _)) linearPZ.
  by rewrite !scalerN opprD.
have -> : - ('d_x f : V -> W) = Linear linB by [].
by apply/diff_unique; have [] := dopp df.
Qed.

Lemma differentiableN (f : V -> W) x :
  differentiable x f -> differentiable x (- f).
Proof.
by move=> df; apply/diff_locallyP; rewrite diffN //; have := dopp df.
Qed.

Lemma diffB (f g : V -> W) x :
  differentiable x f -> differentiable x g ->
  'd_x (f - g) = 'd_x f \- 'd_x g :> (V -> W).
Proof.
move=> df dg; have dNg := differentiableN dg.
by rewrite [LHS]diffD // [X in _ \+ X]diffN.
Qed.

Lemma differentiableB (f g : V -> W) x :
  differentiable x f -> differentiable x g -> differentiable x (f \- g).
Proof. by move=> df dg; apply: differentiableD (differentiableN _). Qed.

Let dscale (f : V -> W) k x :
  differentiable x f -> continuous (k \*: 'd_x f) /\
  (k *: f) \o shift x = cst ((k *: f) x) + k \*: 'd_x f +o_ (0 : V) id.
Proof.
move=> df; split.
  by move=> ?; apply: continuousZ; apply: diff_continuous.
apply/eqaddoE; rewrite funeqE => y /=; have /diff_locallyx dfx := df.
by rewrite -[(k *: f) _]/(_ *: _) dfx !scalerDr scaleox.
Qed.

Lemma diffZ (f : V -> W) k x :
  differentiable x f -> 'd_x (k *: f) = k \*: 'd_x f :> (V -> W).
Proof. by move=> df; apply/diff_unique; have [] := dscale k df. Qed.

Lemma differentiableZ (f : V -> W) k x :
  differentiable x f -> differentiable x (k *: f).
Proof.
by move=> df; apply/diff_locallyP; rewrite diffZ //; have := dscale k df.
Qed.

Let dlin (f : {linear V -> W}) x :
  continuous f -> f \o shift x = cst (f x) + f +o_ (0 : V) id.
Proof.
move=> df; apply: eqaddoE; rewrite funeqE => y /=.
rewrite linearD addrC -[LHS]addr0; congr (_ + _).
by rewrite littleoE; last exact: littleo0_subproof.
Qed.

Lemma diff_lin (f : {linear V -> W}) x : continuous f -> 'd_x f = f :> (V -> W).
Proof. by move=> fcont; apply/diff_unique => //; apply: dlin. Qed.

Lemma linear_differentiable (f : {linear V -> W}) x :
  continuous f -> differentiable x f.
Proof.
by move=> fcont; apply/diff_locallyP; rewrite diff_lin //; have := dlin x fcont.
Qed.

End DifferentialR3.

Lemma linear_lipschitz (V W : normedModType R) (f : {linear V -> W}) :
  continuous f -> exists2 k, k > 0 & forall x, `|[f x]| <= k * `|[x]|.
Proof.
move=> /(_ 0); rewrite linear0 => /(_ _ (locally_ball 0 1%:pos)).
move=> /locallyP [_ /posnumP[e] he]; exists (2 / e%:num) => // x.
case: (lerP `|[x]| 0) => [|xn0].
  by rewrite normm_le0 => /eqP->; rewrite linear0 !normm0 mulr0.
rewrite -[`|[x]|]/((PosNum xn0)%:num).
set k := 2 / e%:num * (PosNum xn0)%:num.
have kn0 : k != 0 by apply/lt0r_neq0.
have abskgt0 : `|k| > 0 by rewrite ltr_def absr_ge0 absr_eq0 kn0.
rewrite -[x in X in X <= _](scalerKV kn0) linearZZ.
apply: ler_trans (ler_normmZ _ _) _; rewrite -ler_pdivl_mull //.
suff /he : ball 0 e%:num (k^-1 *: x).
  rewrite -ball_normE /= normmB subr0 => /ltrW /ler_trans; apply.
  by rewrite absRE ger0_norm // mulVf.
rewrite -ball_normE /= normmB subr0; apply: ler_lt_trans (ler_normmZ _ _) _.
rewrite absRE normfV ger0_norm // invrM ?unitfE // mulrAC mulVf //.
by rewrite invf_div mul1r [X in _ < X]splitr; apply: ltr_spaddr.
Qed.

Lemma linear_eqO (V W : normedModType R) (f : {linear V -> W}) :
  continuous f -> (f : V -> W) =O_ (0 : V) id.
Proof.
move=> /linear_lipschitz [k kgt0 flip]; apply/eqOP; exists k => //.
exact: filterS filterT.
Qed.

(* TODO: generalize *)
Lemma compoO_eqo (K : absRingType) (U V W : normedModType K) (f : U -> V)
  (g : V -> W) :
  [o_ (0 : V) id of g] \o [O_ (0 : U) id of f] =o_ (0 : U) id.
Proof.
apply/eqoP => _ /posnumP[e].
have /eqO_bigO [_ /posnumP[k]] : [O_ (0 : U) id of f] =O_ (0 : U) id by [].
have /eq_some_oP : [o_ (0 : V) id of g] =o_ (0 : V) id by [].
move=>  /(_ (e%:num / k%:num)) /(_ _) /locallyP [//|_ /posnumP[d] hd].
apply: filter_app; near=> x.
  move=> leOxkx; apply: ler_trans (hd _ _) _; last first.
    rewrite -ler_pdivl_mull //; apply: ler_trans leOxkx _.
    by rewrite invf_div mulrA -[_ / _ * _]mulrA mulVf // mulr1.
  rewrite -ball_normE /= normmB subr0; apply: ler_lt_trans leOxkx _.
  by rewrite -ltr_pdivl_mull //; near: x.
end_near; rewrite /= locally_simpl.
apply/locallyP; exists (k%:num ^-1 * d%:num)=> // x.
by rewrite -ball_normE /= normmB subr0.
Qed.

(* TODO: generalize *)
Lemma compOo_eqo (K : absRingType) (U V W : normedModType K) (f : U -> V)
  (g : V -> W) :
  [O_ (0 : V) id of g] \o [o_ (0 : U) id of f] =o_ (0 : U) id.
Proof.
apply/eqoP => _ /posnumP[e].
have /eqO_bigO [_ /posnumP[k]] : [O_ (0 : V) id of g] =O_ (0 : V) id by [].
move=> /locallyP [_ /posnumP[d] hd].
have /eq_some_oP : [o_ (0 : U) id of f] =o_ (0 : U) id by [].
have ekgt0 : e%:num / k%:num > 0 by [].
move=> /(_ _ ekgt0); apply: filter_app; near=> x.
  move=> leoxekx; apply: ler_trans (hd _ _) _; last first.
    by rewrite -ler_pdivl_mull // mulrA [_^-1 * _]mulrC.
  rewrite -ball_normE /= normmB subr0; apply: ler_lt_trans leoxekx _.
  by rewrite -ltr_pdivl_mull //; near: x.
end_near; rewrite /= locally_simpl.
apply/locallyP; exists ((e%:num / k%:num) ^-1 * d%:num)=> // x.
by rewrite -ball_normE /= normmB subr0.
Qed.

Let dcomp (U V W : normedModType R) (f : U -> V) (g : V -> W) x :
  differentiable x f -> differentiable (f x) g ->
  continuous ('d_(f x) g \o 'd_x f) /\
  g \o f \o shift x = cst ((g \o f) x) + ('d_(f x) g \o 'd_x f) +o_ (0 : U) id.
Proof.
move=> df dg; split.
  by move=> ?; apply: continuous_comp; apply: diff_continuous.
apply/eqaddoE; rewrite funeqE => y /=; have /diff_locallyx -> := df.
rewrite -addrA addrC; have /diff_locallyx -> := dg.
rewrite linearD addrA -addrA; congr (_ + _).
rewrite linear_eqO; last exact: diff_continuous.
rewrite (@linear_eqO _ _ ('d_x f)); last exact: diff_continuous.
rewrite {2}eqoO addOx -[X in _ + X]/((_ \o _) y) compoO_eqo.
by rewrite -[X in X + _]/((_ \o _) y) compOo_eqo addox.
Qed.

Lemma diff_comp (U V W : normedModType R) (f : U -> V) (g : V -> W) x :
  differentiable x f -> differentiable (f x) g ->
  'd_x (g \o f) = 'd_(f x) g \o 'd_x f :> (U -> W).
Proof. by move=> df dg; apply/diff_unique; have [] := dcomp df dg. Qed.

Lemma differentiable_comp (U V W : normedModType R) (f : U -> V) (g : V -> W)
  x : differentiable x f -> differentiable (f x) g -> differentiable x (g \o f).
Proof.
by move=> df dg; apply/diff_locallyP; rewrite diff_comp //; have := dcomp df dg.
Qed.