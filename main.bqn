⟨⟨red, yellow, green, white, black⟩⇐color, raylib⟩←r←•Import "../rayed-bqn/rayed.bqn"

tileSize ← 3
dims ← tileSize‿tileSize
nsize ← ×´ dims

clock ← r.StartClock@
MkData ← •rand.Range˜
activations ← 1+⥊⟜(MkData+´) dims
weight ← 1+⥊⟜(MkData+´) dims
weight2 ← 1+⥊⟜(MkData+´) dims
MatMul ← {activations𝕊weight: activations +˝∘×⎉1‿∞ weight}

rdCy ← (2×tileSize)-1
outCy ← tileSize + (tileSize - 1) + tileSize
MkActTs ← {𝕊activations:
    a1 ← ⌽˘(⍉activations)
    a2 ← ((tileSize - 1) + outCy) ↑˘ a1
    a3 ←  (tileSize+↕tileSize)⌽˘a2
    a3
}


lt_mat ← ≥⌜˜↕tileSize
ut_mat ← ¬lt_mat
ls_mat ← (<˘(lt_mat∾ut_mat))
zs_mat ← (outCy - (≠ls_mat))↑(<(tileSize⥊0))
ts_mat ← ls_mat ∾ zs_mat
ts_mat2 ← (⌽⟜ts_mat)˘ (¯1×↕tileSize)
ts_mat3 ← ∾˝>≍˘⍉ts_mat2

MkLinkData ← {w𝕊a3:
    t ← tileSize
    a3_ts ← t‿t↕a3
    zs ← t‿(t-1)⥊0
    zas ← a3∾˘zs
    zst ← t‿t↕zas
    zst1 ← ⌽∾˝zst
    zmul ← (w⊸×)˘ zst1
    zmul2 ← t↕zmul
    SumDown ← {𝕊𝕩:
        tt ← (⌽↕t)
        tres ← (tt {(»⍟𝕨)⎉2 𝕩}˘ 𝕩)
        (t-1)⊸↓⎉2>tres
    }
    res ← SumDown˘ zmul2
    res2 ← ∾˝˘res
    link_data ← +`˘res2
    link_ex ← outCy↑link_data
    link_ex1 ← ∾≍(<˘link_ex)
    link_ex2 ← (¯1×t×(↕t)) ⌽˘ link_ex1
    link_ex3 ← ⍉˘outCy‿t‿t⥊⍉link_ex2
    link_ex4 ← (t-1)⌽¯1⊏˘ link_ex3
    (¯1⌽link_ex3)‿(⌽˘⍉link_ex4)
}


spacing ← 0
min_y ← 20
max_x ← 20
rec ← 20
out_start ← (min_y)‿(max_x + (3 × spacing))
out_wid ← 2×rec
out_spacing ← (out_wid‿out_wid)
MkGridPts ← {(⌽⎉1) (𝕩⊸+˘out_wid×>⥊↕dims)}
out_tl ← MkGridPts out_start
MkGridLines ← (∾⟜out_spacing)˘
act_lines ← MkGridLines out_tl
NextLines ← {𝕨𝕊𝕩:
          max_x ← ⌈˝⌈˝𝕩
          min_x ← ⌊˝⊑˘𝕩
          diff_x ← max_x - min_x
          out ← (⊑diff_x + 𝕨)‿0‿0‿0⊸+˘ 𝕩
}
x_spacing ← 3×rec
w_lines ← x_spacing NextLines act_lines
out_lines ← x_spacing NextLines w_lines
DrawRectangleLines ← {r‿g‿b‿a𝕊x‿y‿wx‿wy:
raylib.DrawRectangleLines⟨x, y, wx, wy, r‿g‿b‿a⟩
}⎉1‿2

sys_x‿sys_y ← 40‿40
sys_interleave ← {
    bxs ← sys_x⊸×(×´ dims)⥊↕tileSize
    bys ← sys_y⊸×(⥊tileSize⥊˘↕tileSize)
    out ← bxs ∾˘ bys
    out2 ← 4↑˘out
}
# FIXME: This offset should be derived from max_y in expected out
spOffX‿spOffY ← 150‿170
sys_w_lines ← (sys_interleave + (spOffX‿spOffY‿0‿0⊸+˘ w_lines))
MkTxt ← {𝕨𝕊𝕩:
    sys_w_start ← 2↑˘𝕩
    sys_w_txt_pos ← ((out_wid‿out_wid)÷2)⊸+˘ sys_w_start
    (<˘ sys_w_txt_pos) ∾˘ (•Fmt¨ ⥊𝕨)
}

sys_w_txt ← weight MkTxt sys_w_lines
fontSize ← 20

sys_act_lines ← (sys_interleave + (0‿spOffY‿0‿0⊸+˘ act_lines))
right ← [1, 0]
down ← [0, 1]
up ← ¯1×down
left ← ¯1×right
MkLinks ← {𝕊𝕩:
    out_st ← 2↑˘𝕩
    up_st ← (right × rec)⊸+˘ out_st
    down_st ← (down × out_wid)⊸+˘ up_st
    left_st ← (down × rec)⊸+˘ out_st
    right_st ← (right × out_wid)⊸+˘ left_st
    ExtendLink ← {𝕨𝕊𝕩:((⊣≍((⊑𝕨) × out_wid)⊸+)˜)˘ (⊑𝕩)}
    up‿down‿right‿left ExtendLink˘ up_st‿down_st‿right_st‿left_st
}

out_l1 ← MkLinks sys_w_lines
ProcessLinks ← {𝕊out:
  numel ← ×´(¯2↓≢out)
  numel‿2‿2⥊out
}
links1 ← ProcessLinks out_l1
up_l1‿down_l1‿left_l1‿right_l1 ← <˘ out_l1
down_mid1 ← ÷⟜2˘+˝˘ down_l1

act_ts ← (MkActTs activations)
sys_act_ts ← (⌽⎉3(∾˝((tileSize‿tileSize)↕act_ts)))

expectedOut ← activations MatMul weight
expectedOut2 ← expectedOut MatMul weight2
link_ts‿linkData ← weight MkLinkData act_ts
ProcessOut ← {𝕊𝕩:
  lz ← (tileSize‿(tileSize - 1))⥊0
  lz∾˘𝕩
}
linkOut ← ProcessOut linkData
link_ts2‿linkData2 ← weight2 MkLinkData linkOut

secs_per_step ← 3
duration ← outCy × secs_per_step
PerFrame ← {𝕤
    elapsedSecs ← ⌈clock.Time@
    secs_idx ←  duration | elapsedSecs
    step_idx ← ⌊(secs_idx ÷ secs_per_step)
    link1_data ← step_idx ⊏ link_ts
    font ← r.font.LoadRaylib@
    {white DrawRectangleLines 𝕩}˘ act_lines
    {white DrawRectangleLines 𝕩}˘ w_lines
    {white DrawRectangleLines 𝕩}˘ out_lines
    {white DrawRectangleLines 𝕩}˘ sys_w_lines
    {white‿font‿fontSize r.draw.Text 𝕩}˘ sys_w_txt
    {white DrawRectangleLines 𝕩}˘ sys_act_lines
    sys_a_txt ← (step_idx ⊏ sys_act_ts) MkTxt sys_act_lines
    {white‿font‿fontSize r.draw.Text 𝕩}˘ sys_a_txt
    color1 ← >(⊑⟜white‿green)¨ ((0⊸≠)¨ ⥊link1_data)
    color1 {𝕨‿font‿fontSize r.draw.Text 𝕩}˘ ((<˘down_mid1) ∾˘ (•Fmt ¨(⥊link1_data)))
    {white r.draw.Line 𝕩}˘ links1
} r.draw._withCanvas⟜black

PerFrame•_While_(¬r.window.ShouldClose) r.window._openAs "DistGEMM"
