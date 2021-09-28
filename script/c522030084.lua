--Nitronome Reaction
local s, id = GetID()
function s.initial_effect(c)
	--If your opponent declares a direct attack: You can send 1 "Nitronome" monster from your face-up Extra Deck to the GY; Negate that attack, and if you do, end the Battle Phase.
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	local at = Duel.GetAttacker()
	return at:IsControler(1-tp) and Duel.GetAttackTarget() == nil
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x94c) and c:IsAbleToGraveAsCost()
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_EXTRA, 0, 1, nil) end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	if Duel.NegateAttack() then Duel.SkipPhase(1-tp, PHASE_BATTLE, RESET_PHASE+PHASE_BATTLE_STEP, 1) end
end
