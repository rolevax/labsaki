global = {
  scores = { 0, 0, 0, 0 }, -- 各家察岗评分
  daihei_set = {}          -- 呆黑集合
}

function ondraw()
  if rinshan then
    return
  end

  -- 根据察岗评分，影响速度
  local score = global.scores[who:index()]
  local hand = game:gethand(who)
  accelerate(mount, hand, 10 * score)

  -- 呆黑太强
  if global.daihei_set[who:index()] then
    accelerate(mount, hand, 20)
  end
end

function accelerate(mount, hand, mk)
  if mk == 0 then
    return
  end

  for _, t in ipairs(hand:effa()) do
    mount:lighta(t, mk)
  end
end

function ongameevent()
  if event.type == "round-ended" then
    update_scores(game, event.args)
  elseif event.type == "round-started" then
    print("当前察岗评分：")
    print("自", global.scores[self:index()],
          "下", global.scores[self:right():index()],
          "对", global.scores[self:cross():index()],
          "上", global.scores[self:left():index()])
  end
end

function update_scores(game, args)
  if args.result == "RON" then
    local gi = args.gunner:index()
    global.scores[gi] = global.scores[gi] - 3

    if args.gunner == self then
      for _, daihei in ipairs(args.openers) do
        global.daihei_set[daihei:index()] = true
      end
    end
  end

  local everyone = { self, self:right(), self:cross(), self:left() }
  for _, who in ipairs(everyone) do
    local hand = game:gethand(who)
    if not hand:ismenzen() then
      local wi = who:index()
      global.scores[wi] = global.scores[wi] + 1
    end
  end
end

