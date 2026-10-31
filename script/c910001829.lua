--超重魔獣キュウ－B
--Superheavy Samurai Beast Kyubi
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 85528209) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(85528209)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsSetCard,SET_SUPERHEAVY_SAMURAI),1,99)
	c:EnableReviveLimit()
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--DEF increase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.sccon)
	e2:SetValue(s.adval)
	c:RegisterEffect(e2)
end
s.listed_series={SET_SUPERHEAVY_SAMURAI}
function s.sccon(e)
	return not Duel.IsExistingMatchingCard(Card.IsSpellTrap,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.adval(e,c)
	return Duel.GetMatchingGroupCount(s.ctfilter,c:GetControler(),0,LOCATION_MZONE,nil)*900
end
function s.ctfilter(c)
	return (c:GetSummonType()&SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end