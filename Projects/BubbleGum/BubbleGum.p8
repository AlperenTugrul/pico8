pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

-- bubblegum
-- by luisfl.me
-- compiled: 24/08/20 12:59:46

-- 1_init.lua

function _init()
    mode = "game"

    -- player
    p = {}
    p.x = 16
    p.y = 112
    p.dx = 0
    p.dy = 0
    p.s = 2
    p.f = 0
    p.a = -1
    p.d = 0
    p.j = false

    -- map
    m = {}
    m.x = -128
    m.y = 0
    m.px = 0
    m.a_l = false
    m.a_r = false
end

-- 2_update.lua

function _update60()
    if mode != "end" then updategame() end
end

-- updategame
function updategame()
    if not(m.a_l) and not(m.a_r) then
        updateplayer()
    end
end

function updateplayer()
    updatemovement()
    updatesprite()
    updatemap()
end

function updatemovement()
    -- jump
    if (btnp(4) or btnp(5)) and not(p.j) then 
        p.j = true
        if btnp(0) then p.dx = -0.25
        elseif btnp(1) then p.dx = 0.25 end
    end

    if p.j then p.f += 1 p.dy = (p.f - 30)/30 end

    -- movement
    if btn(0) and p.j then p.dx -= 0.025
    elseif btn(1) and p.j then p.dx += 0.025 end

    local nextx = p.x + p.dx
    local nexty = p.y + p.dy

    if not(tileaside(nextx)) then p.x = nextx end
    if not(floorbelow(nexty)) then p.y = nexty
    else 
        if p.a < 0 and p.j then p.a = 0 end 
        p.y = (cy-1)*8 p.dx = 0 p.j = false p.f = 0 
    end
end

function tileaside(nextx)
    local cx = flr((abs(m.x)/128)*16+flr((nextx-0.5)/8))
    local cy = flr((abs(m.y)/128)*16+flr(p.y/8))
    if fget(mget(cx, cy), 0) or fget(mget(cx+1, cy), 0) then
        return true
    end return false
end

function floorbelow(nexty)
    local cx = flr((abs(m.x)/128)*16+flr(p.x/8))
    cy = flr((abs(m.y)/128)*16+flr((nexty+7)/8))
    if fget(mget(cx, cy), 0) or fget(mget(cx+1, cy), 0) then 
        return true 
    end return false
end

function updatesprite()
    -- jumping
    if not(p.j) then p.s = 2
    else
        if p.dx < 0 then p.s = 10
        elseif p.dx > 0 then p.s = 11
        else p.s = 9 end
    end

    -- after jump
    if p.a > 14 then p.a = -1 end
    if p.a > -1 then 
        if p.a > 2 then p.s = 3 end 
        p.a += 1 
    end
end

function updatemap()
    if p.x < -4 then m.a_l = true m.px = m.x + 128
    elseif p.x > 124 then m.a_r = true m.px = m.x - 128
    end
end

-- 3_draw.lua

function _draw()
    cls(1)
    palt(8, true) palt(0, false)
    map(0, 0, m.x, m.y, 48, 16)
    drawtitlescreen()
    animatemap()
    spr(p.s, p.x, p.y)
end

function drawtitlescreen()
    print("❎/🅾️ jump", m.x + 128 + 16, 88, 1)
    print("move ⬅️/➡️", m.x + 128 + 73, 88, 1)
    sspr(0, 32, 48, 32, m.x + 128 + 16, 16, 96, 64)
end

function animatemap()
    local x = abs(m.px - m.x)
    if m.a_l then
        if x > 1 then m.x += 4*(x/32) p.x += 4*(x/32)
        else m.a_l = false m.x += x p.x += x end
    elseif m.a_r then
        if x > 1 then m.x -= 4*(x/32) p.x -= 4*(x/32)
        else m.a_r = false m.x -= x p.x -= x end
    end
end

__gfx__
00000000dddddddd8888888888888888111111111111111122222222222222220005500088777788887777888877778800000000000000000000000000000000
00000000dddddddd8877778888888888111111111aa1aa11222222222aa2aa220056750087eeee7887eeee7887eeee7800000000000000000000000000000000
00700700dddddddd87eeee7888777788111111111aa1aa11222222222aa2aa22005675007eeeeee77eeeeee77eeeeee700000000000000000000000000000000
00077000dddddddd7eeeeee787eeee7811111111111111112222222222222222056667507e0ee0e770ee0ee77ee0ee0700000000000000000000000000000000
00077000dddddddd7eeeeee77eeeeee7111111111aa1aa11222222222aa2aa22056667507eeeeee77eeeeee77eeeeee700000000000000000000000000000000
00700700dddddddd7e0ee0e77eeeeee7111111111aa1aa11222222222aa2aa22566666657eeeeee77eeeeee77eeeeee700000000000000000000000000000000
00000000dddddddd7eeeeee77e0ee0e7111111111aa1aa11222222222aa2aa22566666657eeeeee77eeeeee77eeeeee700000000000000000000000000000000
00000000dddddddd8777777887777778111111111111111122222222222222225666666587777778877777788777777800000000000000000000000000000000
55555555111111155666666600000000dd00000000000000000000dd000777777700000000000000000000000000000000000000000000000000000000000000
11111111111111155666666600000000d0444444444444444444440d077777777777000000000070700770777070707770000000000000000000000000000000
11151111111511155666666600000000040000000000000000000040775555555557700000000070707070707070700070000000000000000000000000000000
11111111111111155666666600000000040000000000000000000040755555555555700000000070707070770077000770000000000000000000000000000000
11111151111111551566666600000000040000000000000000000040777555555577777000000077707070707070700000000000000000000000000000000000
11111111111111151155666600000000040000000000000000000040777777777777777700000077707700707070700700000000000000000000000000000000
11111111111111155111555600000000040000000000000000000040777777777777707700000000000000000000000000000000000000000000000000000000
15111111151111151115111500000000040000000000000000000040777777777777700700000000000000000000000000000000000000000000000000000000
55555555111111156666666600000000040000000000000000000040777777777777700700000000000000000000000000000000000000000000000000000000
11111111111111156666666600000000040000000000000000000040777777777777707700000000000000000000000000000000000000000000000000000000
15111111151111156666666600000000040000000000000000000040770777777707777000000077707770707077700000777700000000000000000000000000
11111115111111156666666600000000040000000000000000000040777777777777770000000070000700707070700000171700000000000000000000000000
11111111111111156666666600000000040000000000000000000040777000000077700000000077000700770077700009999770000000000000000000000000
11111111111111156666666600000000040000000000000000000040777700000777700000000070000700707070700000777770000000000000000000000000
11115111111151156666666600000000040000000000000000000040077777777777000000000070007770707070707000777770000000000000000000000000
11111111111111156666666600000000040000000000000000000040000777777700000000000000000000000000000000000000000000000000000000000000
11111111111111516604f066dd04f0dd0400000000000000000000405111111151111111ddd55555000000000000000000000000000000000000000000000000
11111111111111116604f066dd04f0dd0400000000000000000000405111111151111111d5511111000000000000000000000000000000000000000000000000
11151111111111116604f066dd04f0dd040000000000000000000040511511115511111151111151000000000000000000000000000000000000000000000000
11111111151111116604f066dd04f0dd040000000000000000000040511111115111111151111111000000000000000000000000000000000000000000000000
11111151111111116604f066dd04f0dd040000000000000000000040511111515111111151111111000000000000000000000000000000000000000000000000
11111111111151116604f066dd04f0dd040000000000000000000040511111115111111151111111000000000000000000000000000000000000000000000000
11111111111111116604f066dd04f0ddd04444444444444444444402511111115111511151115111000000000000000000000000000000000000000000000000
15111111111111116604f066dd04f0dddd0000000000000000000022511111115111111151111111000000000000000000000000000000000000000000000000
80000080000080000080000080088880000088888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
06666006606606666006666006608806666608888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
06666606606606666606666606608806666608888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
06606606606606606606606606608806600088888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
06666006606606666006666006608806666608888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
06666606606606666606666606608806666608888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
06606606606606606606606606600006600088888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
06666d06666d06666d06666d06666d06666d08888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
0ddddd00dddd0ddddd0ddddd0ddddd0ddddd08888888888800000000000000000000222222200000000000000000000000000000000000000000000000000000
80000088000080000080000080000080000088888888888800000000000000000022eeeeeee22000000000000000000000000000000000000000000000000000
888888888888888888888888888888888888888888888888000000000000000002eeeeeeeeeee200000000000000000000000000000000000000000000000000
888822222222888888822288822288888882222222228888000000000000000002eeeeeeeeeee200000000000000000000000000000000000000000000000000
8822eeeeeeee2288822eee282eee2288822eeeeeeeee228800000000000000002eeeeeeeeeeee200000000000000000000000000000000000000000000000000
82eeeeeeeeeeee282eeeeee2eeeeee282eeeeeeeeeeeee2800000000000000002eeeeeeeeeeee200000000000000000000000000000000000000000000000000
82eeeeeeeeeeee282eeeeee2eeeeee282eeeeeeeeeeeee2800000000000000002eeeeeee22222000000000000000000000000000000000000000000000000000
2eeeeeeeeeeeeee2eeeeeee2eeeeeee2eeeeeeeeeeeeeee200000000000000002eeeee22eeeee200000000000000000000000000000000000000000000000000
2eeeeeeeeeeeeee2eeeeeee2eeeeeee2eeeeeeeeeeeeeee200000000000000002eeee2eeeeeeee20000000000000000000000000000000000000000000000000
2eeeeeeeeeeeeee2eeeeeee2eeeeeee2eeeeeeeeeeeeeee200000000000000002eee2eeeeeeeee20000000000000000000000000000000000000000000000000
2eeeeeeeeeeeee22eeeeeee2eeeeeee2eeeeeeeeeeeeeee200000000000000002eee2eeeeeeeee20000000000000000000000000000000000000000000000000
2eeee22222222282eeeeeee2eeeeeee2eeeeeeeeeeeeeee200000000000000002eeee22eeeeeee20000000000000000000000000000000000000000000000000
2eee2eeeeeeeee22eeeeeee2eeeeeee2eeeee2eee2eeeee2000000000000000002eeeeeeeeeeee20000000000000000000000000000000000000000000000000
2eee2eeeeeeeeee2eeeeeee2eeeeeee2eeeee2eee2eeeee2000000000000000002eeeeeeeeeeee20000000000000000000000000000000000000000000000000
2eee2eeeeeeeeee2eeeeeee2eeeeeee2eeeee2eee2eeeee200000000000000000022eeeeeeee2200000000000000000000000000000000000000000000000000
2eeee2222222eee2eeeeeee2eeeeeee2eeeee2eee2eeeee200000000000000000000222222220000000000000000000000000000000000000000000000000000
2eeeeeeeeeeeeee2eeeeeeeeeeeeeee2eeeee2eee2eeeee200000000000000000000000000000000000000000000000000000000000000000000000000000000
2eeeeeeeeeeeee72eeeeeeeeeeeeee72eeeee2eee2eeee7200000000000000000000000000000000000000000000000000000000000000000000000000000000
2eeeeeeeeeeeee72eeeeeeeeeeeeee72eeeee2eee2eeee7200000000000000000000000000000000000000000000000000000000000000000000000000000000
2eeeeeeeeeeeee72eeeeeeeeeeeeee72eeeee2eee2eeee7200000000000000000000000000000000000000000000000000000000000000000000000000000000
82eeeeeeeeeee7282eeeeeeeeeeee7282eeee2eee2eee72800000000000000000000000000000000000000000000000000000000000000000000000000000000
82eeeeeeeeee77282eeeeeeeeeee77282eeee2eee2eee72800000000000000000000000000000000000000000000000000000000000000000000000000000000
88227777777722888227777777772288827728222827728800000000000000000000000000000000000000000000000000000000000000000000000000000000
88882222222288888882222222228888882288888882288800000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000001010100000000000000000000000000010100000000000000000000000000000000000000000001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1101141515151515151601010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2101241718191a1b1c2601040404040101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1101242728292a2b2c2606040504050101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2101343535353535353606040404040101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1101010133010133060706040504050101010101010101010101010101010101010101010101010139201020102010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2101010133010133060606040404040101010101010101010101010101010101010101010101010138313031303130310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1122222232222232222222222222222222222222222222222222222222222222222222222222222237303130313031300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3120102010201020102010102020102010201020102010201020102010201020102010201020102030313031303130310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100002805500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500000c05518051240513000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105000017000150001300011000100000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500002805500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00002805528035280152805528035280152805528035000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000201115500000141550000018155000001b155000000c155000000f15500000131550000018155000000d155000001115500000141550000019155000000a155000000f1550000013155000001615500000
011000200505500000050550000005055000000505500000000550e00000055000000005500000000550000001055000000105500000010550000001055000000305500000030550000003055000000405510000
0110002020551205412053120521205110000000000000001f5511f5411f5311f5211f51100000000000000020551205412053120521205110000000000000001d5511d5411d5311d5211d511110001f5511f541
0110002020551205412053120521205110000000000000001f5511f5411f5311f52124551245411f5311f5211d5511d5511c5511b5511b5411b5311b5001b500185511854118531185211f5511f5411f5311f521
011000000c0531861518615246250c0531861524625186150c0531861518615246250c0531861524625186150c0531861518615246250c0531861524625186150c0532462518615246250c053186152462518615
__music__
01 10111214
00 10111214
00 10111214
02 10111314

