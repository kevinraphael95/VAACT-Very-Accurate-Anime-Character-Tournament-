--ライオ・アリゲーター
--Lion Alligator
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 4611269) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(4611269)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
end
function s.condition(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_REPTILE),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.target(e,c)
	return c:IsRace(RACE_REPTILE)
end