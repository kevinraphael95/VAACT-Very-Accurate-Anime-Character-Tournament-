--E・HERO ザ・ヒート
--Elemental HERO Heat
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 98266377) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(98266377)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
s.listed_series={SET_ELEMENTAL_HERO}
function s.val(e,c)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,SET_ELEMENTAL_HERO),c:GetControler(),LOCATION_MZONE,0,nil)*200
end