--AlphaLOCK Duos Dracos
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--mat=2 "LOCK" Dragon monsters
	Fusion.AddProcFunRep(c, s.mfilter, 2, true)
	--This card can attack monsters your opponent controls twice during the Battle Phase.
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--If this card was Fusion Summoned using a monster your opponent controls as 1 of the materials, this card gains 800 ATK.
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	c:RegisterEffect(e2)
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(function() return e2:GetLabel() == 1 end)
	e3:SetValue(800)
	tc:RegisterEffect(e3)
end
function s.mfilter(c)
	return c:IsSetCard(0xfa3) and c:IsRace(RACE_DRAGON)
end
function s.afilter(c, p)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(p)
end
function s.valcheck(e, c)
	e:SetLabel(c:GetMaterial():FilterCount(s.afilter, nil, 1-tp))
end
