--Mirror LOCK
local s, id = GetID()
function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return tp ~= Duel.GetTurnPlayer()
end
function s.filter(c)
	return c:IsAttackPos() and c:IsSetCard(0xfa3) and c:IsAbleToRemove()
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) end
	local g = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, #g, 0, 0)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	if not Duel.NegateAttack() then return end
	local g = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil)
	if #g > 0 then
		Duel.BreakEffect()
		Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
	end
end
