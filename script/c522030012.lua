--Nitronome Clearing
local s, id = GetID()
function s.initial_effect(c)
	--Tribute 1 "Nitronome" monster you control; Draw 2 cards. You cannot Summon monsters during the turn you activate this card's effect, except Pyro monsters. You can only activate 1 "Nitronome Clearing" per turn.
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id, ACTIVITY_SUMMON, s.counterfilter)
	Duel.AddCustomActivityCounter(id, ACTIVITY_FLIPSUMMON, s.counterfilter)
	Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)
end
function s.counterfilter(c)
	return c:IsRace(RACE_PYRO)
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return 
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x94c)
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.CheckReleaseGroup(tp, aux.FilterFaceupFunction(Card.IsSetCard, 0x94c), 1, nil)
		and Duel.GetCustomActivityCount(id, tp, ACTIVITY_SUMMON) == 0
		and Duel.GetCustomActivityCount(id, tp, ACTIVITY_FLIPSUMMON) == 0
		and Duel.GetCustomActivityCount(id, tp, ACTIVITY_SPSUMMON) == 0 end
	Duel.Release(Duel.SelectReleaseGroup(tp, aux.FilterFaceupFunction(Card.IsSetCard, 0x94c), 1, 1, nil), REASON_COST)
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(aux.TargetBoolFunction(aux.NOT(Card.IsRace), RACE_PYRO))
	Duel.RegisterEffect(e1, tp)
	local e2 = e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2, tp)
	local e3 = e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e1, tp)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsPlayerCanDraw(tp, 2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Draw(p, d, REASON_EFFECT)
end
