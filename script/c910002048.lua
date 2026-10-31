--捕違い
--Mistaken Arrest
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 4227096) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(4227096)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	if Duel.IsTurnPlayer(tp) then
		e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e1,tp)
end