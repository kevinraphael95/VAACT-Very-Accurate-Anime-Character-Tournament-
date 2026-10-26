--ドラゴンに乗るワイバーン
--Alligator's Sword Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : Considérée comme la carte officielle (ID 3366982) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(3366982)
	c:RegisterEffect(e_add_code)
	-- ================================================================
	c:EnableReviveLimit()
	--Fusion Material
	Fusion.AddProcMix(c,true,true,88819587,64428736)
	--Can attack directly
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(s.dircon)
	c:RegisterEffect(e2)
end
function s.dircon(e)
	local ATTRIBUTE_EARTH_WATER_FIRE=ATTRIBUTE_EARTH|ATTRIBUTE_WATER|ATTRIBUTE_FIRE
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
	local ct=#g
	return ct>0 and g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH_WATER_FIRE)==ct
end