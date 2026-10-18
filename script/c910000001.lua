--[VAACT] Magicienne des Ténèbres (Dark Magician Girl)
local s,id=GetID()
s.listed_names={CARD_DARK_MAGICIAN}
function s.initial_effect(c)
	--Traitée comme la Magicienne des Ténèbres officielle (ID 38033121)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(38033121)
	c:RegisterEffect(e0)
	--Gagne 500 ATK pour chaque "Magicien Sombre" dans les Cimetières
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,30208479,CARD_DARK_MAGICIAN)*500
end