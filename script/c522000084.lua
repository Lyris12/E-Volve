--Mystical Phantasmagoria
local s, id = GetID()
function s.initial_effect(c)
	--Special Summon 1 DREAM monster from your hand, then your opponent draws 1 card.
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--If you summon a Level 5 or higher DREAM monster by this effect: Your opponent draws 1 additional card, also that monster cannot attack or activate its effects this turn.
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_CUSTOM+id)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCategory(CATEGORY_DRAW)
	e2:SetLabelObject(e1)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.filter(c, e, tp)
	return c:IsAttribute(ATTRIBUTE_DREAM) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND, 0, 1, nil, e, tp) and Duel.IsPlayerCanDraw(1-tp, 1) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, 1-tp, 1)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local tc = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp):GetFirst()
	if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP_ATTACK) > 0 then
		Duel.BreakEffect()
		Duel.Draw(1-tp, 1, REASON_EFFECT)
		if tc:IsLevelAbove(5) then
			e:SetLabelObject(tc)
			Duel.RaiseSingleEvent(e:GetHandler(), EVENT_CUSTOM+id, e, r, rp, tp, 0)
		end
	end
end
function s.tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, 1-tp, 1)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Draw(1-tp, 1, REASON_EFFECT)
	local tc = e:GetLabelObject():GetLabelObject()
	if not tc then return end
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
end
