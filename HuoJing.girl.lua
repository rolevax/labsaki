function ondraw()
  local river = game:getriver(self)
  if #river > 0 and is_dora(river[1], mount) then
    decrease_average_gain(game, mount, who)
  end
end

function is_dora(tile, mount)
  if tile:isaka5() then
    return true
  end

  tile = T34.new(tile:id34()) -- bug: cannot apply T34 binary operator to T37
  for _, indic in ipairs(mount:getdrids()) do
    if indic % tile then
      return true
    end
  end

  return false
end

function decrease_average_gain(game, mount, who)
  local hand = game:gethand(who)
  if not hand:ready() then
    return
  end

  local ctx = game:getformctx(who)
  local rule = game:getrule()
  for _, t in ipairs(hand:effa()) do
    local form = Form.new(hand, T37.new(t:id34()), ctx, rule, mount:getdrids())
    if form:han() >= 4 then
      mount:lighta(t, -100)
    end
  end
end
