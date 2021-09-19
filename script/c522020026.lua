--Mirror LOCK
function c522020026.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c522020026.condition)
	e1:SetTarget(c522020026.target)
	e1:SetOperation(c522020026.activate)
	c:RegisterEffect(e1)
end
function c522020026.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c522020026.filter(c)
	return c:IsAttackPos() and c:IsSetCard(0xfa3) and c:IsAbleToRemove()
end
function c522020026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c522020026.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c522020026.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c522020026.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	local g=Duel.GetMatchingGroup(c522020026.filter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.BreakEffect()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
