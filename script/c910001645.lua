--ヘル・ブランブル
--Queen of Thorns
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 45500495) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(45500495)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsRace,RACE_PLANT),1,99)
	c:EnableReviveLimit()
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetTarget(s.sumtg)
	e1:SetCost(s.ccost)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e2)
end
function s.sumtg(e,c)
	return c:GetRace()~=RACE_PLANT
end
function s.ccost(e,c,tp)
	return Duel.CheckLPCost(tp,1000)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,1000)
end