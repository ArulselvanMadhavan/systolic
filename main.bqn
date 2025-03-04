⟨⟨red, yellow, green, white, black⟩⇐color, raylib⟩←r←•Import "../rayed-bqn/rayed.bqn"

tileSize ← 3
dims ← tileSize‿tileSize
nsize ← ×´ dims
clock ← r.StartClock@
MkData ← •rand.Range˜
activations ← ⥊⟜(MkData+´) dims
weight ← ⥊⟜(MkData+´) dims
expectedOut ← activations +˝∘×⎉1‿∞ weight

# display expectedOut
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
spOffX‿spOffY ← 150‿170
sys_w_lines ← (sys_interleave + (spOffX‿spOffY‿0‿0⊸+˘ w_lines))
sys_w_start ← 2↑˘sys_w_lines
sys_w_txt_pos ← ((out_wid‿out_wid)÷2)⊸+˘ sys_w_start
sys_w_txt ← (<˘ sys_w_txt_pos) ∾˘ (•Fmt¨ ⥊weight)
•Show sys_w_txt
fontSize ← 20

PerFrame ← {𝕤
    elapsedSecs ← ⌈clock.Time@
    font ← r.font.LoadRaylib@
    {white DrawRectangleLines 𝕩}˘ act_lines
    {white DrawRectangleLines 𝕩}˘ w_lines
    {white DrawRectangleLines 𝕩}˘ out_lines
    {white DrawRectangleLines 𝕩}˘ sys_w_lines
    {white‿font‿fontSize r.draw.Text 𝕩}˘ sys_w_txt
} r.draw._withCanvas⟜black

PerFrame•_While_(¬r.window.ShouldClose)r.window._openAs "DistGEMM"
