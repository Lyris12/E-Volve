--Bright Shadow, Melody of Mischief
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--mat = 1 DARK Warrior Effect Monster
	Link.AddProcedure(c, s.mfilter, 1, 1)
	--If your opponent Summons a monster (Quick Effect): You can target that monster; change its name to "Bright Shadow, Melody of Mischief", and if you do, return this card to your Extra Deck.
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3 = e1:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_EFFECT)
end
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	if not eg or #eg ~= 1 then return false end
	return eg:GetFirst():IsSummonPlayer(1-tp)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if not eg then return false end
	local tc = eg:GetFirst()
	if chkc then return chkc == tc end
	if chk == 0 then return tc:IsFaceup() and tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, e:GetHandler(), 1, 0, 0)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = eg:GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(id)
		tc:RegisterEffect(e1)
		Duel.SendtoDeck(c, nil, 2, REASON_EFFECT)
	end
end
