--[VAACT] Chevalier de la Reine
local s,id=GetID()

function s.initial_effect(c)
	-- Considérée comme la Chevalier de la Reine officielle (ID 89631139)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(89631139)
	c:RegisterEffect(e0)
end