--[VAACT] Magicien Sombre (Version Perso)
local s,id=GetID()

function s.initial_effect(c)
	-- Traité comme le Magicien Sombre officiel (ID 46986414)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(46986414)
	c:RegisterEffect(e0)
end