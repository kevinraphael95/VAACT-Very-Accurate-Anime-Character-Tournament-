--ディメンション・アトラクター
--Dimension Shifter
--scripted by Logical Nonsense
--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 91800273) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(91800273)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Cards sent to GY are banished instead
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
	e1:SetCost(Cost.SelfToGrave)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
	--If no cards in your GY
function s.condition(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_GRAVE,0)==0
end
	--Send this card from hand to GY
	--Cards sent to GY are banished instead, lasts to next turn
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0xff)
	e1:SetReset(RESET_PHASE|PHASE_END,2)
	e1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(e1,tp)
end