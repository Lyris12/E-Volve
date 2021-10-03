--UnLOCKed Potential
local s, id = GetID()
function s.initial_effect(c)
	--Shuffle 1 "LOCK" card from your GY into the Deck, then reveal 1 "LOCK" Evolve Monster in your Extra Deck; this turn, you can ignore that monster's summoning condition when Evolve Summoning that monster. You can only activate "UnLOCKED Potential" once per turn.
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(function() e1:SetLabel(1) return true end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsSetCard(0xfa3) and c:IsAbleToDeckAsCost()
end
function s.filter(c)
	return c:IsType(TYPE_EVOLVE) and c:IsSetCard(0xfa3)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		if e:GetLabel() ~= 1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_GRAVE, 0, 1, nil) and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_EXTRA, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	Duel.SendtoDeck(Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil), nil, 2, REASON_COST)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
	local tc = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_EXTRA, 0, 1, 1, nil):GetFirst()
	Duel.BreakEffect()
	Duel.ConfirmCards(1-tp, tc)
	e:SetLabelObject(tc)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IGNORE_EVOLVE_CONDITION)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetLabelObject():RegisterEffect(e1, true)
end
